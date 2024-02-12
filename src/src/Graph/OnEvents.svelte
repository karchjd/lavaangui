<script>
  import { cyStore, appState, setAlert, modelOptions } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "./checkNodeLoop.js";
  import { tolavaan } from "../Shiny/toR.js";
  let cy = get(cyStore);

  // Initialize a map to keep track of the classes for each element
  let classMap = new Map();

  // Function to update class map with the current classes of elements
  function updateClassMap(cy) {
    cy.elements().forEach((ele) => {
      classMap.set(ele.id(), ele.classes().join(" "));
    });
  }

  cy.on("add", "node", function (event) {
    $appState.loadingMode = true;
    const node = event.target;
    if (node.hasClass("observed-variable")) {
      let columnNames = $appState.columnNames;
      if (columnNames && columnNames.includes(node.data("label"))) {
        node.addClass("linked");
        setAlert("success", `Variable ${node.data("label")} linked to data`);
      }
    }
    $appState.loadingMode = false;
    tolavaan($modelOptions.mode);
    if ($appState.modelEmpty && cy.edges().length > 0) {
      $appState.modelEmpty = false;
    }
  });

  cy.on("remove", "edge, node", function (event) {
    if (cy.edges().not(".byLav").length == 0) {
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
