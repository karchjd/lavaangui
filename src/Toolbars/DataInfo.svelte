<script>
  import { appState } from "../stores";
  let state;
  let name;

  let unsubscribe = appState.subscribe((newState) => {
    state = newState;
    name = newState.loadFileName;
  });

  function showInfo() {
    window.$("#data-modal").modal();
  }

  window.$('[data-toggle="tooltip"]').tooltip();
</script>

<div id="data">
  {#if state.dataAvail}
    <a
      href={"#"}
      on:click={showInfo}
      data-toggle="tooltip"
      title="View Summary Statistics">{name} is loaded</a
    >
  {:else}
    <p>No Data loaded</p>
  {/if}
</div>
