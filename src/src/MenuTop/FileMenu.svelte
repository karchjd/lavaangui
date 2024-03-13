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
  import { graphSettings, graphStyles } from "../Graph/cytoscape_settings.js";
  import { resetCounters } from "../Graph/graphmanipulation.js";
  import cytoscape from "cytoscape";
  import svg from "cytoscape-svg";
  import { saveAs } from "file-saver";
  import { checkNodeLoop } from "../Graph/checkNodeLoop.js";

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

  function parseModel(content) {
    reset();

    let combinedData = JSON.parse(content);
    let cy = get(cyStore);
    // for backwards compatibility, remove eventually
    let json;
    if ("model" in combinedData && "modelOpt" in combinedData) {
      json = JSON.parse(combinedData.model);
      const modelOpt = JSON.parse(combinedData.modelOpt);
      const gridViewOpt = JSON.parse(combinedData.gridViewOpt);
      mergeExistingProperties($modelOptions, modelOpt);
      mergeExistingProperties($gridViewOptions, gridViewOpt);
      if (combinedData.fitCache != undefined) {
        const localCache = JSON.parse(combinedData.fitCache);
        $fitCache = localCache;
      }
    } else {
      json = combinedData;
    }
    // Set loading mode, update diagram and perform checks
    $appState.loadingMode = true;
    cy.json(json);
    cy.style(graphStyles);
    cy.minZoom(graphSettings.minZoom);
    cy.maxZoom(graphSettings.maxZoom);
    cy.autolock(graphSettings.autolock);
    cy.autoungrabify(graphSettings.autoungrabify);

    if ($appState.dataAvail) {
      applyLinkedClass($appState.columnNames, false);
    }

    debugger;
    cy.nodes().forEach((node) => {
      checkNodeLoop(node.id());
    });
  }

  async function uploadModel() {
    // Create file input element
    const input = document.createElement("input");
    input.setAttribute("type", "file");
    input.setAttribute("accept", ".json");

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
    document.getElementById("fileInput").click();
  }

  function loadModelData() {
    if (!$appState.modelEmpty) {
      // @ts-expect-error
      bootbox.confirm(
        "Are you sure you want to load a model? This will delete the current model.",
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
    input.setAttribute("accept", ".zip");

    input.addEventListener("change", function (e) {
      // @ts-expect-error
      const file = e.target.files[0];

      const reader = new FileReader();
      reader.readAsArrayBuffer(file);

      reader.onload = function () {
        const arrayBuffer = reader.result;

        JSZip.loadAsync(arrayBuffer).then(function (zip) {
          zip
            .file("model.json")
            .async("text")
            .then(function (modelJsonContent) {
              parseModel(modelJsonContent);

              zip
                .file("data.csv")
                .async("base64")
                .then(function (dataCsvContent) {
                  // @ts-expect-error
                  Shiny.setInputValue("fileInput", { content: dataCsvContent });
                });
            });
        });
      };
    });

    input.click();
  }

  function jsonModel() {
    //remove link with data set
    const cy = get(cyStore);
    // Deep clone cytoscape instance to cy_save
    const cy_save = cytoscape();
    cy_save.json(cy.json());

    // Remove link with data set
    cy_save.nodes().unlink();

    // Convert diagram data to JSON string
    const json = cy_save.json();
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

  function downloadModel() {
    const combinedData = jsonModel();

    // Create a new Blob object using the JSON string
    let blob = new Blob([combinedData], {
      type: "application/json;charset=utf-8",
    });
    let url = URL.createObjectURL(blob);

    // Create and trigger download link for the JSON data
    // @ts-expect-error
    window.$("<a>").attr({ href: url, download: "diagram.json" })[0].click();
  }

  function downloadModelData() {
    const str = jsonModel();
    // @ts-expect-error
    Shiny.setInputValue("model", str);
    // @ts-expect-error
    Shiny.setInputValue("triggerDownload", Math.random());
  }

  function removeData() {
    const cy = get(cyStore);
    $appState.dataAvail = false;
    $appState.columnNames = null;
    $appState.loadedFileName = null;
    $appState.ids = null;
    $dataInfo = null;
    cy.nodes().unlink();
  }

  function startDownload(object, fileEnding) {
    saveAs(object, "model." + fileEnding);
  }

  function exportPNG() {
    const cy = get(cyStore);

    startDownload(cy.png({ bg: "white" }), "png");
  }

  function exportJPG() {
    const cy = get(cyStore);
    startDownload(cy.jpg(), "jpg");
  }

  function exportSVG() {
    const cy = get(cyStore);
    const svgContent = cy.svg({ scale: 1, full: true });
    const blob = new Blob([svgContent], {
      type: "image/svg+xml;charset=utf-8",
    });
    startDownload(blob, "svg");
  }

  function exportPDF() {
    const cy = get(cyStore);
    const svgContent = cy.svg({ scale: 1, full: true });
    const blob = new Blob([svgContent], {
      type: "image/svg+xml;charset=utf-8",
    });
    const url = URL.createObjectURL(blob);

    const pdf = new jsPDF({
      orientation: "landscape",
      unit: "pt",
      format: [cy.width(), cy.height()],
    });

    pdf.addImage(url, "SVG", 0, 0, cy.width(), cy.height());
    pdf.save("network.pdf");

    URL.revokeObjectURL(url);
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
    ];
    menuItems = full ? allMenuItems : allMenuItems.slice(-2);
  }
</script>

<DropdownLinks name={"File"} {menuItems} minimal={!full} />
