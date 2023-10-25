<script>
  import { appState } from "../stores";

  window.$('[data-toggle="tooltip"]').tooltip();
</script>

<div id="data">
  {#if $appState.dataAvail}
    <span>{$appState.loadFileName} is loaded</span>
  {:else}
    <span data-testid="data-info">No Data loaded</span>
  {/if}
</div>

<style>
  span {
    margin-left: 10px;
    margin-bottom: 0px;
    padding: 1px;
    background-color: white;
    border: solid 1px black;
    height: 20px;
  }
</style>
