<script>
  import { modelOptions } from "../stores";
  import CheckItem from "./helpers/CheckItem.svelte";
  import Dropdown from "./helpers/Dropdown.svelte";
  import RadioItem from "./helpers/RadioItem.svelte";
  import { edgeItems, viewRadios } from "./viewModule";
</script>

<Dropdown name="View">
  {#each edgeItems as item}
    <CheckItem
      bind:name={item.name}
      bind:checked={$modelOptions[item.modelSlot]}
      disable={false}
    />
  {/each}
  <li class="divider" />
  <CheckItem
    name={"Standardized Estimates"}
    bind:checked={$modelOptions.std}
    disable={false}
  />
  <li class="divider" />
  {#each viewRadios as item}
    <RadioItem
      name={item.name}
      value={item.value}
      bind:group={$modelOptions.view}
    />
  {/each}
</Dropdown>
