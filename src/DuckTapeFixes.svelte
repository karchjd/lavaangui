<script>
  import { cyStore } from "../stores.js";
  import { get } from "svelte/store";

  let cy = get(cyStore);

  setInterval(() => {
    if (cy) {
      cy.autoungrabify(false);
      cy.nodes().grabify();
    }
  }, 1000); // every 1000 milliseconds or 1 second
</script>
