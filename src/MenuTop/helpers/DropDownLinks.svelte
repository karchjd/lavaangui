<script>
  import Dropdown from "./Dropdown.svelte";
  export let menuItems;
  export let name;
</script>

<Dropdown {name}>
  {#each menuItems as { name, action, divider }}
    <li><a href="#" on:click={action}>{name}</a></li>
    {#if divider}
      <li class="divider" />
    {/if}
  {/each}
</Dropdown>
