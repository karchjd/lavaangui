<script>
  export let name;
  export let value;
  export let group;
  export let isDisabled;
</script>

<div class={isDisabled ? "radio disabled" : "radio"}>
  <label class={isDisabled ? "text-muted" : ""}>
    <input
      type="radio"
      name="meanStruc"
      {value}
      bind:group
      disabled={isDisabled}
    />
    {#if group === value}<span
        class="glyphicon glyphicon-ok check-mark"
        aria-hidden="true"
      />
    {:else}
      <span
        class="glyphicon glyphicon-ok check-mark invisible"
        aria-hidden="true"
      />
    {/if}
    {name}
  </label>
</div>

<style>
  div label {
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

  input[type="radio"] {
    display: none;
  }

  div input {
    margin: 0px 5px;
    top: 2px;
    position: relative;
  }

  div label:hover,
  div label:focus {
    background-color: #f5f5f5;
  }

  .text-muted {
    color: #6c757d;
  }
</style>
