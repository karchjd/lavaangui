import { writable, derived } from "svelte/store";

export const cyStore = writable(0);
export const ehStore = writable(0);
export const ur = writable(0);

export let modelOptions = writable({
  meanStruc: "default",
  intOvFree: true,
  intLvFree: false,
  view: "est",
  estimator: "ML",
  se: "standard",
  missing: "listwise",
  n_boot: 1000,
  showLav: true,
  showVar: true,
  fix_first: true,
  fix_single: true,
  auto_var: true,
  auto_cov_lv_x: true,
  auto_cov_y: true,
  fixed_x: true,
  std: false,
});

export let fitCache = writable({
  lastFitModel: null,
  lastFitLavFit: null,
  lastFitData: null,
});

export let appState = writable({
  fitting: false,
  loadingMode: false,
  runCounter: 0,
  modelEmpty: true,
  dataAvail: false,
  columnNames: null,
  loadFileName: null,
  ids: null,
  result: "none",
  dragged: null,
  drawing: false,
  full: true,
  ready: false,
});

export let dataInfo = writable(0);

export const columnNamesSTore = derived(
  appState,
  ($appState) => $appState.columnNames
);

export const alertStore = writable({
  type: "info",
  message: "",
  key: 0, // this is used to force re-renders
});

// Update function
export function setAlert(type, message) {
  alertStore.update((currentAlert) => {
    return {
      type,
      message,
      key: currentAlert.key + 1,
    };
  });
}

setAlert("info", "Greetings");
