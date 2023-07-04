<script>
  import { onMount } from "svelte";
  import { cyStore, ehStore } from "../stores.js";
  import { get } from "svelte/store";
  import { addNode } from "../graphmanipulation.js";

  let cy = get(cyStore);
  let eh = get(ehStore);
  let cyContainer;
  let m = { x: 0, y: 0 };

  onMount(() => {
    // Initialize the Cytoscape instance
    cy.mount(cyContainer);
  });

  function handleKeyDown(event) {
    if (event.key === "Meta" || event.key === "Control") {
      eh.enableDrawMode();
    }

    // Handle Backspace key
    if (event.key === "Backspace") {
      let selectedElements = cy.$(":selected");
      selectedElements.forEach(function (element) {
        if (element.isNode()) {
          element.remove();
        } else if (element.isEdge()) {
          element.remove();
        }
      });
    }

    // Handle 'l', 'o', 'c' keys
    if (["l", "o", "c"].includes(event.key.toLowerCase())) {
      let nodeType;
      switch (event.key.toLowerCase()) {
        case "l":
          nodeType = "latent-variable";
          break;
        case "o":
          nodeType = "observed-variable";
          break;
        case "c":
          nodeType = "constant";
          break;
      }
      addNode(cy, nodeType, { ...m }); // Use the last known mouse position within Cytoscape container.
    }
  }

  function makeNodesGrabbable() {
    cy.autoungrabify(false);
    cy.nodes().grabify();
  }

  function handleKeyUp() {
    if (event.key === "Meta" || event.key === "Control") {
      eh.disableDrawMode();
      makeNodesGrabbable();
    }
  }

  function handleMouseOver() {
    document.addEventListener("keydown", handleKeyDown);
    document.addEventListener("keyup", handleKeyUp);
  }

  function handleMouseOut() {
    document.removeEventListener("keydown", handleKeyDown, false);
    document.removeEventListener("keyup", handleKeyUp, false);
  }

  function handleMousemove(event) {
    m.x = event.offsetX;
    m.y = event.offsetY;
  }
</script>

<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<div
  id="cy"
  class="graph"
  bind:this={cyContainer}
  on:mouseover={handleMouseOver}
  on:mouseout={handleMouseOut}
  on:mousemove={handleMousemove}
/>

<style>
  div {
    z-index: 1;
    width: 70%;
    height: 100%;
    padding: 0px;
    margin: 0px;
  }
</style>
