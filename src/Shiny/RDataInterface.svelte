<script>
  import { construct_svelte_component } from "svelte/internal";
  import { appState } from "../stores";
  import { applyLinkedClass } from "./applyLinkedClass";

  function isShiny() {
    return typeof Shiny === "object" && Shiny !== null;
  }

  if (isShiny()) {
    console.log("handlers added");
    Shiny.addCustomMessageHandler("columnNames", function (columnNames) {
      console.log("in handler");
      applyLinkedClass(columnNames, true);
      $appState.columnNames = columnNames;
      $appState.dataAvail = true;
    });

    Shiny.addCustomMessageHandler("fname", function (fname) {
      $appState.loadedFileName = fname;
    });
  }
</script>
