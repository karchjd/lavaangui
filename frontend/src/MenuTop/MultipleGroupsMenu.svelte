<script>
  import Dropdown from "./helpers/Dropdown.svelte";
  import {
    appState,
    cyStore,
    groupPartialDialog,
    modelOptions,
  } from "../stores.js";
  import { get } from "svelte/store";
  import { onMount } from "svelte";
  import { GROUP_PARAMETERS_CLASS } from "../Graph/groupParameters.js";
  import {
    GROUP_EQUAL_OPTIONS,
    getGroupPartialOptions,
    normalizeGroupEqual,
    normalizeGroupPartial,
    pruneGroupPartial,
  } from "../Graph/groupConstraints.js";

  const name = "Multiple groups";

  $: selectedGroupEqual = normalizeGroupEqual($modelOptions.groupEqual);
  $: groupPartial = normalizeGroupPartial($modelOptions.groupPartial);
  $: constraintsEnabled = Boolean($modelOptions.groupVariable);
  $: partialEnabled = constraintsEnabled && selectedGroupEqual.length > 0;

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
    $appState.graphGroupView = "all";
  }

  function toggleGroupEqual(value) {
    const selected = new Set(selectedGroupEqual);
    if (selected.has(value)) {
      selected.delete(value);
    } else {
      selected.add(value);
    }
    const nextGroupEqual = normalizeGroupEqual([...selected]);
    $modelOptions.groupEqual = nextGroupEqual;
    pruneExceptions(nextGroupEqual);
  }

  function sameValues(left, right) {
    return left.length === right.length &&
      left.every((value, index) => value === right[index]);
  }

  function pruneExceptions(groupEqual = selectedGroupEqual) {
    if (get(appState).loadingMode) return;
    const options = getGroupPartialOptions(get(cyStore), groupEqual);
    const pruned = pruneGroupPartial(
      get(modelOptions).groupPartial,
      options,
    );
    if (!sameValues(pruned, normalizeGroupPartial(get(modelOptions).groupPartial))) {
      $modelOptions.groupPartial = pruned;
    }
  }

  function editGroupPartial() {
    if (!partialEnabled) return;

    const options = getGroupPartialOptions(get(cyStore), selectedGroupEqual);
    const selected = pruneGroupPartial(groupPartial, options);
    if (!sameValues(selected, groupPartial)) {
      $modelOptions.groupPartial = selected;
    }
    if (options.length === 0) {
      // @ts-expect-error
      bootbox.alert(
        "No parameters in the current model match the selected equality constraints.",
      );
      return;
    }

    $groupPartialDialog = {
      open: true,
      options,
      selected,
    };
  }

  onMount(() => {
    let cy = null;
    const handleModelChange = () => pruneExceptions();
    const unsubscribe = cyStore.subscribe((nextCy) => {
      if (cy) cy.off("add remove data", "node, edge", handleModelChange);
      cy = nextCy;
      if (cy) cy.on("add remove data", "node, edge", handleModelChange);
    });
    return () => {
      unsubscribe();
      if (cy) cy.off("add remove data", "node, edge", handleModelChange);
    };
  });
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
    <li role="separator" class="divider" />
    <li
      class="dropdown-submenu"
      class:disabled={!constraintsEnabled}
    >
      <a
        tabindex={constraintsEnabled ? 0 : -1}
        href={"#"}
        aria-disabled={!constraintsEnabled}
        on:click|preventDefault
      >
        Equality constraints{selectedGroupEqual.length > 0
          ? ` (${selectedGroupEqual.length})`
          : ""}
      </a>
      {#if constraintsEnabled}
        <ul class="dropdown-menu equality-menu">
          <li class="dropdown-header">Constrain equal across groups</li>
          {#each GROUP_EQUAL_OPTIONS as option}
            <li>
              <button
                type="button"
                class="menu-option"
                class:selected={selectedGroupEqual.includes(option.value)}
                aria-pressed={selectedGroupEqual.includes(option.value)}
                on:click|stopPropagation={() => toggleGroupEqual(option.value)}
              >
                <span
                  class="glyphicon glyphicon-ok check-mark"
                  aria-hidden="true"
                />
                {option.label}
              </button>
            </li>
          {/each}
          <li role="separator" class="divider" />
          <li>
            <button
              type="button"
              class="menu-option"
              class:disabled-option={!partialEnabled}
              disabled={!partialEnabled}
              on:click|stopPropagation={editGroupPartial}
            >
              <span class="edit-mark" aria-hidden="true">…</span>
              Equality exceptions{groupPartial.length > 0
                ? ` (${groupPartial.length})`
                : ""}
            </button>
          </li>
          {#if !partialEnabled}
            <li class="menu-help">Select an equality constraint first</li>
          {:else if groupPartial.length > 0}
            <li class="menu-help">Listed parameters remain free</li>
          {/if}
        </ul>
      {/if}
    </li>
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

  .dropdown-submenu {
    position: relative;
  }

  .dropdown-submenu > .dropdown-menu {
    top: 0;
    left: 100%;
    margin-top: -6px;
    margin-left: -1px;
    border-radius: 0 6px 6px 6px;
  }

  .dropdown-submenu:not(.disabled):hover > .dropdown-menu,
  .dropdown-submenu:not(.disabled):focus-within > .dropdown-menu {
    display: block;
  }

  .dropdown-submenu > a:after {
    display: block;
    content: " ";
    float: right;
    width: 0;
    height: 0;
    margin-top: 5px;
    margin-right: -10px;
    border: 5px solid transparent;
    border-right-width: 0;
    border-left-color: #ccc;
  }

  .equality-menu {
    min-width: 285px;
  }

  .disabled-option {
    color: #aaa;
    cursor: not-allowed;
  }

  .disabled-option:hover,
  .disabled-option:focus {
    background: transparent;
  }

  .edit-mark {
    display: inline-block;
    width: 14px;
    margin-right: 6px;
    text-align: center;
  }

  .menu-help {
    padding: 2px 20px 5px 30px;
    color: #777;
    font-size: 12px;
    white-space: nowrap;
  }

</style>
