<script>
    import cytoscape from "cytoscape";
    import Konva from "konva";
    import nodeEditing from "cytoscape-node-editing";
    // @ts-ignore
    nodeEditing(cytoscape, window.$, Konva);
    import { cyStore } from "../stores.js";
    import { get } from "svelte/store";
    import { onMount } from "svelte";
    let cy = get(cyStore);

    onMount(() => {
        // Initialize the Cytoscape instance
        cy.nodeEditing({
            resizeToContentCueImage: "",
            undoable: true,
        });
    });
</script>
