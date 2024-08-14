<script>
  import { cyStore, appState, ur } from "./stores.js";
  import { get } from "svelte/store";
  import { onMount } from "svelte";

  let cy = get(cyStore);

  // fixes bug of cytoscape that makes things ungrabbable
  setInterval(() => {
    if ($appState.drawing == "none" && cy) {
      cy.autoungrabify(false);
      cy.nodes().grabify();
      $appState.undoEmpty = $ur.isUndoStackEmpty();
      $appState.redoEmpty = $ur.isRedoStackEmpty();
    }
  }, 1000); // every 1000 milliseconds or 1 second

  // prevents users from losing their work
  window.addEventListener("beforeunload", (event) => {
    // Cancel the event as stated by the standard.
    event.preventDefault();
    // Chrome requires returnValue to be set.
    event.returnValue = "";
  });

  onMount(() => {
    // @ts-ignore
    Shiny.unbindAll();
    // @ts-ignore
    Shiny.bindAll();
  });
</script>
