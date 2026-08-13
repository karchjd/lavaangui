<script>
  import {
    groupPartialDialog,
    modelOptions,
  } from "../stores.js";
  import { GROUP_EQUAL_OPTIONS } from "../Graph/groupConstraints.js";

  $: sections = GROUP_EQUAL_OPTIONS
    .map((category) => ({
      ...category,
      options: $groupPartialDialog.options.filter(
        (option) => option.category === category.value,
      ),
    }))
    .filter((section) => section.options.length > 0);

  function close() {
    $groupPartialDialog = { open: false, options: [], selected: [] };
  }

  function toggle(syntax) {
    const selected = new Set($groupPartialDialog.selected);
    if (selected.has(syntax)) {
      selected.delete(syntax);
    } else {
      selected.add(syntax);
    }
    $groupPartialDialog = {
      ...$groupPartialDialog,
      selected: $groupPartialDialog.options
        .map((option) => option.syntax)
        .filter((value) => selected.has(value)),
    };
  }

  function clearAll() {
    $modelOptions.groupPartial = [];
    close();
  }

  function apply() {
    $modelOptions.groupPartial = [...$groupPartialDialog.selected];
    close();
  }

  function handleKeydown(event) {
    if ($groupPartialDialog.open && event.key === "Escape") close();
  }
</script>

<svelte:window on:keydown={handleKeydown} />

{#if $groupPartialDialog.open}
  <div class="modal-backdrop fade in exception-backdrop" />
  <div
    class="modal fade in exception-dialog"
    role="dialog"
    aria-modal="true"
    aria-labelledby="group-partial-dialog-title"
  >
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button
            type="button"
            class="close"
            aria-label="Close"
            on:click={close}
          >
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="modal-title" id="group-partial-dialog-title">
            Equality exceptions
          </h4>
        </div>

        <div class="modal-body">
          <p>
            Select parameters that should remain freely estimated in every
            group.
          </p>
          <div class="exception-list">
            {#each sections as section}
              <section>
                <h5>{section.label}</h5>
                {#each section.options as option}
                  <label class="exception-row">
                    <input
                      type="checkbox"
                      checked={$groupPartialDialog.selected.includes(
                        option.syntax,
                      )}
                      on:change={() => toggle(option.syntax)}
                    />
                    <span>{option.display}</span>
                  </label>
                {/each}
              </section>
            {/each}
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-default" on:click={close}>
            Cancel
          </button>
          <button type="button" class="btn btn-default" on:click={clearAll}>
            Clear all
          </button>
          <button type="button" class="btn btn-primary" on:click={apply}>
            Apply
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .exception-backdrop {
    z-index: 1060;
  }

  .exception-dialog {
    z-index: 1070;
    display: block;
    overflow-x: hidden;
    overflow-y: auto;
  }

  .exception-list {
    max-height: 55vh;
    overflow-y: auto;
    padding-right: 8px;
  }

  section + section {
    margin-top: 16px;
  }

  h5 {
    margin: 0 0 5px;
    font-weight: 700;
  }

  .exception-row {
    display: flex;
    align-items: center;
    gap: 9px;
    margin: 0;
    padding: 7px 9px;
    border-radius: 3px;
    font-weight: normal;
    cursor: pointer;
  }

  .exception-row:hover,
  .exception-row:focus-within {
    background-color: #f5f5f5;
  }

  .exception-row input[type="checkbox"] {
    position: static;
    display: inline-block;
    flex: 0 0 auto;
    width: 16px;
    height: 16px;
    margin: 0;
    cursor: pointer;
  }
</style>
