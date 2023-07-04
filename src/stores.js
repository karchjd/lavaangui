import { writable } from 'svelte/store';
export const cyStore = writable(0);
export const ehStore = writable(0);
export const appState = writable({
    columnNames: null,
    loadedFileName: null,
    loadingMode: false,
    runCounter: 0,
    modelEmpty: true,
    dataAvail: false,
});