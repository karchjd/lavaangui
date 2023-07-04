<script>
  import Shiny from "shiny";
  import { cyStore, appState } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "../checkNodeLoop.js";
  import { applyLinkedClass } from "../RDataInterface.js";
  import JSZip from "jszip";
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  import GraphStyles from "../Graph/GraphStyles.js";

  let cy = get(cyStore);

  function newModel() {
    if (!$appState.modelEmpty) {
      bootbox.confirm(
        "Are you sure you want to create a new model? This will delete the current model.",
        function (result) {
          if (result) {
            cy.elements().remove();
          }
        }
      );
    }
  }

  function parseModel(content) {
    let json = JSON.parse(content);
    // Set loading mode, update diagram and perform checks
    $appState.loadingMode = true;
    cy.json(json);
    cy.style(GraphStyles);
    let nodes = cy.nodes();
    for (let i = 0; i < nodes.length; i++) {
      console.log(nodes[i].data("label"));
      checkNodeLoop(nodes[i].id());
    }
    if ($appState.columnNames != null) {
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
          if (confirm) {
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
  }

  function jsonModel() {
    //remove link with data set
    let cy_save = cy;
    cy_save.nodes().removeClass("linked");

    // Convert diagram data to JSON string
    const json = cy_save.json();
    const str = JSON.stringify(json);
    return str;
  }

  function downloadModel() {
    const str = jsonModel();
    // Create a new Blob object using the JSON string
    let blob = new Blob([str], { type: "application/json;charset=utf-8" });
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
    $appState.dataAvail = false;
    bootbox.alert("Data removed");
    cy_save.nodes().removeClass("linked");
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

  function nothing() {}
  let menuItems = [
    { name: "New Model", action: newModel, divider: false },
    { name: "Load Model", action: loadModel, divider: false },
    { name: "Load Data", action: loadData, divider: false },
    { name: "Load Model and Data", action: loadModelData, divider: true },
    { name: "Download Model", action: downloadModel, divider: false },
    {
      name: "Download Model and Data",
      action: downloadModelData,
      divider: true,
    },
    { name: "Remove Data", action: removeData, divider: false },
    { name: "Export Model to PNG", action: exportPNG, divider: false },
    { name: "Export Model to JPG", action: exportJPG, divider: false },
  ];
</script>

<DropdownLinks name={"File"} {menuItems} />
