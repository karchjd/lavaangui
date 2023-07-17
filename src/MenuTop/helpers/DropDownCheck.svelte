<script>
    import Dropdown from "./Dropdown.svelte";
    export let menuItems;
    export let name;
  </script>
  
  <Dropdown {name}>
    {#each menuItems as item}
    <li>
        <label>
          <input type="checkbox" class="check-box" bind:checked={item.checked}>
          {#if item.checked}
                <span class="glyphicon glyphicon-ok check-mark" aria-hidden="true"></span>
          {:else}
                <span class="glyphicon glyphicon-ok check-mark invisible" aria-hidden="true"></span>
          {/if}  {item.name}
        </label>
      </li>
      {#if item.divider}
        <li class="divider" />
      {/if}
    {/each}
  </Dropdown>

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
    margin:0;
    transition: background-color .4s ease;
  }
  li input {
    margin: 0px 5px;
    top: 2px;
    position: relative;
  }
  
  li.active label {
    background-color: #cbcbff;
    font-weight:bold;
  }
  
  li label:hover,
  li label:focus {
    background-color: #f5f5f5;
  }
  
  li.active label:hover,
  li.active label:focus {
    background-color: #b8b8ff;
  }
</style>
  