<script>
  import cytoscape from "cytoscape";
  import panzoom from "cytoscape-panzoom";
  import { cyStore } from "../stores";
  import { get } from "svelte/store";
  import { onMount } from "svelte";

  panzoom(cytoscape);
  let cy = get(cyStore);
  // the default values of each option are outlined below:
  var defaults = {
    zoomFactor: 0.05, // zoom factor per zoom tick
    zoomDelay: 45, // how many ms between zoom ticks
    minZoom: cy.minZoom(), // min zoom level
    maxZoom: cy.maxZoom(), // max zoom level
    fitPadding: 50, // padding when fitting
    panSpeed: 10, // how many ms in between pan ticks
    panDistance: 10, // max pan distance per tick
    panDragAreaSize: 75, // the length of the pan drag box in which the vector for panning is calculated (bigger = finer control of pan speed and direction)
    panMinPercentSpeed: 0.25, // the slowest speed we can pan by (as a percent of panSpeed)
    panInactiveArea: 8, // radius of inactive area in pan drag box
    panIndicatorMinOpacity: 0.5, // min opacity of pan indicator (the draggable nib); scales from this to 1.0
    zoomOnly: false, // a minimal version of the ui only with zooming (useful on systems with bad mousewheel resolution)
    fitSelector: undefined, // selector of elements to fit
    animateOnFit: function () {
      // whether to animate on fit
      return false;
    },
    fitAnimationDuration: 1000, // duration of animation on fit
  };

  // add the panzoom control
  onMount(() => {
    // Initialize the Cytoscape instance
    cy.panzoom(defaults);
    cy.on("zoom", function (event) {
      var newZoomLevel = cy.zoom();

      if (newZoomLevel < defaults.minZoom) {
        cy.zoom(defaults.minZoom);
      } else if (newZoomLevel > defaults.maxZoom) {
        cy.zoom(defaults.maxZoom);
      }
    });
  });
</script>
