<script>
  import { cyStore, gridViewOptions, modelOptions } from "./stores.js";
  import { get } from "svelte/store";
  import { appState, dataInfo, fitCache, ur } from "./stores.js";
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

  const unsubscribe4 = gridViewOptions.subscribe((state) => {
    window.gridViewOptions = state;
  });

  const unsubscribe5 = ur.subscribe((state) => {
    window.ur = state;
  });
</script>
