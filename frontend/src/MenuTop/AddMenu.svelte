<script>
  import CheckItem from "./helpers/CheckItem.svelte";
  import { modelOptions } from "../stores.js";
  import Dropdown from "./helpers/Dropdown.svelte";

  const menuItems = [
    {
      name: "Fix Factor Loading of First Indicator at 1",
      modelProperty: "fix_first",
    },
    {
      name: "Include Variances",
      modelProperty: "auto_var",
    },
    {
      name: "Include Covariances of Exogenous Latent Variables",
      modelProperty: "auto_cov_lv_x",
    },
    {
      name: "Include Covariances of Dependent Variables",
      modelProperty: "auto_cov_y",
    },
    {
      name: "Fix Variance of Only Indicator to 0",
      modelProperty: "fix_single",
    },
    {
      name: "Treat Exogenous Observed Variables as Fixed Variables",
      modelProperty: "fixed_x",
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
