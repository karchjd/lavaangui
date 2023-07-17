import { get } from "svelte/store";
import { appState, cyStore } from "../stores";
import { checkNodeLoop } from "../Graph/checkNodeLoop.js";

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
  if (edge.hasClass("fixed")) {
    formula = edge.data("value") + "*" + node_label;
    premultiplier = true;
  } else if (edge.hasClass("forcefree")) {
    formula = "NA*" + node_label;
    premultiplier = true;
  }

  if (edge.hasClass("label")) {
    label = edge.data("label");
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
  let syntax = "";
  let R_script = "";
  let loadedFileName;
  if (!run) {
    if (get(appState).loadedFileName == null) {
      loadedFileName = "YOUR_DATA.csv";
    } else {
      loadedFileName = get(appState).loadedFileName;
    }
    R_script += "library(lavaan)" + "\n";
    R_script += "data <- read.csv(" + get(appState).loadedFileName + ")" + "\n";
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
    c_node = constant_nodes[i];
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
  R_script += "model = '\n" + syntax + "'" + "\n ";
  R_script += "result <- sem(model, data)";
  return R_script;
}

function getEdge(lhs, op, rhs) {
  let directed;
  let source;
  let target;

  if (op === "=~") {
    directed = "directed";
    source = lhs;
    target = rhs;
  } else {
    target = lhs;
    source = rhs;
    if (op === "~~") {
      if (lhs === rhs) {
        directed = "loop";
      } else {
        directed = "undirected";
      }
    } else if (op === "~") {
      directed = "directed";
    }
  }
  return { directed: directed, source: source, target: target };
}

function findEdge(lhs, op, rhs) {
  const goal_edge = getEdge(lhs, op, rhs);
  cy = get(cyStore);
  const correct_edge = cy.edges(function (edge) {
    let res =
      edge.source().data("label") == goal_edge.source &&
      edge.target().data("label") == goal_edge.target;
    if (goal_edge.directed == "undirected") {
      res =
        res ||
        (edge.source().data("label") == goal_edge.target &&
          edge.target().data("label") == goal_edge.source);
    }
    return res;
  });
  return correct_edge;
}

function isShiny() {
  return typeof Shiny === "object" && Shiny !== null;
}

if (isShiny()) {
  // save all results in data attributes of the correct edges
  Shiny.addCustomMessageHandler("lav_results", function (lav_result) {
    cy = get(cyStore);
    for (let i = 0; i < lav_result.lhs.length; i++) {
      let existingEdge = findEdge(
        lav_result.lhs[i],
        lav_result.op[i],
        lav_result.rhs[i]
      );
      //TODO assert edge lenght not bigger 1
      //edge not, needs to be addedfound
      if (existingEdge.length == 0) {
        const desiredEdge = getEdge(
          lav_result.lhs[i],
          lav_result.op[i],
          lav_result.rhs[i]
        );
        const sourceId = cy
          .nodes(function (node) {
            return node.data("label") == desiredEdge.source;
          })[0]
          .id();
        const targetId = cy
          .nodes(function (node) {
            return node.data("label") == desiredEdge.target;
          })[0]
          .id();
        cy.add({
          groups: "edges",
          data: {
            source: sourceId,
            target: targetId,
            est: lav_result.est[i].toFixed(2),
            p_value: lav_result.pvalue[i].toFixed(2),
            se: lav_result.se[i].toFixed(2),
          },
          classes: desiredEdge.directed + " fromLav" + " hasEst",
        });
        checkNodeLoop(sourceId);
        checkNodeLoop(targetId);
      } else if (lav_result.se[i] !== 0) {
        existingEdge.data("est", lav_result.est[i].toFixed(2));
        existingEdge.addClass("hasEst");
        existingEdge.data("p_value", lav_result.pvalue[i].toFixed(2));
        existingEdge.data("se", lav_result.se[i].toFixed(2));
        //lavaan did fix the edge
      } else if (Math.abs(lav_result.est[i] - 1) < 1e-9) {
        existingEdge.addClass("fixed");
        existingEdge.removeClass("free");
        existingEdge.data("value", 1);
        existingEdge.addClass("fromLav");
      }
    }
  });
}

function importNode(type, label) {
  addNode(type, undefined, label);
}

function importEdge(edge_paras) {
  const targetID = cy
    .nodes(function (node) {
      return node.data("label") == edge_paras.target;
    })
    .data("id");
  const sourceID = cy
    .nodes(function (node) {
      return node.data("label") == edge_paras.source;
    })
    .data("id");
  const edge = cy.add({
    group: "edges",
    data: {
      id: "edge" + edgeIdCounter++,
      source: sourceID,
      target: targetID,
    },
  });
  edge.addClass(edge_paras.directed);
}

//import model
// Shiny.addCustomMessageHandler("model", function (model) {
//   const observed = model.obs;
//   for (let i = 0; i < observed.length; i++) {
//     importNode("observed-variable", observed[i]);
//   }

//   const latent = model.latent;
//   for (let i = 0; i < latent.length; i++) {
//     importNode("latent-variable", latent[i]);
//   }

//   const edges = model.pars;
//   for (let i = 0; i < edges.lhs.length; i++) {
//     const edge_paras = getEdge(edges.lhs[i], edges.op[i], edges.rhs[i]);
//     importEdge(edge_paras);
//   }
//   const layout = {
//     name: "breadthfirst",
//     spacingFactor: "0.6",
//     fit: false,
//   };
//   cy.layout(layout).run();
// });
