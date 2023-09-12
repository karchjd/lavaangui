<script>
  import { appState } from "../stores";
  function abort() {
    Shiny.setInputValue("abort", true);
  }
</script>

{#if $appState.fitting}
  <div class="center-screen">
    <button class="btn btn-lg btn-warning">
      <span class="glyphicon glyphicon-refresh spinning" /> Fitting...
    </button>
  </div>
{/if}

<style>
  .glyphicon.spinning {
    animation: spin 1s infinite linear;
    -webkit-animation: spin2 1s infinite linear;
  }

  @keyframes spin {
    from {
      transform: scale(1) rotate(0deg);
    }
    to {
      transform: scale(1) rotate(360deg);
    }
  }

  @-webkit-keyframes spin2 {
    from {
      -webkit-transform: rotate(0deg);
    }
    to {
      -webkit-transform: rotate(360deg);
    }
  }

  /* Centering the content on the screen */
  .center-screen {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    flex-direction: column;
    position: fixed; /* fix the position of the spinner on the screen */
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(
      255,
      255,
      255,
      0.8
    ); /* optional: add a semi-transparent background to make the rest of the content less visible */
    z-index: 9999; /* make sure the spinner is above all other elements */
  }
</style>
