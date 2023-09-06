<script>
  import { cyStore } from "./stores.js";
  import { get } from "svelte/store";
  import { appState, dataInfo } from "./stores.js";
  window.cy = get(cyStore);

  const unsubscribe = appState.subscribe((state) => {
    window.appState = state;
    window.dataInfo = dataInfo;
  });

  const unsubscribe2 = dataInfo.subscribe((state) => {
    window.dataInfo = state;
  });
</script>
