<script>
import { appState } from "../stores";
import { applyLinkedClass } from "./applyLinkedClass";
import {serverAvail} from "./RModelInterface.js"

  if (serverAvail()) {
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
