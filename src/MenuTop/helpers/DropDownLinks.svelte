<script>
  import Dropdown from "./Dropdown.svelte";
  export let menuItems;
  export let name;
</script>

<Dropdown {name}>
  {#each menuItems as item}
    <li class:disabled={item.disable}>
      <a href="#" on:click={item.action}>{item.name}</a>
    </li>
    {#if item.divider}
      <li class="divider" />
    {/if}
  {/each}
</Dropdown>
