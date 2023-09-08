import { writable, derived } from "svelte/store";

export const cyStore = writable(0);
export const ehStore = writable(0);

export let modelOptions = writable({
  meanStruc: "default",
  intOvFree: true,
  intLvFree: false,
  view: "est",
  estimator: "ML",
  se: "standard",
  missing: "listwise",
  n_boot: 1000,
});

export let appState = writable({
  loadingMode: false,
  runCounter: 0,
  modelEmpty: true,
  dataAvail: false,
  columnNames: null,
  loadFileName: null,
  ids: null,
});

export let dataInfo = writable(0);

export const columnNamesSTore = derived(
  appState,
  ($appState) => $appState.columnNames
);
