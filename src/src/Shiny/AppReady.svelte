<script>
  import { appState } from "../stores";

  function serverAvail() {
    return typeof Shiny === "object" && Shiny !== null;
  }

  Shiny.addCustomMessageHandler("full", function (full) {
    $appState.full = full;
    $appState.ready = true;
  });
</script>
