<script>
  import { appState, modelOptions } from "../stores";
  import { tolavaan } from "../Shiny/toR";

  function changeMode(newMode) {
    modelOptions.update((options) => {
      options.mode = newMode;
      return options;
    });
  }
</script>

<div class="toolbox navbar-static-bottom">
  <div class="btn-group btn-toggle">
    <button
      class="btn btn-lg {$modelOptions.mode === 'user model'
        ? 'btn-primary active'
        : 'btn-default'}"
      on:click={() => changeMode("user model")}
    >
      Show User Model
    </button>

    <!-- Show Full Model Button -->
    <button
      class="btn btn-lg {$modelOptions.mode === 'full model'
        ? 'btn-primary active'
        : 'btn-default'}"
      on:click={() => changeMode("full model")}
    >
      Show Full Model
    </button>
    <button
      class="btn btn-lg {$modelOptions.mode === 'estimate'
        ? 'btn-primary active'
        : 'btn-default'}"
      on:click={() => changeMode("estimate")}
      disabled={$appState.modelEmpty || !$appState.dataAvail}
    >
      Show Estimates
    </button>
  </div>
</div>

<style>
  div {
    height: 65px;
    padding: 0px;
  }

  .btn-group {
    display: flex;
    align-items: center;
    justify-content: center;
  }
</style>
