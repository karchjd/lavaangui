<script>
  import Dropdown from "./helpers/Dropdown.svelte";
  import { appState, cyStore, modelOptions } from "../stores.js";
  import { get } from "svelte/store";
  import { GROUP_PARAMETERS_CLASS } from "../Graph/groupParameters.js";

  const name = "Multiple groups";

  function selectGroupingVariable(variable) {
    if ($modelOptions.groupVariable === variable) return;

    const cy = get(cyStore);
    if (cy) {
      cy.edges()
        .removeData("groupParameters")
        .removeClass(GROUP_PARAMETERS_CLASS);
    }
    $modelOptions.groupVariable = variable;
    $appState.groupLabels = [];
    $appState.activeGroup = null;
  }
</script>

<Dropdown {name}>
  {#if !$appState.dataAvail}
    <li class="disabled">
      <span class="menu-message">Load data to choose a grouping variable</span>
    </li>
  {:else}
    <li>
      <button
        type="button"
        class="menu-option"
        class:selected={$modelOptions.groupVariable === null}
        on:click={() => selectGroupingVariable(null)}
      >
        <span class="glyphicon glyphicon-ok check-mark" aria-hidden="true" />
        No grouping variable
      </button>
    </li>
    <li role="separator" class="divider" />
    <li class="dropdown-header">Grouping variable</li>
    {#each $appState.columnNames ?? [] as variable}
      <li>
        <button
          type="button"
          class="menu-option"
          class:selected={$modelOptions.groupVariable === variable}
          on:click={() => selectGroupingVariable(variable)}
        >
          <span class="glyphicon glyphicon-ok check-mark" aria-hidden="true" />
          {variable}
        </button>
      </li>
    {/each}
  {/if}
</Dropdown>

<style>
  .menu-message,
  .menu-option {
    display: block;
    width: 100%;
    padding: 3px 20px 3px 10px;
    clear: both;
    color: #333;
    font-weight: normal;
    line-height: 1.42857143;
    text-align: left;
    white-space: nowrap;
  }

  .menu-option {
    border: 0;
    background: transparent;
  }

  .menu-option:hover,
  .menu-option:focus {
    background-color: #f5f5f5;
    outline: none;
  }

  .check-mark {
    margin-right: 6px;
    visibility: hidden;
  }

  .selected .check-mark {
    visibility: visible;
  }
</style>
