<script>
  import { cyStore, appState, modelOptions, dataInfo } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "../Graph/checkNodeLoop.js";
  import { applyLinkedClass } from "../Shiny/applyLinkedClass.js";
  import JSZip from "jszip";
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  import { graphSettings, graphStyles } from "../Graph/cytoscape_settings.js";
  import { resetCounters } from "../Graph/graphmanipulation.js";

  function newModel() {
    if (!$appState.modelEmpty) {
      bootbox.confirm(
        "Are you sure you want to create a new model? This will delete the current model.",
        function (result) {
          if (result) {
            reset();
          }
        }
      );
    } else {
      reset();
    }
  }

  function reset() {
    let cy = get(cyStore);
    cy.elements().remove();
    resetCounters();
    document.getElementById("lavaan_syntax_R").innerText = "";
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
      mergeExistingProperties($modelOptions, modelOpt);
      console.log(modelOpt);
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
  }

  function uploadModel() {
    let input = window.$("<input>").attr({ type: "file", accept: ".json" });

    // Attach change event handler to the file input element
    input.on("change", function (e) {
      // Read the selected file
      let file = e.target.files[0];
      let reader = new FileReader();
      reader.readAsText(file, "UTF-8");

      // Handle file content after it's read
      reader.onload = function (readerEvent) {
        // Parse file content as JSON
        let content = readerEvent.target.result;
        parseModel(content);
      };
    });

    // Trigger the file input click action
    input.click();
  }

  function loadModel() {
    if (!$appState.modelEmpty) {
      bootbox.confirm(
        "Are you sure you want to load a model? This will delete the current model.",
        function (result) {
          if (result) {
            uploadModel();
          }
        }
      );
    } else {
      uploadModel();
    }
  }

  function loadData() {
    //  / Trigger the file input click action
    window.$("#fileInput").click();
  }

  function loadModelData() {
    if (!$appState.modelEmpty) {
      bootbox.confirm(
        "Are you sure you want to load a model? This will delete the current model.",
        function (result) {
          if (result) {
            uploadModelData();
          }
        }
      );
    } else {
      uploadModelData();
    }
  }

  function uploadModelData() {
    // Create file input element
    let input = window.$("<input>").attr({ type: "file", accept: ".zip" });

    // Attach change event handler to the file input element
    input.on("change", function (e) {
      // Read the selected file
      let file = e.target.files[0];
      let reader = new FileReader();
      reader.readAsArrayBuffer(file);

      // Handle file content after it's read
      reader.onload = function (readerEvent) {
        // Use JSZip to unzip the file content
        JSZip.loadAsync(readerEvent.target.result).then(function (zip) {
          // Apply loadModel to model.json file within the zip
          zip
            .file("model.json")
            .async("text")
            .then(function (content) {
              parseModel(content);
            });

          // Send data.csv file to the shiny server
          zip
            .file("data.csv")
            .async("base64")
            .then(function (content) {
              // Send the content of the file as a base64 string
              Shiny.setInputValue("fileInput", { content: content });
            });
        });
      };
    });
    input.click();
  }

  function jsonModel() {
    //remove link with data set
    const cy = get(cyStore);
    let cy_save = cy;
    cy_save.nodes().removeClass("linked");

    // Convert diagram data to JSON string
    const json = cy_save.json();
    const model = JSON.stringify(json);
    const modelOpt = JSON.stringify($modelOptions);
    const combinedData = JSON.stringify({ model, modelOpt });
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
    window.$("<a>").attr({ href: url, download: "diagram.json" })[0].click();
  }

  function downloadModelData() {
    const str = jsonModel();
    Shiny.setInputValue("model", str);
    Shiny.setInputValue("triggerDownload", Math.random());
  }

  function removeData() {
    const cy = get(cyStore);
    $appState.dataAvail = false;
    $appState.columnNames = null;
    $appState.loadFileName = null;
    $appState.ids = null;
    $dataInfo = null;
    cy.nodes().removeClass("linked");
  }

  function startDownload(object, fileEnding) {
    let a = document.createElement("a");
    a.href = object;
    a.download = "model." + fileEnding;
    a.click();
  }

  function exportPNG() {
    startDownload(cy.png(), "png");
  }

  function exportJPG() {
    startDownload(cy.jpg(), "jpg");
  }

  $: menuItems = [
    { name: "New Model", action: newModel },
    { name: "Load Model", action: loadModel },
    { name: "Load Data", action: loadData },
    { name: "Load Model and Data", action: loadModelData, divider: true },
    {
      name: "Download Model",
      action: downloadModel,
      disable: $appState.modelEmpty,
    },
    { name: "Remove Data", action: removeData, disable: !$appState.dataAvail },
    {
      name: "Download Model and Data",
      disable: $appState.modelEmpty || !$appState.dataAvail,
      action: downloadModelData,
      divider: true,
    },
    {
      name: "Export Model to PNG",
      disable: $appState.modelEmpty,
      action: exportPNG,
    },
    {
      name: "Export Model to JPG",
      disable: $appState.modelEmpty,
      action: exportJPG,
    },
  ];
</script>

<DropdownLinks name={"File"} {menuItems} />
