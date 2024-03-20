<script>
  import { gridViewOptions } from "../stores";
  import CheckItem from "./helpers/CheckItem.svelte";
  import Dropdown from "./helpers/Dropdown.svelte";
  import RadioItem from "./helpers/RadioItem.svelte";
  import { edgeItems, viewRadios } from "./viewModule";
  export let minimal = false;
  import TextItem from "./helpers/TextItem.svelte";

  $: {
    Shiny.setInputValue("ests-confindence_level", $gridViewOptions.ci);
  }
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
  <li class="divider" />
  <li style="padding-left: 28px;">
    Confidence Level
    <input
      type="number"
      bind:value={$gridViewOptions.ci}
      min="0"
      max="0.999999"
      step="0.01"
      style="width: 4em"
    />
  </li>
  <TextItem
    name={"Number Digits"}
    bind:value={$gridViewOptions.number_digits}
    min={0}
  />
</Dropdown>
