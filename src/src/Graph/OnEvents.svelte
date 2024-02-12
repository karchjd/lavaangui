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

  function sendtoR(ev) {
    tolavaan($modelOptions.mode);
    if (!$appState.loadingMode) {
      console.log("hey some event happened on cy: ", ev);
    }
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
    sendtoR(event);
    if ($appState.modelEmpty && cy.edges().length > 0) {
      $appState.modelEmpty = false;
    }
    updateClassMap(cy);
  });

  cy.on("remove", "edge, node", function (event) {
    if (cy.edges().length == 0) {
      $appState.modelEmpty = true;
    }
    sendtoR(event);
    if (cy.edges().length == 0) {
      $appState.modelEmpty = true;
    }
    updateClassMap(cy);
  });

  cy.on("position", "node", function (event) {
    const node = event.target;
    const connectedNodes = node.neighborhood().nodes();

    connectedNodes.forEach((connectedNode) => {
      const connectedNodeId = connectedNode.id();
      checkNodeLoop(connectedNodeId);
    });
  });

  cy.on("style", "node, edge", function (event) {
    const target = event.target; // This is the element (node or edge) that had a style change

    // Get the current and previous class list for the target element
    const currentClasses = target.classes().join(" ");
    const previousClasses = classMap.get(target.id());

    // Check if the classes have changed
    if (
      previousClasses !== undefined &&
      !(target.hasClass("byLav") || target.hasClass("fromLav")) &&
      currentClasses !== previousClasses
    ) {
      console.log(
        `Class change detected for ${target.id()}. Previous classes: ${previousClasses}, Current classes: ${currentClasses}`,
      );
      sendtoR(event);

      // Here you can react to the class change

      // Update the class map with the new class list for this element
      classMap.set(target.id(), currentClasses);
    }
  });

  // Listening for data changes on nodes and edges
  cy.on("data", "node, edge", function (event) {
    sendtoR(event);
  });
</script>
