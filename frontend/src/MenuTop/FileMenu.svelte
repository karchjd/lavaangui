<script>
  export let full = true;
  import {
    cyStore,
    appState,
    modelOptions,
    dataInfo,
    fitCache,
    gridViewOptions,
  } from "../stores.js";
  import { get } from "svelte/store";
  import { applyLinkedClass } from "../Shiny/applyLinkedClass.js";
  import JSZip from "jszip";
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  import { resetCounters } from "../Graph/graphmanipulation.js";
  import cytoscape from "cytoscape";
  import svg from "cytoscape-svg";
  // @ts-ignore
  import { saveAs } from "file-saver";
  import { checkNodeLoop } from "../Graph/checkNodeLoop.js";
  import { jsPDF } from "jspdf";
  import { svg2pdf } from "svg2pdf.js";
  import * as Constants from "../Graph/classNames.js";

  cytoscape.use(svg);

  function newModel() {
    if (!$appState.modelEmpty) {
      // @ts-expect-error
      bootbox.confirm(
        "Are you sure you want to create a new model? This will delete the current model.",
        function (result) {
          if (result) {
            reset();
          }
        },
      );
    } else {
      reset();
    }
  }

  function reset() {
    let cy = get(cyStore);
    cy.elements().remove();
    resetCounters();
    $appState.parsedModel = false;
    $modelOptions.fix_first = true;
    $modelOptions.mode = "user model";
    // @ts-expect-error
    Shiny.setInputValue("show_help", Math.random());
    for (let key in $fitCache) {
      $fitCache[key] = null;
    }
  }

  function mergeExistingProperties(target, source) {
    for (let key in source) {
      if (source.hasOwnProperty(key) && source[key] !== undefined) {
        target[key] = source[key];
      }
    }
  }

  function startDownload(object, fileEnding) {
    saveAs(object, "model." + fileEnding);
  }

  function parseModel(content) {
    reset();
    let combinedData = JSON.parse(content);
    let cy = get(cyStore);
    let json;
    json = JSON.parse(combinedData.model);
    const modelOpt = JSON.parse(combinedData.modelOpt);
    const gridViewOpt = JSON.parse(combinedData.gridViewOpt);
    mergeExistingProperties($modelOptions, modelOpt);
    mergeExistingProperties($gridViewOptions, gridViewOpt);
    if (combinedData.fitCache != undefined) {
      const localCache = JSON.parse(combinedData.fitCache);
      $fitCache = localCache;
    }

    // Set loading mode, update diagram and perform checks
    $appState.loadingMode = true;
    cy.json({ elements: json });

    cy.nodes().forEach((node) => {
      node.style({ width: node.data("width") });
      node.style({ height: node.data("height") });
    });

    if ($appState.dataAvail) {
      applyLinkedClass($appState.columnNames);
    }

    if ($modelOptions.mode !== "user model") {
      $gridViewOptions.showLav = true;
    } else {
      $gridViewOptions.showLav = false;
    }

    cy.nodes().forEach((node) => {
      checkNodeLoop(node.id());
    });
    $appState.loadingMode = false;
  }

  async function uploadModel() {
    // Create file input element
    const input = document.createElement("input");
    input.setAttribute("type", "file");
    input.setAttribute("accept", ".lvm");

    // Await file selection by user
    const file = await new Promise((resolve) => {
      // @ts-expect-error
      input.addEventListener("change", (e) => resolve(e.target.files[0]));
      input.click();
    });

    // Read the file as text
    const fileContent = await new Promise((resolve) => {
      const reader = new FileReader();
      reader.readAsText(file, "UTF-8");
      reader.onload = () => resolve(reader.result);
    });

    // Parse the file content as JSON and pass it to parseModel
    parseModel(fileContent);
  }

  function loadModel() {
    if (!$appState.modelEmpty) {
      // @ts-expect-error
      bootbox.confirm(
        "Are you sure you want to load a model? This will delete the current model.",
        function (result) {
          if (result) {
            uploadModel();
          }
        },
      );
    } else {
      uploadModel();
    }
  }

  function loadData() {
    //  / Trigger the file input click action
    document.getElementById("dataUpload-fileInput").click();
    window.$("#upload-modal").modal();
  }

  function loadModelData() {
    if (!$appState.modelEmpty) {
      // @ts-expect-error
      bootbox.confirm(
        "Are you sure you want to load model and data? This will delete the current model and data.",
        function (result) {
          if (result) {
            uploadModelData();
          }
        },
      );
    } else {
      uploadModelData();
    }
  }

  function uploadModelData() {
    // Create file input element
    const input = document.createElement("input");
    input.setAttribute("type", "file");
    input.setAttribute("accept", ".lvd");

    input.addEventListener("change", function (e) {
      // @ts-expect-error
      const file = e.target.files[0];

      const reader = new FileReader();
      reader.readAsArrayBuffer(file);

      reader.onload = function () {
        const arrayBuffer = reader.result;

        JSZip.loadAsync(arrayBuffer).then(function (zip) {
          zip
            .file("data.csv")
            .async("base64")
            .then(function (dataCsvContent) {
              // @ts-expect-error
              Shiny.setInputValue("dataUpload-fileInput", {
                content: dataCsvContent,
              });
              window.$("#upload-modal").modal();

              const checkDataAvailability = setInterval(() => {
                if ($appState.dataAvail) {
                  clearInterval(checkDataAvailability);

                  zip
                    .file("model.lvm")
                    .async("text")
                    .then(function (modelJsonContent) {
                      parseModel(modelJsonContent);
                    });
                }
              }, 100); // Check every 100 milliseconds
            });
        });
      };
    });

    input.click();
  }

  function jsonModel() {
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
    const modelOpt = JSON.stringify($modelOptions);
    const gridViewOpt = JSON.stringify($modelOptions);
    const fitCacheLocal = JSON.stringify($fitCache);
    const combinedData = JSON.stringify({
      model,
      modelOpt,
      gridViewOpt,
      fitCache: fitCacheLocal,
    });
    return combinedData;
  }

  function getDate() {
    const now = new Date();
    const formattedDate = `${now.getFullYear()}-${String(
      now.getMonth() + 1,
    ).padStart(2, "0")}-${String(now.getDate()).padStart(2, "0")}_${String(
      now.getHours(),
    ).padStart(2, "0")}-${String(now.getMinutes()).padStart(2, "0")}-${String(
      now.getSeconds(),
    ).padStart(2, "0")}`;
    return formattedDate;
  }

  function downloadModel() {
    const model = jsonModel();
    let blob = new Blob([model], {
      type: "application/json;charset=utf-8",
    });
    saveAs(blob, "model_" + getDate() + ".lvm");
  }

  async function downloadModelData() {
    // @ts-expect-error
    Shiny.setInputValue("down-requestData", Math.random());
  }

  // @ts-ignore
  Shiny.addCustomMessageHandler("dataForDownload", function (data) {
    (async () => {
      const model = jsonModel();
      const zip = new JSZip();
      zip.file("model.lvm", model);
      zip.file("data.csv", data);
      const content = await zip.generateAsync({ type: "blob" });
      const file = new File([content], "model_" + getDate() + ".lvd", {
        type: "application/zip",
      });
      saveAs(file);
    })();
  });

  function removeData() {
    const cy = get(cyStore);
    $appState.dataAvail = false;
    $appState.columnNames = null;
    $appState.loadedFileName = null;
    $appState.ids = null;
    $dataInfo = null;
    cy.nodes().unlink();
    // @ts-ignore
    Shiny.setInputValue("dataUpload-deleteData", Math.random());
  }

  function exportPNG() {
    const cy = get(cyStore);

    startDownload(cy.png({ bg: "white" }), "png");
  }

  function exportJPG() {
    const cy = get(cyStore);
    startDownload(cy.jpg(), "jpg");
  }

  function getSVG() {
    const cy = get(cyStore);
    const svgContent = cy.svg({ scale: 1, full: true });
    return svgContent;
  }

  function exportSVG() {
    const svgContent = getSVG();
    const blob = new Blob([svgContent], {
      type: "image/svg+xml;charset=utf-8",
    });
    startDownload(blob, "svg");
  }

  async function exportPDF() {
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
    pdf.save("model.pdf");
  }

  let menuItems;
  $: {
    let allMenuItems = [
      { name: "New Model", action: newModel },
      { name: "Load Model", action: loadModel },
      { name: "Load Data", action: loadData },
      { name: "Load Model and Data", action: loadModelData },
      {
        name: "Download Model",
        action: downloadModel,
        disable: $appState.modelEmpty,
      },
      {
        name: "Remove Data",
        action: removeData,
        disable: !$appState.dataAvail,
      },
      {
        name: "Download Model and Data",
        disable: $appState.modelEmpty || !$appState.dataAvail,
        action: downloadModelData,
        divider: true,
      },
      {
        name: "Export Diagram to PNG",
        disable: $appState.modelEmpty,
        action: exportPNG,
      },
      {
        name: "Export Diagram to JPG",
        disable: $appState.modelEmpty,
        action: exportJPG,
      },
      {
        name: "Export Diagram to SVG",
        disable: $appState.modelEmpty,
        action: exportSVG,
      },
      {
        name: "Export Diagram to PDF",
        disable: $appState.modelEmpty,
        action: exportPDF,
      },
    ];
    if (full) {
      menuItems = allMenuItems;
    } else {
      menuItems = allMenuItems.filter(
        (item) =>
          ["Download Model", "Load Model"].includes(item.name) ||
          allMenuItems.indexOf(item) >= allMenuItems.length - 4,
      );
    }
  }
</script>

<DropdownLinks name={"File"} {menuItems} minimal={!full} />
