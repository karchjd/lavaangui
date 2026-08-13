<script>
  import { appState, modelOptions } from "../stores.js";
  import { groupLegendEntries } from "./groupDisplay.js";

  export let location = "graph";
  export let compact = false;

  $: entries = groupLegendEntries($appState.groupLabels);
</script>

{#if $modelOptions.groupVariable && entries.length > 1}
  <div
    class:compact
    class="group-order-legend"
    data-testid={`group-order-legend-${location}`}
    role="note"
    aria-label={`Group order for ${$modelOptions.groupVariable}`}
    title="Edge values use this left-to-right group order. @ means fixed, free! means explicitly forced free, and =name is an equality label."
  >
    <span class="group-title">
      {$modelOptions.groupVariable} group order:
    </span>
    <ol aria-label="Ordered groups">
      {#each entries as entry}
        <li data-testid={`group-order-${location}-${entry.position}`}>
          <span class="group-index" aria-label={`Position ${entry.position}`}>
            {entry.position}
          </span>
          <span class="group-label">{entry.label}</span>
        </li>
      {/each}
    </ol>
  </div>
{/if}

<style>
  .group-order-legend {
    z-index: 2;
    display: flex;
    flex: 0 0 auto;
    align-items: center;
    gap: 8px;
    min-height: 38px;
    padding: 5px 10px;
    border-bottom: 1px solid #d9e2ec;
    background: #f7faff;
    color: #333;
  }

  .group-order-legend.compact {
    align-items: flex-start;
    min-height: 0;
    padding: 6px 8px;
    font-size: 12px;
  }

  .group-title {
    flex: 0 0 auto;
    color: #23527c;
    font-weight: 600;
  }

  ol {
    display: flex;
    flex: 1 1 auto;
    flex-wrap: wrap;
    align-items: center;
    gap: 4px;
    min-width: 0;
    margin: 0;
    padding: 0;
    list-style: none;
  }

  li {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    white-space: nowrap;
  }

  li + li::before {
    margin-right: 1px;
    color: #8091a5;
    content: "|";
  }

  .group-index {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 19px;
    height: 19px;
    padding: 0 5px;
    border-radius: 10px;
    background: #337ab7;
    color: white;
    font-size: 11px;
    font-weight: 700;
    line-height: 19px;
  }

  .group-label {
    overflow: hidden;
    max-width: 180px;
    text-overflow: ellipsis;
  }

  .order-help {
    flex: 0 0 auto;
    color: #637487;
    font-size: 11px;
  }

  @media (max-width: 900px) {
    .order-help {
      display: none;
    }
  }
</style>
