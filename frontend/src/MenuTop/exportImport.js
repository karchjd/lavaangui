import { saveAs } from "file-saver";
import { cyStore, appState, modelOptions, fitCache, gridViewOptions } from "../stores";
import { get } from "svelte/store";
import { jsPDF } from "jspdf";
import { svg2pdf } from "svg2pdf.js";
import { applyLinkedClass } from "../Shiny/applyLinkedClass.js";
import {
    graphSettings,
    graphStyles,
    edgeBendingSettings,
} from "../Graph/cytoscape_settings.js";
import { resetCounters } from "../Graph/graphmanipulation.js";
import { checkNodeLoop } from "../Graph/checkNodeLoop.js";


export function exportPNG() {
    const cy = get(cyStore);

    startDownload(cy.png({ bg: "white" }), "png");
}

export function exportJPG() {
    const cy = get(cyStore);
    startDownload(cy.jpg(), "jpg");
}

export function getSVG() {
    const cy = get(cyStore);
    const svgContent = cy.svg({ scale: 1, full: true });
    return svgContent;
}

export function exportSVG() {
    const svgContent = getSVG();
    const blob = new Blob([svgContent], {
        type: "image/svg+xml;charset=utf-8",
    });
    startDownload(blob, "svg");
}


function mergeExistingProperties(target, source) {
    for (let key in source) {
        if (source.hasOwnProperty(key) && source[key] !== undefined) {
            target[key] = source[key];
        }
    }
}


function reset() {
    let cy = get(cyStore);
    cy.elements().remove();
    resetCounters();
    let appStateLocal = get(appState);
    let modelOptionsLocal = get(modelOptions);
    let fitCacheLocal = get(fitCache)

    appStateLocal.parsedModel = false;
    modelOptionsLocal.fix_first = true;
    modelOptionsLocal.mode = "user model";
    // @ts-ignore
    Shiny.setInputValue("show_help", Math.random());
    for (let key in fitCacheLocal) {
        fitCacheLocal[key] = null;
    }
}

export function parseModel(content) {
    reset();

    let combinedData = JSON.parse(content);
    let cy = get(cyStore);

    let gridViewOptionsLocal = get(gridViewOptions);
    let modelOptionsLocal = get(modelOptions);
    let appStateLocal = get(appState);
    let fitCacheLocal = get(fitCache)

    // for backwards compatibility, remove eventually
    let json;
    json = JSON.parse(combinedData.model);
    const modelOpt = JSON.parse(combinedData.modelOpt);
    const gridViewOpt = JSON.parse(combinedData.gridViewOpt);
    mergeExistingProperties(modelOptionsLocal, modelOpt);
    mergeExistingProperties(gridViewOptionsLocal, gridViewOpt);
    if (combinedData.fitCache != undefined) {
        const localCache = JSON.parse(combinedData.fitCache);
        fitCacheLocal = localCache;
    }

    // Set loading mode, update diagram and perform checks
    appStateLocal.loadingMode = true;
    cy.json({ elements: json });
    cy.style(graphStyles);
    cy.edgeEditing(edgeBendingSettings);
    cy.style().update();
    cy.minZoom(graphSettings.minZoom);
    cy.maxZoom(graphSettings.maxZoom);
    cy.autolock(graphSettings.autolock);
    cy.autoungrabify(graphSettings.autoungrabify);
    cy.nodeEditing({
        resizeToContentCueImage: "",
        undoable: true,
    });

    cy.nodes().forEach((node) => {
        console.log(node.data("width"));
        node.style({ width: node.data("width") });
        node.style({ height: node.data("height") });
    });

    if (appStateLocal.dataAvail) {
        applyLinkedClass(appStateLocal.columnNames);
    }

    if (modelOptionsLocal.mode !== "user model") {
        gridViewOpt.showLav = true;
    } else {
        gridViewOpt.showLav = false;
    }

    cy.nodes().forEach((node) => {
        checkNodeLoop(node.id());
    });
    appStateLocal.loadingMode = false;
}

export async function exportPDF(fname = "model.pdf") {
    const svgContent = getSVG();
    const parser = new DOMParser();
    const svgElement = parser.parseFromString(
        svgContent,
        "image/svg+xml",
    ).documentElement;
    svgElement.style.position = "absolute";
    svgElement.style.left = "-9999px"; // Move the SVG off-screen
    document.body.appendChild(svgElement); // Temporarily add the SVG to the document
    const rect = svgElement.getBoundingClientRect(); // Get the actual size
    document.body.removeChild(svgElement); // Remove the SVG from the document
    const width = rect.width;
    const height = rect.height;
    const pdf = new jsPDF({
        orientation: width > height ? "landscape" : "portrait",
        unit: "pt",
        format: [width, height],
    });
    await svg2pdf(svgElement, pdf, { width, height });
    // pdf.save(fname);
    return pdf.output()
}

function startDownload(object, fileEnding) {
    saveAs(object, "model." + fileEnding);
}