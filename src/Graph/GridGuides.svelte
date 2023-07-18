<script>
  import cytoscape from "cytoscape";
  import gridGuide from "cytoscape-grid-guide";
  import { cyStore } from "../stores.js";
  import { get } from "svelte/store";
  import { onMount } from "svelte";

  gridGuide(cytoscape); // register extension
  let cy = get(cyStore);

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
    guidelinesTolerance: 2, // Tolerance distance for rendered positions of nodes' interaction.
    guidelinesStyle: {
      // Set ctx properties of line. Properties are here:
      strokeStyle: "#8b7d6b", // color of geometric guidelines
      geometricGuidelineRange: 400, // range of geometric guidelines
      range: 400, // max range of distribution guidelines
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
    cy.gridGuide(options);
  });
</script>
