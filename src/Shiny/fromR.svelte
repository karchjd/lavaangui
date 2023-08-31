<script>
  import { appState } from "../stores";
  import { applyLinkedClass } from "./applyLinkedClass.js";
  import { get } from "svelte/store";
  import { cyStore } from "../stores";
  import { checkNodeLoop } from "../Graph/checkNodeLoop.js";
  import { addNode } from "../Graph/graphmanipulation.js";

  function serverAvail() {
    return typeof Shiny === "object" && Shiny !== null;
  }

  function getEdge(lhs, op, rhs) {
    let directed;
    let source;
    let target;

    if (op === "=~") {
      directed = "directed";
      source = lhs;
      target = rhs;
    } else if (op == "~1") {
      source = 1;
      target = lhs;
      directed = "directed";
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
    let cy = get(cyStore);
    const correct_edge = cy.edges(function (edge) {
      let res;
      // normal case, constant not involved
      if (goal_edge.source != 1) {
        res =
          edge.source().data("label") == goal_edge.source &&
          edge.target().data("label") == goal_edge.target;
        if (goal_edge.directed == "undirected") {
          res =
            res ||
            (edge.source().data("label") == goal_edge.target &&
              edge.target().data("label") == goal_edge.source);
        }
        // abnormal case, constant involved
      } else {
        res =
          edge.source().hasClass("constant") &&
          edge.target().data("label") == goal_edge.target;
      }
      return res;
    });
    return correct_edge;
  }

  function getConstNodePosition(cy) {
    let totalX = 0;
    let maxX = Number.NEGATIVE_INFINITY;
    let maxY = Number.NEGATIVE_INFINITY;
    let nodeCount = cy.nodes().length;

    cy.nodes().forEach((node) => {
      let position = node.position();

      // Accumulate x-values to calculate average later
      totalX += position.x;

      // Find maximum x-value
      if (position.x > maxX) {
        maxX = position.x;
      }

      // Find maximum y-value
      if (position.y > maxY) {
        maxY = position.y;
      }
    });

    let middleX = totalX / nodeCount;
    let newY = maxY + 100; // 50 units below the lowest node. Adjust as needed.

    return { x: middleX, y: newY };
  }

  function assert(condition, message) {
    if (!condition) {
      throw new Error(message || "Assertion failed");
    }
  }

  if (serverAvail()) {
    //sent by server when data is loaded
    Shiny.addCustomMessageHandler("columnNames", function (columnNames) {
      applyLinkedClass(columnNames, true);
      $appState.dataAvail = true;
      $appState.columnNames = columnNames;
    });

    //sent by server when data is loaded
    Shiny.addCustomMessageHandler("fname", function (fname) {
      $appState.loadedFileName = fname;
    });

    // parses model
    Shiny.addCustomMessageHandler("lav_model", function (lav_model) {
      cy = get(cyStore);
      let const_added = false;
      let added_const_id;
      for (let i = 0; i < lav_model.lhs.length; i++) {
        let existingEdge = findEdge(
          lav_model.lhs[i],
          lav_model.op[i],
          lav_model.rhs[i]
        );
        if (lav_model.user[i] == 1) {
          //If it is a user row make sure the path is in, otherwise throw an error
          assert(existingEdge.length == 1);
          //fix it if it is fixed
          if (lav_model.free[i] == 0 && !existingEdge.hasClass("fixed")) {
            existingEdge.addClass("fixed");
            existingEdge.removeClass("free");
            existingEdge.data("value", lav_model.ustart[i]);
            existingEdge.addClass("byLav");
          }
        } else {
          assert(existingEdge.length == 0);
          const desiredEdge = getEdge(
            lav_model.lhs[i],
            lav_model.op[i],
            lav_model.rhs[i]
          );
          let sourceId;
          if (desiredEdge.source !== 1) {
            sourceId = cy
              .nodes(function (node) {
                return node.data("label") == desiredEdge.source;
              })[0]
              .id();
          } else {
            //added edge is constant
            if (lav_model.free[i] == 0 && lav_model.ustart[i] == 0) {
              continue;
            }
            if (!const_added) {
              added_const_id = addNode("constant", getConstNodePosition(cy));
              const_added = true;
              const added_node = cy.nodes(function (node) {
                return node.id() == added_const_id;
              })[0];
              added_node.addClass("fromLav");
            }
            sourceId = added_const_id;
          }
          const targetId = cy
            .nodes(function (node) {
              return node.data("label") == desiredEdge.target;
            })[0]
            .id();

          const edge = cy.add({
            groups: "edges",
            data: {
              source: sourceId,
              target: targetId,
            },
            classes: desiredEdge.directed + " fromLav" + " nolabel",
          });
          if (lav_model.free[i] == 0) {
            edge.addClass("fixed");
            edge.data("value", lav_model.ustart[i]);
          } else {
            edge.addClass("free");
          }
          checkNodeLoop(sourceId);
          checkNodeLoop(targetId);
        }
      }
    });

    // save all results in data attributes of the correct edges
    Shiny.addCustomMessageHandler("lav_results", function (lav_result) {
      cy = get(cyStore);
      for (let i = 0; i < lav_result.lhs.length; i++) {
        let existingEdge = findEdge(
          lav_result.lhs[i],
          lav_result.op[i],
          lav_result.rhs[i]
        );
        console.log("in lav_results");
        if (existingEdge.length != 1) {
          debugger;
        }
        if (existingEdge.hasClass("free")) {
          console.log("in free");
          existingEdge.data("est", lav_result.est[i].toFixed(2));
          existingEdge.addClass("hasEst");
          existingEdge.data("p_value", lav_result.pvalue[i].toFixed(2));
          existingEdge.data("se", lav_result.se[i].toFixed(2));
          existingEdge.data("ciLow", lav_result["ci.lower"][i].toFixed(2));
          existingEdge.data("ciHigh", lav_result["ci.upper"][i].toFixed(2));
        }
      }
    });
  }

  // function importNode(type, label) {
  //   addNode(type, undefined, label);
  // }

  // function importEdge(edge_paras) {
  //   const targetID = cy
  //     .nodes(function (node) {
  //       return node.data("label") == edge_paras.target;
  //     })
  //     .data("id");
  //   const sourceID = cy
  //     .nodes(function (node) {
  //       return node.data("label") == edge_paras.source;
  //     })
  //     .data("id");
  //   const edge = cy.add({
  //     group: "edges",
  //     data: {
  //       id: "edge" + edgeIdCounter++,
  //       source: sourceID,
  //       target: targetID,
  //     },
  //   });
  //   edge.addClass(edge_paras.directed);
  // }

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
</script>
