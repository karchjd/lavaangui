<script>
  export let full = true;
  import { cyStore, appState, dataInfo } from "../stores.js";
  import { get } from "svelte/store";
  import JSZip from "jszip";
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  import cytoscape from "cytoscape";
  import svg from "cytoscape-svg";
  // @ts-ignore
  import { saveAs } from "file-saver";
  import { jsPDF } from "jspdf";
  import { svg2pdf } from "svg2pdf.js";
  import { requestData, jsonModel, reset, parseModel } from "./IO.js";

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

  function startDownload(object, fileEnding) {
    saveAs(object, "model." + fileEnding);
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
  }

  document
    .getElementById("dataUpload-fileInput")
    .addEventListener("change", function () {
      if (this.files && this.files.length > 0) {
        window.$("#upload-modal").modal();
      }
    });

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

  function downloadModelData() {
    requestData("download");
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
      { name: "New Model", action: newModel, divider: true },
      { name: "Load Model", action: loadModel },
      { name: "Load Data", action: loadData },
      { name: "Load Model and Data", action: loadModelData, divider: true },
      {
        name: "Save Model",
        action: downloadModel,
        disable: $appState.modelEmpty,
      },
      {
        name: "Save Model and Data",
        disable: $appState.modelEmpty || !$appState.dataAvail,
        action: downloadModelData,
        divider: true,
      },
      {
        name: "Remove Data",
        action: removeData,
        disable: !$appState.dataAvail,
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
          ["Save Model", "Load Model"].includes(item.name) ||
          allMenuItems.indexOf(item) >= allMenuItems.length - 4,
      );
    }
  }
</script>

<DropdownLinks name={"File"} {menuItems} minimal={!full} />
