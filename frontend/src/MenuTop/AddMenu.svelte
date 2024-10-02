<script>
  import CheckItem from "./helpers/CheckItem.svelte";
  import { modelOptions } from "../stores.js";
  import Dropdown from "./helpers/Dropdown.svelte";
  import RadioItem from "./helpers/RadioItem.svelte";

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

  let structureRadios = [
    { name: "Default", value: "default" },
    { name: "Yes", value: "true" },
    { name: "No", value: "false" },
  ];
  $: disabledInts = $modelOptions.meanStruc === "false";
</script>

<Dropdown {name}>
  {#each menuItems as item}
    <CheckItem
      bind:name={item.name}
      bind:checked={$modelOptions[item.modelProperty]}
    />
  {/each}
  <li class="dropdown-submenu">
    <a tabindex="-1" href={"#"}>Add Means?</a>
    <ul class="dropdown-menu">
      {#each structureRadios as item}
        <RadioItem
          name={item.name}
          value={item.value}
          bind:group={$modelOptions.meanStruc}
        />
      {/each}
    </ul>
  </li>
  <CheckItem
    name="Add Intercepts for all Observed Variables"
    bind:checked={$modelOptions.intOvFree}
    bind:disable={disabledInts}
  />
  <CheckItem
    name="Add Intercepts for all Latent Variables"
    bind:checked={$modelOptions.intLvFree}
    bind:disable={disabledInts}
  />
</Dropdown>

<style>
  .dropdown-submenu {
    position: relative;
  }

  .dropdown-submenu > .dropdown-menu {
    top: 0;
    left: 100%;
    margin-top: -6px;
    margin-left: -1px;
    -webkit-border-radius: 0 6px 6px 6px;
    -moz-border-radius: 0 6px 6px;
    border-radius: 0 6px 6px 6px;
  }

  .dropdown-submenu:hover > .dropdown-menu {
    display: block;
  }

  .dropdown-submenu > a:after {
    display: block;
    content: " ";
    float: right;
    width: 0;
    height: 0;
    border-color: transparent;
    border-style: solid;
    border-width: 5px 0 5px 5px;
    border-left-color: #ccc;
    margin-top: 5px;
    margin-right: -10px;
  }

  .dropdown-submenu:hover > a:after {
    border-left-color: #fff;
  }
</style>
