<script>
  import { appState } from "../stores.js";

  let title;
  $: switch ($appState.result) {
    case "none":
      title = "";
      break;
    case "estimates_sucess":
      title = "Model Fit";
      break;
    case "script":
      title = "Script";
      break;
    case "model":
      title = "Model";
      break;
  }
</script>

<div id="pre-container">
  {#if title !== ""}
    <h4>{title}</h4>
  {/if}

  <pre id="lavaan_syntax_R" class="shiny-html-output well" />
</div>

<style>
  #pre-container {
    width: 30%;
    min-width: 30%;
    background-color: lightgrey;
    height: 100%;
  }

  h4 {
    border-bottom: 1pt solid black;
  }
  pre {
    white-space: pre; /* Changed from pre-wrap to pre */
    width: 100%;
    min-width: 100%;
    text-align: left;
    background-color: lightgrey;
    max-height: 85.3vh;
    overflow-y: auto;
    overflow-x: auto; /* Added this line */
    padding: 0px;
    margin: 0px;
  }
</style>
