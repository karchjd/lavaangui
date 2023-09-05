<script>
  import { appState, dataInfo } from "../stores";
  let state;
  let columns;
  let name;


  let unsubscribe = appState.subscribe((newState) => {
    state = newState;
  });

  let unsubscribe2 = dataInfo.subscribe((newState) => {
    if (state.dataAvail) {
      name = newState.name;
    }
  });

  function showInfo() {
    window.$("#data-modal").modal();
  }

  window.$('[data-toggle="tooltip"]').tooltip();   

</script>

<div id="data">
  {#if state.dataAvail}
    <a href={"#"} on:click={showInfo} data-toggle="tooltip" title="View Summary Statistics">{name} is loaded</a>
  {:else}
    <p>No Data loaded</p>
  {/if}
</div>
