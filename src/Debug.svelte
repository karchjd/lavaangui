<script>
  import { cyStore, modelOptions } from "./stores.js";
  import { get } from "svelte/store";
  import { appState, dataInfo, fitCache } from "./stores.js";
  window.cy = get(cyStore);

  const unsubscribe = appState.subscribe((state) => {
    window.appState = state;
  });

  const unsubscribe1 = modelOptions.subscribe((state) => {
    window.modelOptions = state;
  });

  const unsubscribe2 = dataInfo.subscribe((state) => {
    window.dataInfo = state;
  });

  const unsubscribe3 = fitCache.subscribe((state) => {
    window.fitCache = state;
  });
</script>
