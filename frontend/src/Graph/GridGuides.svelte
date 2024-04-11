<script>
  import { cyStore, gridViewOptions } from "../stores.js";
  import { get } from "svelte/store";
  import cytoscape from "cytoscape";
  import gridGuide from "cytoscape-grid-guide";
  import { onMount } from "svelte";
  let ready = false;

  gridGuide(cytoscape); // register extension
  let cy = get(cyStore);

  var options = {
    // On/Off Modules
    /* From the following four snap options, at most one should be true at a given time */
    snapToGridOnRelease: false, // Snap to grid on release
    drawGrid: false,
    snapToAlignmentLocationDuringDrag: false, // Snap to alignment location during drag
    distributionGuidelines: true, // Distribution guidelines
    geometricGuideline: true, // Geometric guidelines
    initPosAlignment: false, // Guideline to initial mouse position
    centerToEdgeAlignment: false, // Center to edge alignment
    resize: false, // Adjust node sizes to cell sizes
    parentPadding: false, // Adjust parent sizes to cell sizes by padding

    // Guidelines
    guidelinesStackOrder: 4, // z-index of guidelines
    guidelinesTolerance: 2, // Tolerance distance for rendered positions of nodes' interaction.
    guidelinesStyle: {
      // Set ctx properties of line. Properties are here:
      strokeStyle: "#8b7d6b", // color of geometric guidelines
      geometricGuidelineRange: 2000, // range of geometric guidelines
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
    cy.gridGuide(options);
    ready = true;
  });

  $: if (ready && $gridViewOptions.gridShow !== undefined) {
    let cy = get(cyStore);
    cy.gridGuide({ drawGrid: $gridViewOptions.gridShow });
  }

  $: if (ready && $gridViewOptions.gridSpace !== undefined) {
    let cy = get(cyStore);
    cy.gridGuide({ gridSpacing: $gridViewOptions.gridSpace });
  }

  $: if (ready && $gridViewOptions.gridWidth !== undefined) {
    let cy = get(cyStore);
    cy.gridGuide({ lineWidth: $gridViewOptions.gridWidth });
  }

  $: if (ready && $gridViewOptions.gridMovePan !== undefined) {
    let cy = get(cyStore);
    cy.gridGuide({ panGrid: $gridViewOptions.gridMovePan });
  }

  $: if (ready && $gridViewOptions.gridSnap !== undefined) {
    let cy = get(cyStore);
    cy.gridGuide({ snapToGridDuringDrag: $gridViewOptions.gridSnap });
  }

  $: if (ready && $gridViewOptions.gridAlign !== undefined) {
    let cy = get(cyStore);
    cy.gridGuide({
      snapToAlignmentLocationOnRelease: $gridViewOptions.gridAlign,
    });
  }

  $: if (ready && $gridViewOptions.gridResize !== undefined) {
    let cy = get(cyStore);
    cy.gridGuide({
      resize: $gridViewOptions.gridResize,
    });
  }
</script>
