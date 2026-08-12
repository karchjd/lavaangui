<script>
  import { fitMessages } from "../stores.js";

  const messageTypes = {
    warning: { className: "alert-warning", label: "Warning" },
    danger: { className: "alert-danger", label: "Error" },
  };
</script>

<section class="results-panel">
  {#if $fitMessages.length > 0}
    <div class="fit-messages" aria-live="polite">
      {#each $fitMessages as info}
        <div class={`alert ${messageTypes[info.type].className}`} role="alert">
          <strong>{messageTypes[info.type].label}:</strong>
          {info.message}
        </div>
      {/each}
    </div>
  {/if}

  <pre
    id="res-results"
    class="shiny-html-output well"
    data-testid="result-text"
  />
</section>

<style>
  .results-panel {
    display: flex;
    flex-basis: 30%;
    flex-direction: column;
    min-width: 0;
    min-height: 0;
  }

  .fit-messages {
    flex: 0 0 auto;
    max-height: 40%;
    overflow-y: auto;
    padding: 8px 8px 0;
  }

  .alert {
    margin-bottom: 8px;
  }

  pre {
    white-space: pre;
    text-align: left;
    display: flex;
    flex: 1 1 auto;
    flex-direction: column; /* Changed from row (default) to column */
    overflow-y: scroll;
    overflow-x: scroll;
    min-width: 0;
    min-height: 0;
    margin: 0;
  }
</style>
