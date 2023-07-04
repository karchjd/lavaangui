<script>
  import { onMount } from "svelte";
  import { cyStore, ehStore } from "../stores.js";
  import { get } from "svelte/store";
  import { addNode } from "../graphmanipulation.js";
  import cytoscape from "cytoscape";
  import gridGuide from "cytoscape-grid-guide";
  gridGuide(cytoscape); // register extension

  let cy = get(cyStore);
  let eh = get(ehStore);
  let cyContainer;
  let m = { x: 0, y: 0 };

  var options = {
    // On/Off Modules
    /* From the following four snap options, at most one should be true at a given time */
    snapToGridOnRelease: false, // Snap to grid on release
    snapToGridDuringDrag: false, // Snap to grid during drag
    snapToAlignmentLocationOnRelease: false, // Snap to alignment location on release
    snapToAlignmentLocationDuringDrag: false, // Snap to alignment location during drag
    distributionGuidelines: true, // Distribution guidelines
    geometricGuideline: true, // Geometric guidelines
    initPosAlignment: false, // Guideline to initial mouse position
    centerToEdgeAlignment: false, // Center to edge alignment
    resize: false, // Adjust node sizes to cell sizes
    parentPadding: false, // Adjust parent sizes to cell sizes by padding
    drawGrid: false, // Draw grid background

    // Guidelines
    guidelinesStackOrder: 4, // z-index of guidelines
    guidelinesTolerance: 0.5, // Tolerance distance for rendered positions of nodes' interaction.
    guidelinesStyle: {
      // Set ctx properties of line. Properties are here:
      strokeStyle: "#8b7d6b", // color of geometric guidelines
      geometricGuidelineRange: 400, // range of geometric guidelines
      range: 100, // max range of distribution guidelines
      minDistRange: 10, // min range for distribution guidelines
      distGuidelineOffset: 10, // shift amount of distribution guidelines
      horizontalDistColor: "#ff0000", // color of horizontal distribution alignment
      verticalDistColor: "#00ff00", // color of vertical distribution alignment
      initPosAlignmentColor: "#0000ff", // color of alignment to initial mouse location
      lineDash: [0, 0], // line style of geometric guidelines
      horizontalDistLine: [0, 0], // line style of horizontal distribution guidelines
      verticalDistLine: [0, 0], // line style of vertical distribution guidelines
      initPosAlignmentLine: [0, 0], // line style of alignment to initial mouse position
    },

    // Parent Padding
    parentSpacing: -1, // -1 to set paddings of parents to gridSpacing
  };
  onMount(() => {
    // Initialize the Cytoscape instance
    cy.mount(cyContainer);
    cy.gridGuide(options);
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
      o;
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
