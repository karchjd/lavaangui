<script>
  import { appState } from "../stores";
  // @ts-ignore
  Shiny.addCustomMessageHandler("fullServer", function (fullServer) {
    $appState.full = fullServer.full;
    $appState.ready = true;
    $appState.shinyapps = fullServer.shinyapps; //fullServer.server;
  });
</script>
