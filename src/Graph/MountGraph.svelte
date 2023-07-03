<script>
  import { onMount } from "svelte";
  import { cyStore } from "../stores.js";
  import { get } from "svelte/store";
  let cy = get(cyStore);

  let refElement;

  onMount(() => {
    // Initialize the Cytoscape instance
    cy.mount(refElement);
  });
</script>

<div class="graph" bind:this={refElement} />

<style>
  div {
    z-index: 1;
    width: 70%;
    height: 100%;
    padding: 0px;
    margin: 0px;
  }
</style>
