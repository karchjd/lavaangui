import { get } from "svelte/store";
import { appState, cyStore, modelOptions, fitCache, gridViewOptions, setAlert } from "../stores";

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
    // @ts-ignore
    Shiny.setInputValue("show_help", Math.random());
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
  constructor(mode, R_script, lavOptions = null, syntax = null, fitCache = null, ordered_labels = null, lavOptionsList = null) {
    this.mode = mode;
    Object.assign(this, {
      model: {
        options: lavOptions,
        optionsList: lavOptionsList,
        syntax: syntax,
        R_script: R_script,
        ordered_labels: ordered_labels
      },
      forceUpdate: Math.random(),
      cache: fitCache
    });
  }
}


function getNodeNames(connectedEdges, positionWhich = "target") {
  let nodeNames = "";
  const xRange =
    Math.max(...connectedEdges.map((edge) => edge[positionWhich]().position().x)) -
    Math.min(...connectedEdges.map((edge) => edge[positionWhich]().position().x));

  const yRange =
    Math.max(...connectedEdges.map((edge) => edge[positionWhich]().position().y)) -
    Math.min(...connectedEdges.map((edge) => edge[positionWhich]().position().y));

  const sortBy = xRange >= yRange ? "x" : "y";

  const sortedIndices = connectedEdges
    .map((edge, index) => ({
      index,
      value: edge.target().position()[sortBy],
    }))
    .sort((a, b) => a.value - b.value)
    .map((item) => item.index);



  for (let j = 0; j < connectedEdges.length; j++) {
    const node = connectedEdges[sortedIndices[j]][positionWhich]();
    if (j > 0) {
      nodeNames += " + ";
    }

    nodeNames += addTerms(node, connectedEdges[sortedIndices[j]]);
  }

  return nodeNames;
}


export function createSyntax(mode) {
  let cy = get(cyStore);
  let appSt = get(appState);
  let syntax = "";
  let R_script = "";
  const run = mode !== "user model"
  let formative = false;

  R_script += "library(lavaan)" + "\n";
  if (appSt.dataAvail) {
    R_script += `data <- read.csv(\"${appSt.loadedFileName}\")\n`;
  } else {
    R_script +=
      "#make sure your data is loaded into the 'data' variable" + "\n";
  }


  // all outgoing edges point to latent variables
  let hierachicalFactors = cy.getLatentNodes()
  hierachicalFactors = hierachicalFactors.nodes(function (node) {
    const outgoing = node.connectedEdges(function (edge) {
      return edge.isDirected() && edge.source().id() == node.id()
    })
    return outgoing.length > 0 && outgoing.every(edge => edge.target().isLatent() || edge.target().isComposite())
  })

  // to help detect composites, only incoming arrows
  let formativeFactors = cy.getComposites()

  // measurement model
  let latentNodes = cy.getLatentNodes()
  let shown = false;
  for (let i = 0; i < latentNodes.length; i++) {
    const latentNode = latentNodes[i];
    let nodeNames = "";
    const connectedEdges = latentNode.connectedEdges(function (edge) {
      return (
        edge.isDirected() &&
        edge.source().id() == latentNode.id() &&
        ((edge.target().isObserved() && edge.isFactLoad()) ||
          hierachicalFactors.some(node => node.id() === latentNode.id())) //add measurement equation also if source is a hierachical factor
      );
    });
    if (connectedEdges.length > 0) {
      if (!shown) {
        syntax += "# measurement model" + "\n";
        shown = true;
      }
      syntax += " " + latentNode.getLabel() + " =~ " + getNodeNames(connectedEdges, "target") + "\n";
    }
  }

  // regression

  function regression_edge(edge) {
    let res = edge.isDirected() &&
      !edge.source().isConstant() &&
      (!(edge.source().isLatent() && edge.target().isObserved()) || edge.isRegression()) && // only if edge is explicitly marked as regression for arrows from latent to observed
      !(edge.source().isLatent() && hierachicalFactors.some(node => node.id() === edge.source().id()) && (edge.target().isLatent() || edge.target().isComposite())) &&
      (edge.isUserAdded() || edge.isModifiedLavaan()) &&
      (!(edge.target().isComposite() && edge.source().isObserved()) || edge.isCompRegression()); // only if edge is explicitly marked as regression for arrows from observed to composite
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
    syntax += "\n # regressions \n";
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
        syntax += " " + targetNode.getLabel() + " ~ " + nodeNames + "\n";
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
    syntax += "\n" + "# (residual) (co)variances \n";
    for (let i = 0; i < cov_edges.length; i++) {
      let node1 = cov_edges[i].source().data("label");
      syntax +=
        " " + node1 + " ~~ " + addTerms(cov_edges[i].target(), cov_edges[i]) + "\n";
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
        syntax += " " + node.getLabel() + " ~ " + addTerms(undefined, connectedEdges[j]) +
          "\n";
      }
    }
  }

  // composites
  shown = false;
  for (let i = 0; i < formativeFactors.length; i++) {
    const formativeNode = formativeFactors[i];
    let nodeNames = "";
    const connectedEdges = formativeNode.connectedEdges(function (edge) {
      return (
        edge.isDirected() &&
        edge.target().id() == formativeNode.id() &&
        edge.source().isObserved() &&
        edge.isCompLoad()
      );
    });
    if (connectedEdges.length > 0) {
      if (!shown) {
        formative = true;
        syntax += "\n # composites" + "\n";
        shown = true;
      }
      syntax += " " + formativeNode.getLabel() + " <~ " + getNodeNames(connectedEdges, "source") + "\n";
    }
  }

  // remove empty lines caused by sections not existing
  syntax = syntax.replace(/^(\s*\n)+/, '')

  // raw syntax for R execution (no wrapping quotes, no eval needed)
  const rawSyntax = syntax;

  // split lines that are two long
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


  const lavOptions = produceLavaanOptions(ordered_labels, formative);
  const lavOptionsList = produceLavaanOptionsList(ordered_labels, formative);

  R_script += "model <-" + syntax;
  R_script += "fit <- lavaan(model, data, " + lavOptions;
  const for_R = new DataForR(mode, R_script, lavOptions, rawSyntax, get(fitCache), ordered_labels, lavOptionsList)
  return for_R;
}

function produceLavaanOptions(ordered_labels, formative) {
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
  \t\t fixed.x = ${boolToString(modelOpt.fixed_x)}, auto.th = ${boolToString(modelOpt["auto.th"])}, 
  \t\t auto.delta = ${boolToString(modelOpt["auto.delta"])}`;

  // optional addons
  if (modelOpt.se == "boot") {
    options = options + `, bootstrap = ${modelOpt.n_boot}`;
  }
  if (formative) {
    options = options + `,\n\t\t optim.gradient = "numerical"`;
  }
  if (ordered_labels.length > 0) {
    const ordered_arg = 'c("' + ordered_labels.join('", "') + '")'
    options = `ordered = ${ordered_arg}, 
    \t\t ${options}`
  }

  options = options + ")";

  return options;
}

function produceLavaanOptionsList(ordered_labels, formative) {
  const modelOpt = get(modelOptions);
  const opts = {
    meanstructure: convertBool(modelOpt.meanStruc),
    "int.ov.free": convertBool(modelOpt.intOvFree),
    "int.lv.free": convertBool(modelOpt.intLvFree),
    estimator: modelOpt.estimator,
    se: modelOpt.se,
    missing: modelOpt.missing,
    "auto.fix.first": convertBool(modelOpt.fix_first),
    "auto.fix.single": convertBool(modelOpt.fix_single),
    "auto.var": convertBool(modelOpt.auto_var),
    "auto.cov.lv.x": convertBool(modelOpt.auto_cov_lv_x),
    "auto.cov.y": convertBool(modelOpt.auto_cov_y),
    "fixed.x": convertBool(modelOpt.fixed_x),
    "auto.th": convertBool(modelOpt["auto.th"]),
    "auto.delta": convertBool(modelOpt["auto.delta"]),
  };

  if (modelOpt.se == "boot") {
    opts.bootstrap = modelOpt.n_boot;
  }
  if (formative) {
    opts["optim.gradient"] = "numerical";
  }
  if (ordered_labels.length > 0) {
    opts.ordered = ordered_labels;
  }

  return opts;
}

function convertBool(value) {
  if (value === true || value === "true") return true;
  if (value === false || value === "false") return false;
  return value;
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
