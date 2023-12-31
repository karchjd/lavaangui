<script>
  import { cyStore, appState, setAlert } from "../stores.js";
  import { get } from "svelte/store";
  let cy = get(cyStore);
  import cytoscape from "cytoscape";
  import contextMenus from "cytoscape-context-menus";
  import "cytoscape-context-menus/cytoscape-context-menus.css";
  import { onMount } from "svelte";
  import { addNode } from "./graphmanipulation.js";
  import { checkNodeLoop } from "./checkNodeLoop.js";

  // register extension
  cytoscape.use(contextMenus);

  function isValidName(str) {
    const rVarNameRegex = /^[a-zA-Z\._][a-zA-Z0-9\._]*(?<!\.)$/;
    return rVarNameRegex.test(str);
  }

  function validLabel(str) {
    if (str == "") {
      // @ts-expect-error
      bootbox.alert("Provide a label");
      return false;
    }

    if (!isValidName(str)) {
      // @ts-expect-error
      bootbox.alert("Provide a valid label");
      return false;
    }
    return true;
  }

  function validDegree(str) {
    if (str == "") {
      // @ts-expect-error
      bootbox.alert("Provide a degree");
      return false;
    }
    const deg = parseInt(str);
    if (deg < 0 || deg > 360) {
      // @ts-expect-error
      bootbox.alert("Provide a valid degree (0-360)");
      return false;
    }
    return true;
  }

  const menu = [
    {
      id: "add-observed",
      content: "Add Observed Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.position || event.cyPosition;
        addNode("observed-variable", position);
      },
      show: "full",
    },
    {
      id: "add-latent",
      content: "Add Latent Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.position || event.cyPosition;
        addNode("latent-variable", position);
      },
      show: "full",
    },
    {
      id: "add-constant",
      content: "Add Constant Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.position || event.cyPosition;
        addNode("constant", position);
      },
      show: "full",
    },

    //edge menus

    {
      id: "label-para",
      content: "Add/Change Label",
      selector: "edge.fromUser",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        // @ts-expect-error
        bootbox.prompt({
          title: "Enter a Label",
          callback: function (result) {
            if (!validLabel(result)) {
              return false;
            }

            if (result !== null) {
              edge.data("label", result);
              edge.addClass("label");
              edge.removeClass("nolabel");
              edge.removeClass("fromLav");
              edge.removeClass("byLav");
            }
          },
        });
      },
      show: "both",
      hasTrailingDivider: false,
    },
    {
      id: "label-remove",
      content: "Remove Label",
      selector: "edge.label",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeClass("label");
        edge.addClass("nolabel");
        edge.data("label", undefined);
      },
      show: "both",
      hasTrailingDivider: false,
    },

    {
      id: "remove-edge",
      content: "Delete edge",
      selector: "edge.fromUser",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.remove();
      },
      show: "full",
      hasTrailingDivider: true,
    },
    {
      id: "fix-para",
      content: "Fix Parameter",
      selector: "edge.free.fromUser, edge.forcefree.fromUser",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        // @ts-expect-error
        bootbox.prompt({
          title: "Enter a Value",
          inputType: "number",
          callback: function (value) {
            if (value == "") {
              // @ts-expect-error
              bootbox.alert("Provide a value");
              return false;
            }
            if (value !== null) {
              edge.data("value", value);
              edge.removeClass("free");
              edge.removeClass("forcefree");
              edge.removeClass("fromLav");
              edge.removeClass("byLav");
              edge.removeClass("hasEst");
              edge.addClass("fixed");
            }
          },
        });
      },
      show: "full",
      hasTrailingDivider: false,
    },
    {
      id: "free-para",
      content: "Free Parameter",
      selector: "edge.fixed.fromUser, edge.forcefree.fromUser",
      onClickFunction: function (event) {
        var edge = event.target || event.cyTarget;
        edge.removeClass("fixed");
        edge.removeClass("forcefree");
        edge.removeClass("fromLav");
        edge.removeClass("byLav");
        edge.addClass("free");
      },
      show: "full",
      hasTrailingDivider: false,
    },
    {
      id: "free-force-para",
      content: "Force Parameter Free",
      selector: "edge.free.fromUser, edge.fixed.fromUser",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeClass("free");
        edge.removeClass("fixed");
        edge.removeClass("fromLav");
        edge.removeClass("byLav");
        edge.addClass("forcefree");
      },
      show: "full",
      hasTrailingDivider: true,
    },

    {
      id: "revert-arrow",
      content: "Revert Direction",
      selector: 'edge[isMean="0"].directed.fromUser',
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        const sourceId = edge.source().id();
        const targetId = edge.target().id();
        edge.move({
          source: targetId,
          target: sourceId,
        });
      },
      show: "full",
      hasTrailingDivider: false,
    },
    {
      id: "set-undirected",
      content: "Set Undirected",
      selector: 'edge[isMean="0"].directed.fromUser',
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeClass("directed");
        edge.addClass("undirected");
      },
      show: "full",
      hasTrailingDivider: true,
    },

    {
      id: "set-arrow",
      content: "Set Directed",
      selector: "edge.undirected.fromUser",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeClass("undirected");
        edge.addClass("directed");
      },
      show: "full",
      hasTrailingDivider: true,
    },

    {
      id: "change-curve",
      content: "Change Curvature",
      selector: "edge.undirected",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        // @ts-expect-error
        bootbox.prompt({
          title:
            "Enter a New Value \n (Larger absolute values → more curvature. Switching the sign → reverts curvature)",
          inputType: "number",
          value: parseInt(edge.style().controlPointDistances),
          callback: function (value) {
            if (value == "") {
              // @ts-expect-error
              bootbox.alert("Provide a value");
              return false;
            }
            if (value !== null) {
              edge.style("controlPointDistances", value);
            }
          },
        });
      },
      show: "both",
      hasTrailingDivider: true,
    },
    {
      id: "free-orientation",
      content: "Free Loop Orientation",
      selector: "edge.loop.fixDeg",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeClass("fixDeg");
        checkNodeLoop(edge.source().id());
      },
      show: "both",
      hasTrailingDivider: false,
    },
    {
      id: "change-orientation",
      content: "Change/Fix Loop Orientation",
      selector: "edge.loop",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        // @ts-expect-error
        bootbox.prompt({
          title:
            "Enter a Degree from 0 to 360 (0 is top, 90 right, 180 bottom, and 270 left)",
          inputType: "number",
          value: parseInt(edge.style("loop-direction")),
          callback: function (value) {
            if (value == "") {
              // @ts-expect-error
              bootbox.alert("Provide a value");
              return false;
            }

            if (!validDegree) {
              return false;
            }
            if (value !== null) {
              edge.style("loop-direction", `${value}deg`);
              edge.addClass("fixDeg");
            }
          },
        });
      },
      show: "both",
      hasTrailingDivider: true,
    },
    {
      id: "change-fromUser",
      content: " Explicitly Include in Model",
      selector: "edge.fromLav",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeClass("fromLav");
        edge.addClass("fromUser");
      },
      show: "full",
      hasTrailingDivider: false,
    },

    //node menus
    {
      id: "rename-node",
      show: "full",
      content: "Rename Variable",
      selector: "node.latent-variable, node.observed-variable",
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        const columnNames = $appState.columnNames;

        let dropdownOptions;
        if ($appState.dataAvail) {
          // Prepare options for the dropdown
          dropdownOptions = columnNames
            .map((name) => `<option value="${name}">${name}</option>`)
            .join("");
        }

        const dropdownHTML =
          $appState.dataAvail && node.hasClass("observed-variable")
            ? `
      <label>Or Select From Variables in Your Data:</label>
      <select class="form-control" id="label-dropdown">
        <option value="">--Select--</option>
        ${dropdownOptions}
      </select>
    `
            : "";
        // @ts-expect-error
        bootbox.dialog({
          title: "Rename Variable",
          message: `
        <div>
          <label>Enter a label:</label>
          <input type="text" class="form-control" id="new-label">
          ${dropdownHTML}
        </div>
      `,
          buttons: {
            cancel: {
              label: "Cancel",
              className: "btn-default",
            },
            confirm: {
              label: "Rename",
              className: "btn-primary",
              callback: function () {
                const inputLabel = document.getElementById("new-label").value;
                const selectedLabel =
                  $appState.dataAvail && node.hasClass("observed-variable")
                    ? document.getElementById("label-dropdown").value
                    : "";

                const result = inputLabel || selectedLabel;

                if (!validLabel(result)) {
                  return false;
                }

                if (result) {
                  node.data("label", result);
                  if (columnNames && columnNames.includes(node.data("label"))) {
                    node.addClass("linked");
                    setAlert(
                      "success",
                      `Variable ${node.data("label")} linked to data`
                    );
                  } else if (node.hasClass("linked")) {
                    node.removeClass("linked");
                    setAlert("info", `Variable ${node.data("label")} unlinked`);
                  }
                }
              },
            },
          },
        });
      },
    },
    {
      id: "remove-node",
      content: "Delete Variable",
      selector: "node",
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        node.remove();
      },
      show: "full",
      hasTrailingDivider: true,
    },
    {
      id: "change-latent",
      content: "Change to Latent",
      selector: "node.observed-variable",
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        node.removeClass("observed-variable");
        node.addClass("latent-variable");
        node.removeClass("linked");
      },
      show: "full",
      hasTrailingDivider: false,
    },

    {
      id: "change-observed",
      show: "full",
      content: "Change to Observed",
      selector: "node.latent-variable",
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        node.removeClass("latent-variable");
        node.addClass("observed-variable");
        let columnNames = $appState.columnNames;
        if (columnNames && columnNames.includes(node.data("label"))) {
          node.addClass("linked");
          if (!$appState.loadingMode) {
            // @ts-expect-error
            bootbox.alert("Variable linked with data set");
          }
        }
      },
    },
  ];

  // const minimalMenu =
  //           {
  //             id: 'color',
  //             content: 'change color',
  //             tooltipText: 'change color',
  //             selector: 'node',
  //             hasTrailingDivider: true,
  //             submenu: [
  //               {
  //                 id: 'color-blue',
  //                 content: 'blue',
  //                 tooltipText: 'blue',
  //                 onClickFunction: function (event) {
  //                   let target = event.target || event.cyTarget;
  //                   target.style('background-color', 'blue');
  //                 },
  //                 submenu: [
  //                   {
  //                     id: 'color-light-blue',
  //                     content: 'light blue',
  //                     tooltipText: 'light blue',
  //                     onClickFunction: function (event) {
  //                       let target = event.target || event.cyTarget;
  //                       target.style('background-color', 'lightblue');
  //                     },
  //                   },
  //                   {
  //                     id: 'color-dark-blue',
  //                     content: 'dark blue',
  //                     tooltipText: 'dark blue',
  //                     onClickFunction: function (event) {
  //                       let target = event.target || event.cyTarget;
  //                       target.style('background-color', 'darkblue');
  //                     },
  //                   },
  //                 ],
  //               },
  //               {
  //                 id: 'color-green',
  //                 content: 'green',
  //                 tooltipText: 'green',
  //                 onClickFunction: function (event) {
  //                   let target = event.target || event.cyTarget;
  //                   target.style('background-color', 'green');
  //                 },
  //               },
  //               {
  //                 id: 'color-red',
  //                 content: 'red',
  //                 tooltipText: 'red',
  //                 onClickFunction: function (event) {
  //                   let target = event.target || event.cyTarget;
  //                   target.style('background-color', 'red');
  //                 },
  //               },
  //             ]
  //           },

  function selectMenu(menu, isFull) {
    const valueToMatch = isFull ? "full" : "minimal";
    return menu.filter(
      (obj) => obj.show === valueToMatch || obj.show === "both"
    );
  }

  const menuSel = selectMenu(menu, $appState.full);
  onMount(() => {
    console.log(menu);
    // Initialize the Cytoscape instance
    cy.contextMenus({ menuItems: menuSel });
  });
</script>
