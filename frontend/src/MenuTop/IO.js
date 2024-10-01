import { get } from "svelte/store";
import { cyStore, modelOptions, fitCache, appState, gridViewOptions } from "../stores";
import * as Constants from "../Graph/classNames.js";
import { resetCounters } from "../Graph/graphmanipulation.js";
import { applyLinkedClass } from "../Shiny/applyLinkedClass.js";
import { checkNodeLoop } from "../Graph/checkNodeLoop.js";
import { tolavaan } from "../Shiny/toR";

export async function requestData(goal) {
    // @ts-expect-error
    Shiny.setInputValue("down-requestData", { goal: goal, random: Math.random() });
}

let appStateLocal = get(appState);
let modelOptionsLocal = get(modelOptions);
let fitCacheLocal = get(fitCache);
let gridViewOptionsLocal = get(gridViewOptions);

export function reset() {
    let cy = get(cyStore);
    cy.elements().remove();
    resetCounters();
    appStateLocal.parsedModel = false;
    modelOptionsLocal.fix_first = true;
    modelOptionsLocal.mode = "user model";
    // @ts-expect-error
    Shiny.setInputValue("show_help", Math.random());
    for (let key in fitCacheLocal) {
        fitCacheLocal[key] = null;
    }
}

export function parseModel(content) {
    reset();
    let combinedData = JSON.parse(content);
    let cy = get(cyStore);
    let json;
    json = JSON.parse(combinedData.model);
    const modelOpt = JSON.parse(combinedData.modelOpt);
    const gridViewOpt = JSON.parse(combinedData.gridViewOpt);
    mergeExistingProperties(modelOptionsLocal, modelOpt);
    mergeExistingProperties(modelOptionsLocal, gridViewOpt);
    if (combinedData.fitCache != undefined) {
        const localCache = JSON.parse(combinedData.fitCache);
        fitCacheLocal = localCache;
    }

    // Set loading mode, update diagram and perform checks
    appStateLocal.loadingMode = true;
    cy.json({ elements: json });

    cy.nodes().forEach((node) => {
        node.style({ width: node.data("width") });
        node.style({ height: node.data("height") });
    });

    if (appStateLocal.dataAvail) {
        applyLinkedClass(appStateLocal.columnNames);
    }

    if (modelOptionsLocal.mode !== "user model") {
        gridViewOptionsLocal.showLav = true;
    } else {
        gridViewOptionsLocal.showLav = false;
    }

    cy.nodes().forEach((node) => {
        checkNodeLoop(node.id());
    });
    appStateLocal.loadingMode = false;
    tolavaan(modelOptionsLocal.mode);
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
    for (let key in source) {
        if (source.hasOwnProperty(key) && source[key] !== undefined) {
            target[key] = source[key];
        }
    }
}