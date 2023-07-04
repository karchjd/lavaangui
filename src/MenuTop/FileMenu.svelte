<script>
  import Shiny from "shiny";
  import { cyStore, appState } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "../checkNodeLoop.js";
  import { applyLinkedClass } from "../RDataInterface.js";

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
    cy.style(myStyle);
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

  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  function nothing() {}
  let menuItems = [
    { name: "New Model", action: newModel, divider: false },
    { name: "Load Model", action: loadModel, divider: false },
    { name: "Load Data", action: nothing, divider: false },
    { name: "Load Model and Data", action: nothing, divider: true },
    { name: "Download Model", action: nothing, divider: false },
    { name: "Download Model and Data", action: nothing, divider: true },
    { name: "Remove Data", action: nothing, divider: false },
    { name: "Export Model to PNG", action: nothing, divider: false },
    { name: "Load Data", action: nothing, divider: false },
  ];
</script>

<DropdownLinks name={"File"} {menuItems} />
