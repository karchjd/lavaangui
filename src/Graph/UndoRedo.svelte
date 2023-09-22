<script>
  import undoRedo from "cytoscape-undo-redo";
  import { onMount } from "svelte";
  import cytoscape from "cytoscape";

  import { cyStore, ur } from "../stores.js";
  import { get } from "svelte/store";
  let cy = get(cyStore);
  onMount(() => {
    cytoscape.use(undoRedo);
    const options = { isDebug: true };
    let urLocal = cy.undoRedo(options);
    ur.set(urLocal);
    document.addEventListener("keydown", function (e) {
      if (e.ctrlKey && e.target.nodeName === "BODY")
        if (e.which === 90) $ur.undo();
        else if (e.which === 89) $ur.redo();
    });
  });
</script>
