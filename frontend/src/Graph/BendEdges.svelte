<script>
  import cytoscape from "cytoscape";
  import Konva from "konva";
  import edgeEditing from "cytoscape-edge-editing";
  // @ts-ignore
  edgeEditing(cytoscape, window.$, Konva);

  import { cyStore } from "../stores.js";
  import { get } from "svelte/store";
  import { onMount } from "svelte";

  let cy = get(cyStore);

  onMount(() => {
    // Initialize the Cytoscape instance
    const bendName = "Bend";
    const kinkName = "Kink";
    cy.edgeEditing({
      undoable: true,
      bendRemovalSensitivity: 16,
      enableMultipleAnchorRemovalOption: true,
      initAnchorsAutomatically: false,
      useTrailingDividersAfterContextMenuOptions: false,
      enableCreateAnchorOnDrag: true,
      anchorShapeSizeFactor: 4,
      addBendMenuItemTitle: `Add ${kinkName} Point`,
      removeBendMenuItemTitle: `Remove ${kinkName} Point`,
      removeAllBendMenuItemTitle: `Remove All${kinkName} Points`,
      addControlMenuItemTitle: `Add ${bendName} Point`,
      removeControlMenuItemTitle: `Remove ${bendName} Point`,
      removeAllControlMenuItemTitle: `Remove All ${bendName} Points`,
      handleReconnectEdge: false,
    });

    cy.style().update();
  });
</script>
