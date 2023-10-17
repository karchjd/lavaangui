<script>
  import { onMount } from "svelte";
  import { updateVisibility, updateLabels, edgeItems } from "./viewModule";
  import { modelOptions } from "../stores";

  $: {
    updateVisibility($modelOptions, edgeItems);
  }
  let mounted = false;

  //to make sure the cy instance exists before first update
  onMount(() => {
    mounted = true;
  });

  $: {
    if (mounted) {
      updateLabels($modelOptions.view, $modelOptions.std);
    }
  }
</script>
