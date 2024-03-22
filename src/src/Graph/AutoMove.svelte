<script>
    import cytoscape from "cytoscape";
    import automove from "cytoscape-automove";
    cytoscape.use(automove);
    import { onMount } from "svelte";
    import { cyStore } from "../stores.js";
    import { get } from "svelte/store";

    let cy = get(cyStore);

    onMount(() => {
        // Initialize the Cytoscape instance
        cy.automove({
            nodesMatching: ".automove-viewport",
            reposition: "viewport",
        });
    });
</script>
