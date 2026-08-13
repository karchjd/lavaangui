<script>
  import GroupOrderLegend from "./GroupOrderLegend.svelte";

  export let location = "graph";
  export let compact = false;
</script>

<GroupOrderLegend {location} {compact} />
