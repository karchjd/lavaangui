<script>
  import { onMount } from "svelte";
  import { updateVisibility, updateLabels, edgeItems } from "./viewModule";
  import { gridViewOptions, modelOptions } from "../stores";

  let mounted = false;

  $: if (mounted) {
    updateVisibility(
      $gridViewOptions.showVar,
      $gridViewOptions.showLav,
      $gridViewOptions.showMean,
      edgeItems,
    );
  }

  $: if (mounted) {
    updateLabels(
      $gridViewOptions.view,
      $gridViewOptions.std,
      $gridViewOptions.number_digits,
    );
  }

  onMount(() => {
    mounted = true;
  });
</script>
