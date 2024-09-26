<script>
  import { appState } from "../stores";

  function serverAvail() {
    return typeof Shiny === "object" && Shiny !== null;
  }
  if (serverAvail()) {
    Shiny.addCustomMessageHandler("fullServer", function (fullServer) {
      $appState.full = fullServer.full;
      $appState.ready = true;
      $appState.server = true; //fullServer.server;
      console.log("fullServer", fullServer.server);
    });
  } else {
    $appState.full = true;
    $appState.ready = true;
  }
</script>
