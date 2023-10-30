<script>
  import Dropdown from "./Dropdown.svelte";
  export let menuItems;
  export let name;
  export let minimal;
</script>

<Dropdown {minimal} {name}>
  {#each menuItems as item}
    <li class:disabled={item.disable}>
      <a href={"#"} on:click={item.action}>{item.name}</a>
    </li>
    {#if item.divider}
      <li class="divider" />
    {/if}
  {/each}
</Dropdown>
