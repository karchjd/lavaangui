import { writable } from "svelte/store";

export const cyStore = writable(0);
export const ehStore = writable(0);

export const modelOptions = writable({
  meanStruc: "default",
  intOvFree: true,
  intLvFree: false
});

function createCustomStore() {
  const { subscribe, update } = writable({
    columnNames: null,
    loadedFileName: null,
    loadingMode: false,
    runCounter: 0,
    modelEmpty: true,
    dataAvail: false,
    meanStruc: "default",
    intOvFree: true,
    intLvFree: false,
  });

  return {
    subscribe,
    set: (newState) =>
      update((state) => {
        // If dataAvail is being set to false, automatically nullify columnNames and loadedFileName
        if (newState.dataAvail === false) {
          return {
            ...state,
            ...newState,
            columnNames: null,
            loadedFileName: null,
          };
        }
        // If dataAvail is true, accept new values for columnNames and loadedFileName
        else if (newState.dataAvail) {
          return {
            ...state,
            ...newState,
          };
        }
        // If attempting to set columnNames or loadedFileName without dataAvail being true, warn and keep state
        else if ("columnNames" in newState || "loadedFileName" in newState) {
          console.warn(
            "You cannot set columnNames or loadedFileName unless dataAvail is true"
          );
          return state;
        }
        // For other changes, update state normally
        else {
          return {
            ...state,
            ...newState,
          };
        }
      }),
  };
}

export const appState = createCustomStore();
