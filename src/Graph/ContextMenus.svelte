<script>
  import { cyStore, appState, setAlert } from "../stores.js";
  import { get } from "svelte/store";
  let cy = get(cyStore);
  import cytoscape from "cytoscape";
  import contextMenus from "cytoscape-context-menus";
  import "cytoscape-context-menus/cytoscape-context-menus.css";
  import { onMount } from "svelte";
  import { addNode } from "./graphmanipulation.js";

  // register extension
  cytoscape.use(contextMenus);

  function isValidName(str) {
    // The regex breakdown:
    // ^: Asserts the start of a line.
    // [a-zA-Z]: Matches any single uppercase or lowercase letter.
    // [a-zA-Z0-9]*: Matches zero or more letters or digits.
    // $: Asserts the end of a line.
    const regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
    return regex.test(str);
  }

  function validLabel(str) {
    if (str == "") {
      bootbox.alert("Provide a label");
      return false;
    }

    if (!isValidName(str)) {
      bootbox.alert("Provide a valid label");
      return false;
    }
    return true;
  }
  let menu = [
    {
      id: "add-observed",
      content: "Add Observed Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.position || event.cyPosition;
        addNode("observed-variable", position);
      },
    },
    {
      id: "add-latent",
      content: "Add Latent Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.position || event.cyPosition;
        addNode("latent-variable", position);
      },
    },
    {
      id: "add-constant",
      content: "Add Constant Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.position || event.cyPosition;
        addNode("constant", position);
      },
    },

    //edge menus

    {
      id: "label-para",
      content: "Add/Change Label",
      selector: "edge.fromUser",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        bootbox.prompt({
          title: "Please enter a label",
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
      hasTrailingDivider: true,
    },
    {
      id: "fix-para",
      content: "Fix Parameter",
      selector: "edge.free.fromUser, edge.forcefree.fromUser",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        bootbox.prompt({
          title: "Please enter a value",
          inputType: "number",
          callback: function (value) {
            if (value == "") {
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
      hasTrailingDivider: true,
    },

    {
      id: "change-curve",
      content: "Change Curvature",
      selector: "edge.undirected",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        bootbox.prompt({
          title:
            "Please enter new value. Larger absolute values result in more curvature. Switching the sign reverts the curvature.",
          inputType: "number",
          value: parseInt(edge.style().controlPointDistances),
          callback: function (value) {
            if (value == "") {
              bootbox.alert("Provide a value");
              return false;
            }
            if (value !== null) {
              edge.style("controlPointDistances", value);
            }
          },
        });
      },
      hasTrailingDivider: false,
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
      hasTrailingDivider: false,
    },

    //node menus
    {
      id: "rename-node",
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

        const dropdownHTML = $appState.dataAvail
          ? `
      <label>Or select from existing labels:</label>
      <select class="form-control" id="label-dropdown">
        <option value="">--Select--</option>
        ${dropdownOptions}
      </select>
    `
          : "";

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
                const selectedLabel = $appState.dataAvail
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
                  } else {
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
      hasTrailingDivider: false,
    },

    {
      id: "change-observed",
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
            bootbox.alert("Variable linked with data set");
          }
        }
      },
    },
  ];
  onMount(() => {
    // Initialize the Cytoscape instance
    cy.contextMenus({ menuItems: menu });
  });
</script>
