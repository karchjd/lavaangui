import { get } from "svelte/store";
import { appState, cyStore, modelOptions } from "../stores";

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
    node_label = node.data("label");
  }
  let premultiplier = false;
  let formula;
  if (edge.hasClass("fixed") && !edge.hasClass("byLav")) {
    formula = edge.data("value") + "*" + node_label;
    premultiplier = true;
  } else if (edge.hasClass("forcefree")) {
    formula = "NA*" + node_label;
    premultiplier = true;
  }

  if (edge.hasClass("label")) {
    const label = edge.data("label");
    if (!premultiplier) {
      formula = label + "*" + node_label;
    } else {
      formula += " + " + label + "*" + node_label;
    }
  } else {
    if (!premultiplier) {
      formula = node_label;
    } else {
      formula += " + " + node_label;
    }
  }
  return formula;
}

export function createSyntax(run) {
  let cy = get(cyStore);
  let appSt = get(appState);
  let syntax = "";
  let R_script = "";
  if (!run) {
    R_script += "library(lavaan)" + "\n";
    if (appSt.dataAvail) {
      R_script += "data <- read.csv(" + appSt.loadedFileName + ")" + "\n";
    } else {
      R_script +=
        "#make sure your data is loaded into the 'data' variable" + "\n";
    }
  }

  // measurement model
  const latentNodes = cy.nodes(function (node) {
    return node.hasClass("latent-variable");
  });
  let shown = false;
  for (let i = 0; i < latentNodes.length; i++) {
    const latentNode = latentNodes[i];
    let nodeNames = "";
    const connectedEdges = latentNode.connectedEdges(function (edge) {
      return (
        edge.hasClass("directed") &&
        edge.source().id() == latentNode.id() &&
        edge.target().hasClass("observed-variable")
      );
    });
    if (connectedEdges.length > 0) {
      if (!shown) {
        syntax += "# measurement model" + "\n ";
        shown = true;
      }

      const sortedIndices = connectedEdges
        .map((edge, index) => ({
          index,
          x: edge.target().position().x,
        }))
        .sort((a, b) => a.x - b.x)
        .map((item) => item.index);

      for (let j = 0; j < connectedEdges.length; j++) {
        const node = connectedEdges[sortedIndices[j]].target();
        if (j > 0) {
          nodeNames += " + ";
        }

        nodeNames += addTerms(node, connectedEdges[sortedIndices[j]]);
      }
      syntax += latentNode.data("label") + " =~ " + nodeNames + "\n ";
    }
  }

  // regression
  let reg_edges = cy.edges(function (edge) {
    let res =
      edge.hasClass("directed") &&
      !edge.source().hasClass("constant") &&
      !(
        edge.source().hasClass("latent-variable") &&
        edge.target().hasClass("observed-variable")
      );
    return res;
  });
  let reg_nodes = [];
  for (let i = 0; i < reg_edges.length; i++) {
    if (!containsObject(reg_nodes, reg_edges[i].target())) {
      reg_nodes.push(reg_edges[i].target());
    }
  }

  if (reg_nodes.length > 0) {
    syntax += "\n" + "# regressions" + "\n";
    for (let i = 0; i < reg_nodes.length; i++) {
      const targetNode = reg_nodes[i];
      const connectedEdges = targetNode.connectedEdges(function (edge) {
        return (
          edge.hasClass("directed") && edge.target().id() == targetNode.id()
        );
      });
      if (connectedEdges.length > 0) {
        let nodeNames = "";
        for (var j = 0; j < connectedEdges.length; j++) {
          var node = connectedEdges[j].source();
          if (j > 0) {
            nodeNames += " + ";
          }
          nodeNames += addTerms(node, connectedEdges[j]);
        }
        syntax += targetNode.data("label") + " ~ " + nodeNames + "\n ";
      }
    }
  }

  // covariances
  let cov_edges = cy.edges(function (edge) {
    return (
      (edge.hasClass("undirected") || edge.hasClass("loop")) &&
      !edge.hasClass("fromLav")
    );
  });
  if (cov_edges.length > 0) {
    let nodeNames = "";
    syntax += "\n" + "# residual (co)variances" + "\n";
    for (let i = 0; i < cov_edges.length; i++) {
      let node1 = cov_edges[i].source().data("label");
      let node2 = cov_edges[i].target().data("label");
      syntax +=
        node1 + " ~~ " + addTerms(cov_edges[i].target(), cov_edges[i]) + "\n ";
    }
  }

  // mean structure
  const constant_nodes = cy.nodes(function (node) {
    return node.hasClass("constant");
  });
  for (let i = 0; i < constant_nodes.length; i++) {
    const c_node = constant_nodes[i];
    const connectedEdges = c_node.connectedEdges();
    if (connectedEdges.length > 0) {
      syntax += "# intercepts" + "\n ";
      for (var j = 0; j < connectedEdges.length; j++) {
        var node = connectedEdges[j].target();
        syntax +=
          node.data("label") +
          " ~ " +
          addTerms(undefined, connectedEdges[j]) +
          "\n";
      }
    }
  }
  syntax = "'\n" + syntax + "'" + "\n ";
  const lavOptions = produceLavaanOptions();

  R_script += "model <-" + syntax;
  R_script += "result <- lavaan(model, data, " + lavOptions;
  if (!run) {
    return R_script;
  } else {
    const for_R = {
      options: lavOptions,
      syntax: syntax,
      run: run,
    };
    return for_R;
  }
}

function produceLavaanOptions() {
  const modelOpt = get(modelOptions);
  const meanStruc = boolToString(modelOpt.meanStruc);
  const ovFree = boolToString(modelOpt.intOvFree);
  const lvFree = boolToString(modelOpt.intLvFree);
  return (
    "meanstructure = " +
    meanStruc +
    ", int.ov.free = " +
    ovFree +
    ", int.lv.free = " +
    lvFree +
    ", auto.fix.first = TRUE, auto.fix.single = TRUE, auto.var = TRUE, auto.cov.lv.x = TRUE, auto.efa = TRUE, auto.th = TRUE, auto.delta = TRUE, auto.cov.y = TRUE, fixed.x = FALSE)"
  );
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