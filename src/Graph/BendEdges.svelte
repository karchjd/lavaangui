<script>
    import cytoscape from 'cytoscape';
    import Konva from 'konva';
    import edgeEditing from 'cytoscape-edge-editing';
    edgeEditing(cytoscape, window.$, Konva);

    import { cyStore } from "../stores.js";
    import { get } from "svelte/store";
    import { onMount } from "svelte";
  
    let cy = get(cyStore);
  
    onMount(() => {
      // Initialize the Cytoscape instance
      cy.edgeEditing({
					undoable: false,
					bendRemovalSensitivity: 16,
					enableMultipleAnchorRemovalOption: true,
					initAnchorsAutomatically: true,
					useTrailingDividersAfterContextMenuOptions: false,
					enableCreateAnchorOnDrag: true
				});
    });
  </script>
  