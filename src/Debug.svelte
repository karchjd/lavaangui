<script>
  import { cyStore } from "./stores.js";
  import { get } from "svelte/store";
  window.cy = get(cyStore);
</script>
