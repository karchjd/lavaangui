import { get } from "svelte/store";
import { appState, cyStore, modelOptions, fitCache, gridViewOptions, setAlert } from "../stores";
import app from "../main";

export function tolavaan(mode) {
  var appState_local = get(appState);
  //just in case I forgot a call to tolavaan somewhere
  if (!appState_local.full) {
    return
  }

  let cy = get(cyStore);
  const edges = cy.edges();

  for (var i = 0; i < edges.length; i++) {
    edges[i].removeEstimates();
  }

  if (cy.getUserEdges().length == 0) {
    cy.getLavaanNodes().remove()
    cy.getLavaanEdges().remove()
    return;
  }

  if (
    !appState_local.dataAvail && mode == "estimate") {
    setAlert("danger", "Model not send to lavaan because no data available",);
    return;
  }






  let for_R = createSyntax(mode);
  // @ts-expect-error
  Shiny.setInputValue("run-fromJavascript", JSON.stringify(for_R));
  // @ts-expect-error
  Shiny.setInputValue("runCounter", Math.random());
  if (mode === "user model") {
    cy.getLavaanModifiedEdges().forEach((existingEdge) => {
      existingEdge.freePara()
    });
  }
  // TODO: remove? appState_local.loadingMode = false;
}

function containsObject(list, obj) {
  for (let i = 0; i < list.length; i++) {
    if (list[i] === obj) {
      return true;
    }
  }
  return false;
}

function addTerms(node, edge) {
  let node_label;
  if (node == undefined) {
    node_label = "1";
  } else {
    node_label = node.getLabel();
  }
  let premultiplier = false;
  let formula;
  if (edge.isFixed() && !edge.isModifiedLavaan()) {
    formula = edge.getValue() + "*" + node_label;
    premultiplier = true;
  } else if (edge.isForceFree()) {
    formula = "NA*" + node_label;
    premultiplier = true;
  }

  if (edge.hasLabel()) {
    const label = edge.getLabel();
    if (!premultiplier) {
      premultiplier = true;
      formula = label + "*" + node_label;
    } else {
      formula += " + " + label + "*" + node_label;
    }
  } else {
    if (!premultiplier) {
      formula = node_label;
    }
  }
  return formula;
}

class DataForR {
  constructor(mode, R_script, lavOptions = null, syntax = null, fitCache = null, ordered_labels = null) {
    this.mode = mode;
    Object.assign(this, {
      model: {
        options: lavOptions,
        syntax: syntax,
        R_script: R_script,
        ordered_labels: ordered_labels
      },
      forceUpdate: Math.random(),
      cache: fitCache
    });
  }
}


export function createSyntax(mode) {
  let cy = get(cyStore);
  let appSt = get(appState);
  let syntax = "";
  let R_script = "";
  const run = mode !== "user model"

  R_script += "library(lavaan)" + "\n";
  if (appSt.dataAvail) {
    R_script += `data <- read.csv(\"${appSt.loadedFileName}\")\n`;
  } else {
    R_script +=
      "#make sure your data is loaded into the 'data' variable" + "\n";
  }

  // measurement model
  const latentNodes = cy.getLatentNodes()
  let shown = false;
  for (let i = 0; i < latentNodes.length; i++) {
    const latentNode = latentNodes[i];
    let nodeNames = "";
    const connectedEdges = latentNode.connectedEdges(function (edge) {
      return (
        edge.isDirected() &&
        edge.source().id() == latentNode.id() &&
        edge.target().isObserved()
      );
    });
    if (connectedEdges.length > 0) {
      if (!shown) {
        syntax += "# measurement model" + "\n";
        shown = true;
      }

      const xRange =
        Math.max(...connectedEdges.map((edge) => edge.target().position().x)) -
        Math.min(...connectedEdges.map((edge) => edge.target().position().x));

      const yRange =
        Math.max(...connectedEdges.map((edge) => edge.target().position().y)) -
        Math.min(...connectedEdges.map((edge) => edge.target().position().y));

      const sortBy = xRange >= yRange ? "x" : "y";

      const sortedIndices = connectedEdges
        .map((edge, index) => ({
          index,
          value: edge.target().position()[sortBy],
        }))
        .sort((a, b) => a.value - b.value)
        .map((item) => item.index);

      for (let j = 0; j < connectedEdges.length; j++) {
        const node = connectedEdges[sortedIndices[j]].target();
        if (j > 0) {
          nodeNames += " + ";
        }

        nodeNames += addTerms(node, connectedEdges[sortedIndices[j]]);
      }
      syntax += " " + latentNode.getLabel() + " =~ " + nodeNames + "\n";
    } else if (latentNode.connectedEdges(function (edge) {
      return (edge.isUserAdded())
    }).length > 0) {
      if (!shown) {
        syntax += "# measurement model" + "\n";
        shown = true;
      }
      syntax += " " + latentNode.getLabel() + " =~ 0" + "\n";
    }
  }

  // regression

  function regression_edge(edge) {
    let res = edge.isDirected() &&
      !edge.source().isConstant() &&
      !(
        edge.source().isLatent() &&
        edge.target().isObserved()
      ) && (edge.isUserAdded() || edge.isModifiedLavaan())
    return res;

  }
  let reg_edges = cy.edges(regression_edge);
  let reg_nodes = [];
  for (let i = 0; i < reg_edges.length; i++) {
    if (!containsObject(reg_nodes, reg_edges[i].target())) {
      reg_nodes.push(reg_edges[i].target());
    }
  }

  if (reg_nodes.length > 0) {
    syntax += "\n" + "# regressions";
    for (let i = 0; i < reg_nodes.length; i++) {
      const targetNode = reg_nodes[i];
      const connectedEdges = targetNode.connectedEdges(edge => regression_edge(edge) && edge.target().same(targetNode));
      if (connectedEdges.length > 0) {
        let nodeNames = "";
        for (var j = 0; j < connectedEdges.length; j++) {
          var node = connectedEdges[j].source();
          if (j > 0) {
            nodeNames += " + ";
          }
          nodeNames += addTerms(node, connectedEdges[j]);
        }
        syntax += "\n " + targetNode.getLabel() + " ~ " + nodeNames;
      }
    }
  }

  // covariances
  let cov_edges = cy.edges(function (edge) {
    return (
      (edge.isUndirected() || edge.myIsLoop()) &&
      (edge.isUserAdded() || edge.isModifiedLavaan())
    );
  });
  if (cov_edges.length > 0) {
    syntax += "\n\n" + "# residual (co)variances";
    for (let i = 0; i < cov_edges.length; i++) {
      let node1 = cov_edges[i].source().data("label");
      syntax +=
        "\n " + node1 + " ~~ " + addTerms(cov_edges[i].target(), cov_edges[i]);
    }
  }

  // mean structure
  const constant_nodes = cy.nodes(function (node) {
    return node.isConstant();
  });
  for (let i = 0; i < constant_nodes.length; i++) {
    const c_node = constant_nodes[i];
    const connectedEdges = c_node.connectedEdges(function (edge) {
      return edge.isUserAdded();
    });
    if (connectedEdges.length > 0) {
      syntax += "\n" + "# intercepts" + "\n";
      for (var j = 0; j < connectedEdges.length; j++) {
        var node = connectedEdges[j].target();
        syntax +=
          node.getLabel() +
          " ~ " +
          addTerms(undefined, connectedEdges[j]) +
          "\n";
      }
    }
  }

  syntax = "'\n" + syntax + "'" + "\n\n";
  function splitLongLines(inputStr, threshold = 60) {
    return inputStr.split('\n').map(line => {
      if (line.includes('+') && line.length > threshold) {
        const parts = line.split(' + ');
        let newLines = [];
        let currentLine = parts[0];
        const initialIndent = line.match(/^\s*/)[0]; // Capture leading whitespace for indentation
        const indentLength = currentLine.indexOf('~') + 1;
        for (let i = 1; i < parts.length; i++) {
          if (currentLine.length + parts[i].length + 3 > threshold) {
            newLines.push(currentLine + ' + ');
            currentLine = initialIndent + ' '.repeat(indentLength) + parts[i];
          } else {
            currentLine += ' + ' + parts[i];
          }
        }
        newLines.push(currentLine); // Push the last line
        return newLines.join('\n');
      }
      return line;
    }).join('\n');
  }

  syntax = splitLongLines(syntax);

  // check for ordered nodes
  let ordered_nodes = cy.nodes(function (node) {
    return node.isOrdered();
  });

  const ordered_labels = ordered_nodes.map(node => node.getLabel());


  const lavOptions = produceLavaanOptions(ordered_labels);

  R_script += "model <-" + syntax;
  R_script += "result <- lavaan(model, data, " + lavOptions;
  const for_R = new DataForR(mode, R_script, lavOptions, syntax = syntax, get(fitCache), ordered_labels)
  return for_R;
}

function produceLavaanOptions(ordered_labels) {
  const modelOpt = get(modelOptions);
  const meanStruc = boolToString(modelOpt.meanStruc);
  const ovFree = boolToString(modelOpt.intOvFree);
  const lvFree = boolToString(modelOpt.intLvFree);

  let options = `meanstructure = ${meanStruc},
\t\t int.ov.free = ${ovFree}, int.lv.free = ${lvFree},
\t\t estimator = ${addQuotes(modelOpt.estimator)}, se = ${addQuotes(
    modelOpt.se
  )},
\t\t missing = ${addQuotes(modelOpt.missing)}, auto.fix.first = ${boolToString(
    modelOpt.fix_first
  )},
\t\t auto.fix.single = ${boolToString(
    modelOpt.fix_single
  )}, auto.var = ${boolToString(modelOpt.auto_var)},
\t\t auto.cov.lv.x = ${boolToString(
    modelOpt.auto_cov_lv_x
  )}, auto.cov.y = ${boolToString(modelOpt.auto_cov_y)},
  \t\t fixed.x = ${boolToString(modelOpt.fixed_x)}`;
  if (modelOpt.se == "boot") {
    const additional = `, bootstrap = ${modelOpt.n_boot})`;
    options = options + additional;
  } else {
    options = options + ")";
  }

  if (ordered_labels.length > 0) {
    const ordered_arg = 'c("' + ordered_labels.join('", "') + '")'
    options = `ordered = ${ordered_arg}, ${options}`
  }
  return options;
}

function addQuotes(inputString) {
  return '"' + inputString + '"';
}

function boolToString(boolValue) {
  if (boolValue == true || boolValue == "true") {
    return "TRUE";
  } else if (boolValue == false || boolValue == "false") {
    return "FALSE";
  } else if (boolValue == "default") {
    return '"default"';
  }
  throw new Error("Should not happen");
}
