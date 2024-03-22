<script>
  import { cyStore, appState, setAlert, modelOptions } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "./checkNodeLoop.js";
  import { tolavaan } from "../Shiny/toR.js";
  let cy = get(cyStore);

  cy.on("add", "node", function (event) {
    // TODO: remove? $appState.loadingMode = true;
    const node = event.target;
    if (node.isObserved()) {
      let columnNames = $appState.columnNames;
      if (columnNames && columnNames.includes(node.getLabel())) {
        node.link();
        setAlert("success", `Variable ${node.getLabel()} linked to data`);
      }
    }
    if ($appState.modelEmpty && cy.edges().length > 0) {
      $appState.modelEmpty = false;
    }
  });

  cy.on("remove", "edge, node", function (event) {
    if (cy.getUserEdges().length == 0) {
      $appState.modelEmpty = true;
    }
    tolavaan($modelOptions.mode);
  });

  cy.on("position", "node", function (event) {
    const node = event.target;
    const connectedNodes = node.neighborhood().nodes();

    connectedNodes.forEach((connectedNode) => {
      const connectedNodeId = connectedNode.id();
      checkNodeLoop(connectedNodeId);
    });
  });
</script>
