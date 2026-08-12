<script>
  import { appState, fitCache } from "../stores.js";
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
          nonce: Math.random(),
        });
      },
    });
  }

  function compareModels() {
    // @ts-expect-error
    Shiny.setInputValue("modelStore-compare", Math.random());
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
      disable: $appState.fitting || $fitCache.lastFitLavFit === null,
    },
    {
      name: "Compare",
      action: compareModels,
      disable: $appState.storedModelCount < 2,
    },
    {
      name: "Remove All Models",
      action: removeAllModels,
      disable: $appState.storedModelCount === 0,
    },
  ];
</script>

<DropdownLinks name="Compare Models" {menuItems} />
