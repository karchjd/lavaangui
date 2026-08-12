<script>
  import { modelComparisonDialog } from "../stores.js";

  function close() {
    $modelComparisonDialog = {
      open: false,
      models: [],
      selected: [],
      validation: "",
      details: null,
      detailModelIndex: null,
      detailsLoading: false,
    };
  }

  function toggleModel(index) {
    const selected = $modelComparisonDialog.selected.includes(index)
      ? $modelComparisonDialog.selected.filter((value) => value !== index)
      : [...$modelComparisonDialog.selected, index];

    $modelComparisonDialog = {
      ...$modelComparisonDialog,
      selected,
      validation: "",
    };
  }

  function viewDetails(index) {
    if ($modelComparisonDialog.detailModelIndex === index) {
      $modelComparisonDialog = {
        ...$modelComparisonDialog,
        details: null,
        detailModelIndex: null,
        detailsLoading: false,
      };
      return;
    }

    $modelComparisonDialog = {
      ...$modelComparisonDialog,
      details: null,
      detailModelIndex: index,
      detailsLoading: true,
    };
    // @ts-expect-error
    Shiny.setInputValue("modelStore-modelDetails", {
      index,
      nonce: Math.random(),
    });
  }

  function compare() {
    if ($modelComparisonDialog.selected.length < 2) {
      $modelComparisonDialog = {
        ...$modelComparisonDialog,
        validation: "Select at least two models.",
      };
      return;
    }

    // @ts-expect-error
    Shiny.setInputValue("modelStore-compare", {
      indices: $modelComparisonDialog.selected,
      nonce: Math.random(),
    });
    close();
  }
</script>

{#if $modelComparisonDialog.open}
  <div class="modal-backdrop fade in comparison-backdrop"></div>
  <div
    class="modal fade in comparison-dialog"
    role="dialog"
    aria-modal="true"
    aria-labelledby="comparison-dialog-title"
  >
    <div class="modal-dialog dialog-wide" role="document">
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
          <h4 class="modal-title" id="comparison-dialog-title">
            Model Comparison
          </h4>
        </div>

        <div class="modal-body">
          <p>Select at least two models to compare:</p>
          <div class="model-list">
            {#each $modelComparisonDialog.models as model}
              <div class="model-row">
                <label>
                  <input
                    type="checkbox"
                    checked={$modelComparisonDialog.selected.includes(
                      model.index,
                    )}
                    on:change={() => toggleModel(model.index)}
                  />
                  {model.name}
                </label>
                <button
                  type="button"
                  class="btn btn-default btn-xs"
                  aria-expanded={$modelComparisonDialog.detailModelIndex ===
                    model.index}
                  on:click={() => viewDetails(model.index)}
                >
                  {$modelComparisonDialog.detailModelIndex === model.index
                    ? "Hide Details"
                    : "View Details"}
                </button>
              </div>
            {/each}
          </div>

          {#if $modelComparisonDialog.validation}
            <p class="text-danger">{$modelComparisonDialog.validation}</p>
          {/if}

          {#if $modelComparisonDialog.detailsLoading}
            <div class="details"><p>Loading model details…</p></div>
          {:else if $modelComparisonDialog.details}
            <section class="details">
              <h4>{$modelComparisonDialog.details.name}</h4>

              <h5>Path diagram</h5>
              <div class="diagram-frame">
                <img
                  src={$modelComparisonDialog.details.diagram}
                  alt={`Saved path diagram for ${$modelComparisonDialog.details.name}`}
                />
              </div>

              <h5>Model syntax</h5>
              <pre>{$modelComparisonDialog.details.syntax}</pre>

              <h5>Options</h5>
              <pre>{$modelComparisonDialog.details.call}</pre>
            </section>
          {/if}
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-default" on:click={close}>
            Cancel
          </button>
          <button type="button" class="btn btn-primary" on:click={compare}>
            Compare
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .comparison-backdrop {
    z-index: 1060;
  }

  .comparison-dialog {
    display: block;
    z-index: 1070;
    overflow-x: hidden;
    overflow-y: auto;
  }

  .dialog-wide {
    width: 70%;
  }

  .model-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .model-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 0;
    border-bottom: 1px solid #eee;
  }

  .model-row label {
    margin: 0;
  }

  .details {
    margin-top: 18px;
    padding-top: 12px;
    border-top: 1px solid #ddd;
  }

  .diagram-frame {
    box-sizing: border-box;
    width: 100%;
    height: min(480px, 55vh);
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    padding: 8px;
    border: 1px solid #ddd;
    background: white;
  }

  .diagram-frame img {
    max-width: 100%;
    max-height: 100%;
    width: auto;
    height: auto;
    object-fit: contain;
  }

  pre {
    max-height: 300px;
    overflow: auto;
    white-space: pre-wrap;
  }

  @media (max-width: 900px) {
    .dialog-wide {
      width: auto;
      margin: 10px;
    }
  }
</style>
