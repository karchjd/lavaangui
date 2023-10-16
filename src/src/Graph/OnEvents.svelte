<script>
  import { cyStore, appState, setAlert } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "./checkNodeLoop.js";
  let cy = get(cyStore);

  cy.on("add", "node", function (event) {
    const node = event.target;
    if (node.hasClass("observed-variable")) {
      let columnNames = $appState.columnNames;
      if (columnNames && columnNames.includes(node.data("label"))) {
        node.addClass("linked");
        setAlert("success", `Variable ${node.data("label")} linked to data`);
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

  cy.on("position", "node", function (event) {
    const node = event.target;
    const connectedNodes = node.neighborhood().nodes();

    connectedNodes.forEach((connectedNode) => {
      const connectedNodeId = connectedNode.id();
      checkNodeLoop(connectedNodeId);
    });
  });
</script>
