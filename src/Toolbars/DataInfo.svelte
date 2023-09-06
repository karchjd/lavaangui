<script>
  import { appState } from "../stores";

  function showInfo() {
    window.$("#data-modal").modal();
  }

  window.$('[data-toggle="tooltip"]').tooltip();
</script>

<div id="data">
  {#if $appState.dataAvail}
    <a
      href={"#"}
      on:click={showInfo}
      data-toggle="tooltip"
      title="View Summary Statistics">{$appState.loadFileName} is loaded</a
    >
  {:else}
    <p>No Data loaded</p>
  {/if}
</div>

<style>
  #data {
    margin-left: 10px;
    margin-bottom: 0px;
    padding: 1px;
    background-color: white;
    border: solid 1px black;
    height: 20px;
  }
</style>
