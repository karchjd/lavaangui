<script>
import { appState } from "../stores";
  import { applyLinkedClass } from "./applyLinkedClass";

  function isShiny() {
    return typeof Shiny === "object" && Shiny !== null;
  }

  if (isShiny()) {
    //sent by server when data is loaded
    Shiny.addCustomMessageHandler("columnNames", function (columnNames) {
      applyLinkedClass(columnNames, true);
      $appState.dataAvail = true;
      $appState.columnNames = columnNames;
    });

    //sent by server when data is loaded
    Shiny.addCustomMessageHandler("fname", function (fname) {
      $appState.loadedFileName = fname;
    });
  }
</script>
