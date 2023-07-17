<script>
  import { cyStore } from "./stores.js";
  import { get } from "svelte/store";
  import { appState } from './stores.js';
  window.cy = get(cyStore);

  let columnNames = null;
  const unsubscribe = appState.subscribe((state) => {
      columnNames = state.columnNames;
      window.appState = state;
  });
</script>

