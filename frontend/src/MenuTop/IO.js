import { get } from "svelte/store";
import { cyStore, modelOptions, fitCache, appState, gridViewOptions } from "../stores";
import * as Constants from "../Graph/classNames.js";
import { resetCounters } from "../Graph/graphmanipulation.js";
import { applyLinkedClass } from "../Shiny/applyLinkedClass.js";
import { checkNodeLoop } from "../Graph/checkNodeLoop.js";

export async function requestData(goal) {
    // @ts-expect-error
    Shiny.setInputValue("down-requestData", { goal: goal, random: Math.random() });
}

export function reset() {
    let cy = get(cyStore);
    cy.elements().remove();
    resetCounters();
    appState.update((state) => {
        state.parsedModel = false;
        return state;
    });
    modelOptions.update((state) => {
        state.fix_first = true;
        state.mode = "user model";
        return state;
    });
    // @ts-expect-error
    Shiny.setInputValue("show_help", Math.random());
    fitCache.update((cache) => {
        for (let key in cache) {
            cache[key] = null;
        }
        return cache;
    });
}

export function parseModel(content) {
    reset();
    let combinedData = JSON.parse(content);
    let cy = get(cyStore);
    let json;
    json = JSON.parse(combinedData.model);
    const modelOptData = JSON.parse(combinedData.modelOpt);
    const gridViewOptData = JSON.parse(combinedData.gridViewOpt);
    mergeExistingProperties(modelOptions, modelOptData);
    mergeExistingProperties(modelOptions, gridViewOptData);
    if (combinedData.fitCache !== undefined) {
        const localCache = JSON.parse(combinedData.fitCache);
        fitCache.set(localCache);  // Use the set method to update the store with the new value
    }

    // Set loading mode, update diagram and perform checks
    appState.update(state => {
        state.loadingMode = true;
        return state;
    });
    cy.json({ elements: json });

    cy.nodes().forEach((node) => {
        node.style({ width: node.data("width") });
        node.style({ height: node.data("height") });
    });

    if (get(appState).dataAvail) {
        applyLinkedClass(get(appState).columnNames);
    }

    if (get(modelOptions).mode !== "user model") {
        gridViewOptions.update(state => {
            state.showLav = true;
            return state;
        });
    } else {
        gridViewOptions.update(state => {
            state.showLav = false;
            return state;
        });
    }

    cy.nodes().forEach((node) => {
        checkNodeLoop(node.id());
    });
    appState.update(state => {
        state.loadingMode = false;
        return state;
    });
}

export function jsonModel() {
    const cy = get(cyStore);

    //save node size because edge editing extention does not do it
    cy.nodes().forEach((node) => {
        node.data("width", node.width());
        node.data("height", node.height());
    });
    let json = cy.json().elements;

    // Remove link with data set
    json.nodes.forEach((node) => {
        node.classes = node.classes
            .split(" ")
            .filter((c) => c !== Constants.LINKED)
            .join(" ");
    });

    const model = JSON.stringify(json);
    const modelOpt = JSON.stringify(get(modelOptions));
    const gridViewOpt = JSON.stringify(get(modelOptions));
    const fitCacheLocal = JSON.stringify(get(fitCache));
    const combinedData = JSON.stringify({
        model,
        modelOpt,
        gridViewOpt,
        fitCache: fitCacheLocal,
    });
    return combinedData;
}


function mergeExistingProperties(target, source) {
    target.update((state) => {
        for (let key in source) {
            if (source.hasOwnProperty(key) && source[key] !== undefined) {
                state[key] = source[key];
            }
        }
        return state;  // Return the updated state
    });
}