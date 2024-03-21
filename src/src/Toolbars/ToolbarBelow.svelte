<script>
  import { onMount } from "svelte";
  import { appState, modelOptions, gridViewOptions } from "../stores";

  let selected;

  function changeMode(newMode) {
    selected = newMode;
    if (newMode !== "user model") {
      $gridViewOptions.showLav = true;
    } else {
      $gridViewOptions.showLav = false;
    }
    modelOptions.update((options) => {
      options.mode = newMode;
      return options;
    });
  }

  function showData() {
    window.$("#data-modal-2").modal();
  }

  function showResults() {
    window.$("#data-modal-extend-results").modal();
  }
  let ready = false;
  onMount(() => {
    ready = true;
  });

  $: if (ready) selected = $modelOptions.mode;
</script>

<div class="toolbox navbar-static-bottom">
  <button
    class="btn btn-lg {selected === 'data'
      ? 'btn-primary active'
      : 'btn-default'}"
    on:click={() => showData()}
  >
    Show Data
  </button>
  <div class="btn-group btn-toggle">
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
      disabled={!$appState.dataAvail}
    >
      Show Estimate
    </button>
  </div>
  <button
    class="btn btn-lg {selected === 'data'
      ? 'btn-primary active'
      : 'btn-default'}"
    on:click={() => showResults()}
  >
    More Results
  </button>
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
    margin-left: 20px;
    margin-right: 20px;
  }
</style>
