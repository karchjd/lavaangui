<script>
  import { appState, modelOptions } from "../stores";

  var selected = $modelOptions.mode;

  function changeMode(newMode) {
    selected = newMode;
    modelOptions.update((options) => {
      options.mode = newMode;
      return options;
    });
  }

  function showData() {
    window.$("#data-modal-2").modal();
  }
</script>

<div class="toolbox navbar-static-bottom">
  <div class="btn-group btn-toggle">
    <button
      class="btn btn-lg {selected === 'data'
        ? 'btn-primary active'
        : 'btn-default'}"
      on:click={() => showData()}
    >
      Show Data
    </button>
    <button
      class="btn btn-lg {selected === 'user model'
        ? 'btn-primary active'
        : 'btn-default'}"
      on:click={() => changeMode("user model")}
    >
      Show User Model
    </button>

    <!-- Show Full Model Button -->
    <button
      class="btn btn-lg {selected === 'full model'
        ? 'btn-primary active'
        : 'btn-default'}"
      on:click={() => changeMode("full model")}
    >
      Show Full Model
    </button>
    <button
      class="btn btn-lg {selected === 'estimate'
        ? 'btn-primary active'
        : 'btn-default'}"
      on:click={() => changeMode("estimate")}
      disabled={$appState.modelEmpty || !$appState.dataAvail}
    >
      Estimate
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
