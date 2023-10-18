<script>
  import { appState, dataInfo, setAlert, fitCache } from "../stores";
  import { applyLinkedClass } from "./applyLinkedClass.js";
  import { get } from "svelte/store";
  import { cyStore } from "../stores";
  import { checkNodeLoop } from "../Graph/checkNodeLoop.js";
  import { addNode } from "../Graph/graphmanipulation.js";
  import { applySemLayout } from "../MenuTop/semPlotLayouts.js";

  const number_digits = 2;

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
    let newY = maxY + 100;

    return { x: middleX, y: newY };
  }

  function assert(condition, message) {
    if (!condition) {
      throw new Error(message || "Assertion failed");
    }
  }

  function importNode(type, label) {
    addNode(type, undefined, label);
  }

  function getModelLav(lav_model, imported) {
    debugger;
    $appState.result = "model";
    cy = get(cyStore);
    if (!imported) {
      cy.edges().removeClass("validated");
    } else {
      const observed = lav_model.obs;
      for (let i = 0; i < observed.length; i++) {
        importNode("observed-variable", observed[i]);
      }

      const latent = lav_model.latent;
      for (let i = 0; i < latent.length; i++) {
        importNode("latent-variable", latent[i]);
      }
      lav_model = lav_model.parTable;
    }

    let const_added = false;
    let added_const_id;
    for (let i = 0; i < lav_model.lhs.length; i++) {
      // validate and remove existing edges
      let existingEdge = findEdge(
        lav_model.lhs[i],
        lav_model.op[i],
        lav_model.rhs[i]
      );
      if (!imported && lav_model.user[i] == 1) {
        //If it is a user row make sure the path is in, otherwise throw an error
        assert(existingEdge.length == 1);
        existingEdge.addClass("validated");
        //if it used to be fixed by lavaan unfix it first
        if (existingEdge.hasClass("byLav") && existingEdge.hasClass("fixed")) {
          existingEdge.removeClass("fixed");
          existingEdge.removeClass("byLav");
        }

        //fix it if lavaan fixed it
        if (lav_model.free[i] == 0 && !existingEdge.hasClass("fixed")) {
          existingEdge.addClass("fixed");
          existingEdge.removeClass("free");
          existingEdge.data("value", lav_model.ustart[i]);
          existingEdge.addClass("byLav");
        }
      } else {
        // add (missing) edges
        let edge;
        if (imported || existingEdge.length == 0) {
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

          edge = cy.add({
            groups: "edges",
            data: {
              source: sourceId,
              target: targetId,
            },
            classes: desiredEdge.directed + " fromLav" + " nolabel",
          });

          if (lav_model.user[i] == 1) {
            edge.addClass("fromUser");
            if (lav_model.free[i] == 0) {
              edge.addClass("byLav");
            }
          } else {
            edge.addClass("fromLav");
          }

          checkNodeLoop(sourceId);
          checkNodeLoop(targetId);
        } else if (!imported && existingEdge.length == 1) {
          edge = existingEdge;
        }
        if (lav_model.free[i] == 0) {
          if (lav_model.ustart[i] !== 0 && lav_model.exo[i] !== 1) {
            edge.addClass("fixed");
            edge.data("value", lav_model.ustart[i]);
          } else {
            edge.remove();
          }
        } else {
          edge.addClass("free");
        }
        if (!imported) {
          edge.addClass("validated");
        }
      }
    }
    if (!imported) {
      cy.edges().forEach((edge) => {
        if (!edge.hasClass("validated")) {
          edge.remove();
        }
      });
    } else {
      applySemLayout("tree", false);
    }
  }

  if (serverAvail()) {
    //sent by server when data is loaded
    Shiny.addCustomMessageHandler("dataInfo", function (data_info) {
      applyLinkedClass(data_info.columns, true);
      $appState.columnNames = [...data_info.columns];
      $appState.ids = [...data_info.columns];
      $appState.loadFileName = data_info.name;
      $appState.dataAvail = true;
      $dataInfo = data_info.summary;
    });

    Shiny.addCustomMessageHandler("lav_failed", function (failCode) {
      $appState.fitting = false;
      if (failCode == "stopped") {
        setAlert("danger", "Fitting stopped by user");
      }
    });

    Shiny.addCustomMessageHandler("fitting", function (dummy) {
      $appState.fitting = true;
    });

    Shiny.addCustomMessageHandler("usecache", function (dummy) {
      setAlert(
        "info",
        "Reusing cached results because model and data did not change since last fit"
      );
    });

    Shiny.addCustomMessageHandler("data_missing", function (dummy) {
      setAlert("danger", "Could not fit model because no data is available");
    });

    Shiny.addCustomMessageHandler("missing_vars", function (missingVars) {
      var missingVarsStr = [].concat(missingVars).join(", ");
      setAlert(
        "danger",
        "Could not fit model because " +
          missingVarsStr +
          " are observed variables in the model but not present in the data."
      );
    });

    // parse model
    Shiny.addCustomMessageHandler("lav_model", function (lav_model) {
      getModelLav(lav_model, false);
    });

    //import model
    Shiny.addCustomMessageHandler("imported_model", function (lav_model) {
      getModelLav(lav_model, true);
    });

    // save all results in data attributes of the correct edges
    Shiny.addCustomMessageHandler("lav_results", function (all_res) {
      const lav_result = all_res.normal;
      const std_result = all_res.std;
      $fitCache.lastFitLavFit = all_res.fitted_model;
      $fitCache.lastFitModel = all_res.model;
      $fitCache.lastFitData = all_res.data;
      cy = get(cyStore);
      for (let i = 0; i < lav_result.lhs.length; i++) {
        let existingEdge = findEdge(
          lav_result.lhs[i],
          lav_result.op[i],
          lav_result.rhs[i]
        );
        if (existingEdge.length != 1) {
          debugger;
        }
        if (existingEdge.hasClass("free")) {
          // Object to store all the estimates
          let allEstimates = {};

          // Populate the object with estimates from lav_result
          allEstimates.est = lav_result.est[i].toFixed(number_digits);
          allEstimates.p_value = lav_result.pvalue[i].toFixed(number_digits);
          allEstimates.se = lav_result.se[i].toFixed(number_digits);
          allEstimates.ciLow = lav_result["ci.lower"][i].toFixed(number_digits);
          allEstimates.ciHigh =
            lav_result["ci.upper"][i].toFixed(number_digits);

          // Populate the object with estimates from std_result
          allEstimates.est_std =
            std_result["est.std"][i].toFixed(number_digits);
          allEstimates.se_std = std_result.se[i].toFixed(number_digits);
          allEstimates.ciLow_std =
            std_result["ci.lower"][i].toFixed(number_digits);
          allEstimates.ciHigh_std =
            std_result["ci.upper"][i].toFixed(number_digits);

          // Store the consolidated estimates object in a single data attribute
          existingEdge.data("estimates", allEstimates);
          existingEdge.addClass("hasEst");
        }
      }
      $appState.fitting = false;
      $appState.result = "estimates_sucess";
      setAlert("success", "Succesfully fitted model");
    });
  }
</script>
