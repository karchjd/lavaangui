<script>
  export let name;
  export let checked;
  export let disable = false;
</script>

<li>
  <label class={disable ? "disabled-label" : ""}>
    <input type="checkbox" class="check-box" bind:checked disabled={disable} />
    {#if checked}
      <span class="glyphicon glyphicon-ok check-mark" aria-hidden="true" />
    {:else}
      <span
        class="glyphicon glyphicon-ok check-mark invisible"
        aria-hidden="true"
      />
    {/if}
    {name}
  </label>
</li>

<style>
  input[type="checkbox"] {
    display: none;
  }

  li label {
    display: block;
    padding: 3px 10px;
    clear: both;
    font-weight: normal;
    line-height: 1.42857143;
    color: #333;
    white-space: nowrap;
    margin: 0;
    transition: background-color 0.4s ease;
  }
  li input {
    margin: 0px 5px;
    top: 2px;
    position: relative;
  }

  li label:hover,
  li label:focus {
    background-color: #f5f5f5;
  }

  .disabled-label {
    color: #aaa; /* Grayed out text */
  }

  .disabled-label:hover {
    cursor: not-allowed; /* Forbidden sign cursor */
  }
</style>
