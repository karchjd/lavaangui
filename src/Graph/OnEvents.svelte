<script>
  import { cyStore, appState } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "./checkNodeLoop.js";
  let cy = get(cyStore);

  cy.on("add", "node", function (event) {
    const node = event.target;
    if (node.hasClass("observed-variable")) {
      let columnNames = $appState.columnNames;
      if (columnNames && columnNames.includes(node.data("label"))) {
        node.addClass("linked");
        if ($appState.loadingMode) {
          bootbox.alert("Variable connected with data set");
        }
      }
    }
    if ($appState.modelEmpty && cy.nodes().length > 0) {
      $appState.modelEmpty = false;
    }
  });

  cy.on("remove", "node", function (event) {
    if (cy.nodes().length == 0) {
      $appState.modelEmpty = true;
    }
  });

  cy.on("add", "edge", function (event) {
    if (!$appState.loadingMode) {
      const edge = event.target;
      const sourceNodeId = edge.source().id();
      const targetNodeId = edge.target().id();
      edge.addClass("free");
      edge.addClass("nolabel");
      if (
        sourceNodeId !== targetNodeId &&
        isNode(sourceNodeId) &&
        isNode(targetNodeId)
      ) {
        checkNodeLoop(sourceNodeId);
        checkNodeLoop(targetNodeId);
        edge.addClass("directed");
      } else if (
        sourceNodeId === targetNodeId &&
        isNode(sourceNodeId) &&
        isNode(targetNodeId)
      ) {
        edge.addClass("loop");
      }
      //removers
      if (
        (edge.hasClass("undirected") || edge.hasClass("loop")) &&
        (edge.source().hasClass("constant") ||
          edge.target().hasClass("constant"))
      ) {
        cy.remove(edge);
      }

      if (edge.hasClass("directed") && edge.target().hasClass("constant")) {
        cy.remove(edge);
      }

      if (edge.hasClass("directed") && edge.source().hasClass("constant")) {
        const t_node = edge.target();
        const conConstant = t_node.connectedEdges((edge) =>
          edge.source().hasClass("constant")
        );
        if (conConstant.length > 1) {
          cy.remove(edge);
        }
      }

      if (edge.hasClass("directed") && edge.source().hasClass("constant")) {
        edge.data("isMean", "1");
      } else {
        edge.data("isMean", "0");
      }
    }
  });

  cy.on("position", "node", function (event) {
    const node = event.target;
    const connectedNodes = node.neighborhood().nodes();

    connectedNodes.forEach((connectedNode) => {
      const connectedNodeId = connectedNode.id();
      checkNodeLoop(connectedNodeId);
    });
  });

  function isNode(str) {
    // Regular expression pattern to match strings of form "node" followed by one or more digits
    const pattern = /^node\d+$/;
    return pattern.test(str);
  }
</script>
