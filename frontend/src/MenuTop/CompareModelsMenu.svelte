<script>
  import { appState, cyStore } from "../stores.js";
  import { get } from "svelte/store";
  import DropdownLinks from "./helpers/DropdownLinks.svelte";

  function storeCurrentModel() {
    // @ts-expect-error
    bootbox.prompt({
      title: "Store current fitted model for comparison",
      value: `Model ${$appState.storedModelCount + 1}`,
      callback: function (result) {
        if (result === null) return;

        const name = result.trim();
        if (name === "") {
          // @ts-expect-error
          bootbox.alert("Provide a name for the model.");
          return false;
        }

        // @ts-expect-error
        Shiny.setInputValue("modelStore-storeCurrent", {
          name,
          diagram: get(cyStore).png({
            bg: "white",
            full: true,
            scale: 2,
          }),
          nonce: Math.random(),
        });
      },
    });
  }

  function compareModels() {
    // @ts-expect-error
    Shiny.setInputValue("modelStore-requestModels", Math.random());
  }

  function removeAllModels() {
    // @ts-expect-error
    bootbox.confirm(
      "Remove all models stored for comparison?",
      function (confirmed) {
        if (confirmed) {
          // @ts-expect-error
          Shiny.setInputValue("modelStore-removeAll", Math.random());
        }
      },
    );
  }

  $: menuItems = [
    {
      name: "Store Current Model",
      action: storeCurrentModel,
      disable: $appState.fitting || !$appState.currentFitAvailable,
      disabledReason: $appState.fitting
        ? "Wait until the current model has finished fitting."
        : "Fit the current model and data before storing it for comparison.",
    },
    {
      name: "Compare Stored Models",
      action: compareModels,
      disable: $appState.storedModelCount < 2,
      disabledReason: "Store at least two models before comparing them.",
    },
    {
      name: "Remove All Stored Models",
      action: removeAllModels,
      disable: $appState.storedModelCount === 0,
      disabledReason: "There are no stored models to remove.",
    },
  ];
</script>

<DropdownLinks name="Compare Models" {menuItems} />
