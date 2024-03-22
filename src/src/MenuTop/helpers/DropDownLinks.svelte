<script>
  import Dropdown from "./Dropdown.svelte";
  export let menuItems;
  export let name;
  export let minimal;

  function handleClick(event, item) {
    if (!item.disable) {
      item.action(event);
    }
  }
</script>

<Dropdown {minimal} {name}>
  {#each menuItems as item}
    <li class:disabled={item.disable}>
      <a href={"#"} on:click={(event) => handleClick(event, item)}
        >{item.name}</a
      >
    </li>
    {#if item.divider}
      <li class="divider" />
    {/if}
  {/each}
</Dropdown>
