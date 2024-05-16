<script>
  import { appState, setAlert, fitCache, modelOptions } from "../stores";
  import { applyLinkedClass } from "./applyLinkedClass.js";
  import { get } from "svelte/store";
  import { cyStore } from "../stores";
  import { checkNodeLoop } from "../Graph/checkNodeLoop.js";
  import { addNode } from "../Graph/graphmanipulation.js";
  import { tolavaan } from "./toR.js";
  import { applySemLayout } from "../MenuTop/semPlotLayouts.js";
  import {
    OBSERVED,
    LATENT,
    CONSTANT,
    DIRECTED,
    UNDIRECTED,
    LOOP,
  } from "../Graph/classNames.js";

  function serverAvail() {
    // @ts-expect-error
    return typeof Shiny === "object" && Shiny !== null;
  }

  function getEdge(lhs, op, rhs) {
    let directed;
    let source;
    let target;

    if (op === "=~") {
      directed = DIRECTED;
      source = lhs;
      target = rhs;
    } else if (op == "~1") {
      source = 1;
      target = lhs;
      directed = DIRECTED;
    } else {
      target = lhs;
      source = rhs;
      if (op === "~~") {
        if (lhs === rhs) {
          directed = LOOP;
        } else {
          directed = UNDIRECTED;
        }
      } else if (op === "~" || "<~") {
        directed = DIRECTED;
      }
    }
    return { directed: directed, source: source, target: target };
  }

  function findEdge(lhs, op, rhs, user) {
    let goal_edge = getEdge(lhs, op, rhs);
    goal_edge.user = user;
    let cy = get(cyStore);
    const correct_edge = cy.edges(function (edge) {
      let res;
      // normal case, constant not involved
      if (goal_edge.source != 1) {
        res =
          edge.source().getLabel() == goal_edge.source &&
          edge.target().getLabel() == goal_edge.target;
        if (goal_edge.directed == UNDIRECTED) {
          res =
            res ||
            (edge.source().getLabel() == goal_edge.target &&
              edge.target().getLabel() == goal_edge.source);
        }
        // abnormal case, constant involved
      } else {
        res =
          edge.source().isConstant() &&
          edge.target().getLabel() == goal_edge.target;
      }
      if (goal_edge.user != undefined) {
        if (goal_edge.user == 1) {
          res = res && edge.isUserAdded();
        } else if (goal_edge.user == 0) {
          res = res && edge.isLavaanAdded();
        } else {
          throw new Error("User was neither 0 nor 1");
        }
      }

      return res;
    });
    if (correct_edge.length > 1) {
      throw new Error("Multiple edges found");
    }
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

  function getModelLav(lav_model, imported) {
    $appState.meansModelled = false;
    $appState.loadingMode = true;

    let cy = get(cyStore);
    if (!imported) {
      cy.edges().invalidate();
    } else {
      const observed = Array.isArray(lav_model.obs)
        ? lav_model.obs
        : [lav_model.obs];

      function importNode(type, label, position) {
        addNode(type, position, false, label);
      }
      let position = { x: 200, y: 200 };
      for (let i = 0; i < observed.length; i++) {
        position.x = position.x + 50;
        importNode(OBSERVED, observed[i], position);
      }

      const latent = Array.isArray(lav_model.latent)
        ? lav_model.latent
        : [lav_model.latent];
      position = { x: 200, y: 100 };
      for (let i = 0; i < latent.length; i++) {
        position.x = position.x + 50;
        importNode(LATENT, latent[i]);
      }
      lav_model = lav_model.parTable;
    }

    const orderedVariables = new Set();
    for (let i = 0; i < lav_model.lhs.length; i++) {
      if (lav_model.op[i] === "|") {
        orderedVariables.add(lav_model.lhs[i]);
      }
    }

    let const_added = false;
    let added_const_id;
    for (let i = 0; i < lav_model.lhs.length; i++) {
      if (lav_model.op[i] == "~*~" || lav_model.op[i] == "|") {
        continue;
      }
      // validate and remove existing edges
      let existingEdge = findEdge(
        lav_model.lhs[i],
        lav_model.op[i],
        lav_model.rhs[i],
        lav_model.user[i],
      );
      if (!imported && lav_model.user[i] == 1) {
        //If it is a user row make sure the path is in, otherwise throw an error
        assert(existingEdge.length == 1);
        existingEdge.validate();
        //if it used to be fixed by lavaan unfix it first
        if (existingEdge.isModifiedLavaan() && existingEdge.isFixed()) {
          existingEdge.revertLavaanFix();
        }

        //fix it if lavaan fixed it
        if (lav_model.free[i] == 0 && !existingEdge.isFixed()) {
          existingEdge.fixPara(lav_model.ustart[i]).markModifiedLavaan();
        }
      } else {
        // add (missing) edges
        let edge;
        if (imported || existingEdge.length == 0) {
          const desiredEdge = getEdge(
            lav_model.lhs[i],
            lav_model.op[i],
            lav_model.rhs[i],
          );
          if (imported && $appState.full && lav_model.user[i] == 0) {
            continue;
          }
          let sourceId;
          if (desiredEdge.source !== 1) {
            sourceId = cy
              .nodes(function (node) {
                return node.getLabel() == desiredEdge.source;
              })[0]
              .id();
          } else {
            //added edge is constant
            $appState.meansModelled = true;
            if (lav_model.free[i] == 0 && lav_model.ustart[i] == 0) {
              continue;
            }
            if (!const_added) {
              added_const_id = addNode(
                CONSTANT,
                getConstNodePosition(cy),
                false,
              );
              const_added = true;
              const added_node = cy.nodes(function (node) {
                return node.id() == added_const_id;
              })[0];
              added_node.markAddedLavaan();
            }
            sourceId = added_const_id;
          }
          const targetId = cy
            .nodes(function (node) {
              return node.getLabel() == desiredEdge.target;
            })[0]
            .id();

          edge = cy.add({
            groups: "edges",
            data: {
              source: sourceId,
              target: targetId,
            },
            classes: desiredEdge.directed + " nolabel",
          });
          if (lav_model.label[i] != "") {
            edge.addLabelImport(lav_model.label[i]);
          }
          if (lav_model.user[i] == 1) {
            edge.markAddedUser();
          } else {
            edge.markAddedLavaan();
          }

          checkNodeLoop(sourceId);
          checkNodeLoop(targetId);
        } else if (!imported && existingEdge.length == 1) {
          edge = existingEdge;
        }
        if (lav_model.free[i] == 0) {
          if (lav_model.ustart[i] !== 0 && lav_model.exo[i] !== 1) {
            if (
              orderedVariables.has(edge.target().getLabel()) &&
              lav_model.op[i] == "~~"
            ) {
              edge.fixPara("Total Variance 1");
            } else {
              edge.fixPara(lav_model.ustart[i]);
            }
          } else {
            edge.remove();
          }
        } else {
          edge.setFree();
        }
        if (!imported) {
          edge.validate();
        }
      }
    }
    if (!imported) {
      cy.edges().forEach((edge) => {
        if (!edge.isValid()) {
          edge.remove();
        }
      });
      cy.getLavaanNodes().forEach((node) => {
        if (node.connectedEdges().length == 0) {
          node.remove();
          cy.nodes().forEach((node) => {
            checkNodeLoop(node.id());
          });
        }
      });
    } else {
      applySemLayout("tree", false);
      cy.fit();
    }

    if (!$appState.parsedModel) {
      $appState.parsedModel = true;
    }
    if (cy.getUserEdges().length > 0) {
      $appState.modelEmpty = false;
    }
    $appState.loadingMode = false;
  }

  function updateEstimates(lav_result, std_result) {
    let cy = get(cyStore);
    const ordered = lav_result.op.some((op) => op.includes("~~"));

    for (let i = 0; i < lav_result.lhs.length; i++) {
      if (lav_result.op[i] == "~*~" || lav_result.op[i] == "|") {
        continue;
      }
      let existingEdge = findEdge(
        lav_result.lhs[i],
        lav_result.op[i],
        lav_result.rhs[i],
      );
      if (existingEdge.length > 0) {
        let allEstimates = {};
        if (existingEdge.isFree()) {
          // Object to store all the estimates

          // Populate the object with estimates from lav_result
          allEstimates.est = lav_result.est[i];
          allEstimates.p_value = lav_result.pvalue[i];
          allEstimates.se = lav_result.se[i];
          allEstimates.ciLow = lav_result["ci.lower"][i];
          allEstimates.ciHigh = lav_result["ci.upper"][i];

          // Populate the object with estimates from std_result
          allEstimates.est_std = std_result["est.std"][i];
          allEstimates.se_std = std_result.se[i];
          allEstimates.ciLow_std = std_result["ci.lower"][i];
          allEstimates.ciHigh_std = std_result["ci.upper"][i];

          existingEdge.addClass("hasEst");
        } else if (ordered && lav_result.op[i] == "~~") {
          allEstimates.estFixed = lav_result.est[i];
          {
            allEstimates.estFixed_std = std_result["est.std"][i];
            existingEdge.addClass("hasEstFixed");
          }
        }
        existingEdge.data("estimates", allEstimates);
      }
    }
  }

  if (serverAvail()) {
    //sent by server when data is loaded
    // @ts-expect-error
    Shiny.addCustomMessageHandler("dataInfo", function (data_info) {
      applyLinkedClass(data_info.columns, true);
      $appState.columnNames = [...data_info.columns];
      $appState.ids = [...data_info.columns];
      $appState.loadedFileName = data_info.name;
      $appState.dataAvail = true;
      tolavaan($modelOptions.mode);
      if (data_info.showData) {
        window.$("#data-modal-2").modal();
      }
    });

    // @ts-expect-error
    Shiny.addCustomMessageHandler("lav_failed", function (failCode) {
      $appState.fitting = false;
      if (failCode == "stopped") {
        setAlert("danger", "Fitting stopped by user");
      } else {
        setAlert("danger", "Fitting failed");
      }
    });

    Shiny.addCustomMessageHandler("fitting", function (ignored) {
      $appState.fitting = true;
    });

    Shiny.addCustomMessageHandler("lav_warning_error", function (info) {
      const what = info.type == "warning" ? "warning" : "error";
      setAlert(
        info.type,
        `During ${info.origin} the following ${what} occurred: ${info.message}`,
      );
    });
    // @ts-expect-error
    Shiny.addCustomMessageHandler("lav_error_fitting", function (info) {
      $appState.fitting = false;
      setAlert(
        info.type,
        "During " +
          info.origin +
          " the following error occurred: " +
          info.message,
      );
    });

    // @ts-expect-error
    Shiny.addCustomMessageHandler("usecache", function (dummy) {
      setAlert(
        "info",
        "Reusing cached results because model and data did not change since last fit",
      );
    });
    // @ts-expect-error
    Shiny.addCustomMessageHandler("data_missing", function (dummy) {
      setAlert("danger", "Could not fit model because no data is available");
    });

    // @ts-expect-error
    Shiny.addCustomMessageHandler("columnames", function (cnames) {
      const cy = get(cyStore);
      const oldName = $appState.columnNames[cnames.index];
      $appState.columnNames[cnames.index] = cnames.newcolname;
      cy.getObservedNodes().forEach((node) => {
        if (node.getLabel() == oldName) {
          node.setLabel(cnames.newcolname);
          tolavaan($modelOptions.mode);
        }
      });
      applyLinkedClass($appState.columnNames, true);
    });

    // @ts-expect-error
    Shiny.addCustomMessageHandler("missing_vars", function (missingVars) {
      var missingVarsStr = [].concat(missingVars).join(", ");
      setAlert(
        "danger",
        "Could not fit model because " +
          missingVarsStr +
          " are observed variables in the model but not present in the data.",
      );
    });

    // parse model
    // @ts-expect-error
    Shiny.addCustomMessageHandler("lav_model", function (lav_model) {
      getModelLav(lav_model, false);
    });

    //import model
    // @ts-expect-error
    Shiny.addCustomMessageHandler("imported_model", function (lav_model) {
      getModelLav(lav_model, true);
      let cy = get(cyStore);
      if (!Array.isArray(lav_model.ordered)) {
        lav_model.ordered = [lav_model.ordered];
      }
      lav_model.ordered.forEach((label) => {
        cy.nodes(function (node) {
          return node.getLabel() == label;
        })[0].makeOrdered();
      });
      $modelOptions.fix_first = false;
      setAlert(
        "warning",
        "start_gui only imports user edges. Your full model is very likely different than what you fitted in lavaan because of different options used. To display the model, as you fitted it in lavaan, use plot_interactive",
      );
    });

    // save all results in data attributes of the correct edges
    // @ts-expect-error
    Shiny.addCustomMessageHandler("lav_results", function (all_res) {
      $appState.loadingMode = true;
      $fitCache.lastFitLavFit = all_res.fitted_model;
      $fitCache.lastFitModel = all_res.model;
      $fitCache.lastFitData = all_res.data;
      $appState.fitting = false;
      $appState.loadingMode = false;
    });

    // get new estimates
    // @ts-expect-error
    Shiny.addCustomMessageHandler("lav_estimates", function (all_res) {
      const lav_result = all_res.normal;
      const std_result = all_res.std;
      updateEstimates(lav_result, std_result);
    });

    //import model
    // @ts-expect-error
    Shiny.addCustomMessageHandler("setToEstimate", function (lav_model) {
      $modelOptions.mode = "estimate";
    });
  }
</script>
