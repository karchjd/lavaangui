<script>
  import { appState } from "../stores";

  function serverAvail() {
    return typeof Shiny === "object" && Shiny !== null;
  }
  if (serverAvail()) {
    Shiny.addCustomMessageHandler("full", function (full) {
      $appState.full = full;
      $appState.ready = true;
    });
  } else {
    $appState.full = false;
    $appState.ready = true;
  }
</script>
