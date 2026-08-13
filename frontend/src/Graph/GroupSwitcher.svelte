<script>
  import { appState, modelOptions } from "../stores.js";
  import { activateEstimateGroup } from "../Shiny/groupEstimates.js";

  function selectGroup(groupId) {
    $appState.activeGroup = groupId;
    activateEstimateGroup(groupId);
  }
</script>

{#if $modelOptions.mode === "estimate" && $appState.groupLabels.length > 1}
  <div class="group-switcher" data-testid="group-switcher" aria-label="Estimate group">
    <span class="group-title">
      {$modelOptions.groupVariable}:
    </span>
    <div class="btn-group btn-group-sm" role="group" aria-label="Groups">
      {#each $appState.groupLabels as group}
        <button
          type="button"
          class:active={$appState.activeGroup === group.id}
          class="btn btn-default"
          aria-pressed={$appState.activeGroup === group.id}
          on:click={() => selectGroup(group.id)}
        >
          {group.label}
        </button>
      {/each}
    </div>
  </div>
{/if}

<style>
  .group-switcher {
    z-index: 2;
    display: flex;
    flex: 0 0 auto;
    align-items: center;
    gap: 8px;
    min-height: 38px;
    padding: 5px 10px;
    border-bottom: 1px solid #d9e2ec;
    background: #f7faff;
  }

  .group-title {
    color: #23527c;
    font-weight: 600;
  }

  .btn-group {
    display: flex;
    flex-wrap: wrap;
  }
</style>
