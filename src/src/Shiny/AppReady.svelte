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
    $appState.full = true;
    $appState.ready = true;
  }

  if (
    navigator.userAgent.indexOf("Safari") !== -1 &&
    navigator.userAgent.indexOf("Chrome") === -1
  ) {
    alert(
      "You are using Safari. This browser is not supported. Chrome or Firefox are recommended"
    );
  }
</script>
