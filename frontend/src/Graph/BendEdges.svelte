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
    cy.edgeEditing({
      undoable: true,
      bendRemovalSensitivity: 16,
      enableMultipleAnchorRemovalOption: true,
      initAnchorsAutomatically: false,
      useTrailingDividersAfterContextMenuOptions: false,
      enableCreateAnchorOnDrag: true,
    });

    cy.style().update();
  });
</script>
