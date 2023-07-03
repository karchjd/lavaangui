<script>
  import { onMount, setContext } from "svelte";
  import cytoscape from "cytoscape";
  import GraphStyles from "./GraphStyles.js";
  import { writable } from "svelte/store";

  export let cy = writable(0);

  let refElement;

  onMount(() => {
    cy = cytoscape({
      container: refElement,
      style: GraphStyles,
    });
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
