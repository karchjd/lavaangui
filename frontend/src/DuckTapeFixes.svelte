<script>
  import { cyStore, appState } from "./stores.js";
  import { get } from "svelte/store";
  import { onMount } from "svelte";

  let cy = get(cyStore);

  setInterval(() => {
    if (!$appState.drawing && cy) {
      cy.autoungrabify(false);
      cy.nodes().grabify();
    }
  }, 1000); // every 1000 milliseconds or 1 second

  onMount(() => {
    // @ts-ignore
    Shiny.unbindAll();
    // @ts-ignore
    Shiny.bindAll();
  });
</script>
