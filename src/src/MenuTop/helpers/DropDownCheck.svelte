<script>
  import CheckItem from "./CheckItem.svelte";
  import Dropdown from "./Dropdown.svelte";
  export let menuItems;
  export let name;
</script>

<Dropdown {name}>
  {#each menuItems as item}
    <CheckItem
      bind:name={item.name}
      bind:checked={item.checked}
      bind:divider={item.divider}
    />
  {/each}
</Dropdown>
