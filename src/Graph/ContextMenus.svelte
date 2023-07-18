<script>
  import { cyStore, appState } from "../stores.js";
  import { get } from "svelte/store";
  let cy = get(cyStore);
  import cytoscape from "cytoscape";
  import contextMenus from "cytoscape-context-menus";
  import 'cytoscape-context-menus/cytoscape-context-menus.css';
  import { onMount } from "svelte";
  import { addNode } from "./graphmanipulation.js";

  // register extension
  cytoscape.use(contextMenus);

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
      content: "Give Label",
      selector: "edge",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        bootbox.prompt({
          title: "Please enter a label",
          callback: function (result) {
            if (result !== null) {
              edge.data("label", result);
              edge.addClass("label");
              edge.removeClass("nolabel");
              edge.removeClass("fromLav");
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
      selector: "edge",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.remove();
      },
      hasTrailingDivider: true,
    },
    {
      id: "fix-para",
      content: "Fix Parameter",
      selector: "edge.free, edge.forcefree",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        bootbox.prompt({
          title: "Please enter a value",
          inputType: "number",
          callback: function (value) {
            if (value !== null) {
              edge.data("value", value);
              edge.removeClass("free");
              edge.removeClass("forcefree");
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
      selector: "edge.fixed, edge.forcefree",
      onClickFunction: function (event) {
        var edge = event.target || event.cyTarget;
        edge.removeClass("fixed");
        edge.removeClass("forcefree");
        edge.addClass("free");
      },
      hasTrailingDivider: false,
    },
    {
      id: "free-force-para",
      content: "Force Parameter Free",
      selector: "edge.free, edge.fixed",
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeClass("free");
        edge.removeClass("fixed");
        edge.addClass("forcefree");
      },
      hasTrailingDivider: true,
    },

    {
      id: "revert-arrow",
      content: "Revert Direction",
      selector: 'edge[isMean="0"].directed',
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
      selector: 'edge[isMean="0"].directed',
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
      selector: "edge.undirected",
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
            "Please enter new value. Larger absolute values result in more curvature. Positive values revert the curvature.",
          inputType: "number",
          value: parseInt(edge.style().controlPointDistances),
          callback: function (value) {
            if (value !== null) {
              edge.style("controlPointDistances", value);
            }
          },
        });
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
        bootbox.prompt({
          title: "Please enter a label",
          callback: function (result) {
            if (result !== null) {
              node.data("label", result);
            }
          },
        })
      }
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
      },
    },
  ];
  onMount(() => {
    // Initialize the Cytoscape instance
    cy.contextMenus({ menuItems: menu });
  });
</script>