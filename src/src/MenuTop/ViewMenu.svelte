<script>
  import { gridViewOptions } from "../stores";
  import CheckItem from "./helpers/CheckItem.svelte";
  import Dropdown from "./helpers/Dropdown.svelte";
  import RadioItem from "./helpers/RadioItem.svelte";
  import { edgeItems, viewRadios } from "./viewModule";
  export let minimal = false;
</script>

<Dropdown name="View" {minimal}>
  {#each edgeItems as item}
    <CheckItem
      bind:name={item.name}
      bind:checked={$gridViewOptions[item.modelSlot]}
      disable={false}
    />
  {/each}
  <li class="divider" />
  <CheckItem
    name={"Standardized Estimates"}
    bind:checked={$gridViewOptions.std}
    disable={false}
  />
  <li class="divider" />
  {#each viewRadios as item}
    <RadioItem
      name={item.name}
      value={item.value}
      bind:group={$gridViewOptions.view}
    />
  {/each}
  <li style="padding-left: 28px;">
    Confidence Level
    <input
      id="confindence_level"
      type="number"
      class="shiny-input-number form-control"
      value="0.95"
      min="0"
      max="0.999999"
      step="0.01"
      style="width: 6em"
    />
  </li>
</Dropdown>
