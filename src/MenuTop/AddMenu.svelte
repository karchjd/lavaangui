<script>
  import CheckItem from "./helpers/CheckItem.svelte";
  import { modelOptions } from "../stores.js";
  import Dropdown from "./helpers/Dropdown.svelte";

  $: menuItems = [
    {
      name: "Fix Factor Loading of First Indicator at 1",
      modelProperty: "fix_first",
    },
    {
      name: "Fix Variance of Only Indicator to 0",
      modelProperty: "fix_single",
    },
    {
      name: "Include Variances of Exogenous Latent Variables",
      modelProperty: "auto_var",
    },
    {
      name: "Include Covariances of Exogenous Latent Variables",
      modelProperty: "auto_cov_lv_x",
    },
    {
      name: "Include covariances of Dependent Variables",
      modelProperty: "auto_cov_y",
    },
  ];

  const name = "Automatically..";
</script>

<Dropdown {name}>
  {#each menuItems as item}
    <CheckItem
      bind:name={item.name}
      bind:checked={$modelOptions[item.modelProperty]}
    />
  {/each}
</Dropdown>
