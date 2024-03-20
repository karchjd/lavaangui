import { writable, derived } from "svelte/store";

export const cyStore = writable(null);
export const ehStore = writable(null);
export const ur = writable(null);

export let modelOptions = writable({
  meanStruc: "default",
  intOvFree: true,
  intLvFree: false,
  estimator: "ML",
  se: "default",
  missing: "listwise",
  n_boot: 1000,
  fix_first: true,
  fix_single: true,
  auto_var: true,
  auto_cov_lv_x: true,
  auto_cov_y: true,
  fixed_x: true,
  mode: "user model",
});

export let gridViewOptions = writable({
  gridShow: false,
  gridSpace: 26,
  gridColor: "#dedede",
  gridWidth: 1,
  gridMovePan: false,
  gridSnap: false,
  gridAlign: false,
  gridResize: false,
  showLav: true,
  showVar: true,
  std: false,
  view: "est",
  ci: .95,
  number_digits: 2
});

export let fitCache = writable({
  lastFitModel: null,
  lastFitLavFit: null,
  lastFitData: null,
});

export let appState = writable({
  fitting: false,
  loadingMode: false, // TODO: remove?
  runCounter: 0,
  modelEmpty: true,
  dataAvail: false,
  columnNames: null,
  loadedFileName: null,
  ids: null,
  dragged: null,
  draggedName: null,
  drawing: false,
  full: true,
  ready: false,
  parsedModel: false,
  meansModelled: null,
  buttonDown: false,
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
