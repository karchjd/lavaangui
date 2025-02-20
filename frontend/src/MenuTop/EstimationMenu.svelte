<script>
  import Dropdown from "./helpers/Dropdown.svelte";
  import { modelOptions } from "../stores.js";
  import RadioItem from "./helpers/RadioItem.svelte";
  import TextItem from "./helpers/TextItem.svelte";

  const estimatorRadios = [
    { value: "default", name: "Default" },
    { value: "ML", name: "Maximum Likelihood (ML)" },
    { value: "GLS", name: "Generalized Least Squares (GLS)" },
    {
      value: "WLS",
      name: "Weighted Least Squares (WLS)",
    },
    { value: "ULS", name: "Unweighted Least Squares (ULS)" },
    { value: "DWLS", name: "Diagonally Weighted Least Squares (DWLS)" },
    { value: "DLS", name: "Distributionally-weighted Least Squares (DLW)" },
  ];

  const standardErrors = [
    { value: "default", name: "Default" },
    { value: "robust", name: "Robust" },
    { value: "boot", name: "Bootstrap" },
  ];

  const test = [
    { value: "default", name: "Default" },
    { value: "boot", name: "Bootstrap" },
  ];

  const missingValues = [
    { value: "listwise", name: "Listwise Deletion" },
    { value: "ml", name: "Full Information Maximum Likelihood (FIML)" },
  ];

  const name = "Estimation";
</script>

<Dropdown {name}>
  <li class="dropdown-submenu">
    <a tabindex="-1" href={"#"}>Estimator</a>
    <ul class="dropdown-menu">
      {#each estimatorRadios as item}
        <RadioItem
          name={item.name}
          value={item.value}
          bind:group={$modelOptions.estimator}
        />
      {/each}
    </ul>
  </li>
  <li class="dropdown-submenu">
    <a tabindex="-1" href={"#"}>Standard Error</a>
    <ul class="dropdown-menu">
      {#each standardErrors as item}
        <RadioItem
          name={item.name}
          value={item.value}
          bind:group={$modelOptions.se}
        />
      {/each}
      <TextItem
        name={"Number of Bootstrap Samples:"}
        bind:value={$modelOptions.n_boot}
        min={5}
      />
    </ul>
  </li>
  <li class="dropdown-submenu">
    <a tabindex="-1" href={"#"}>Missing Values</a>
    <ul class="dropdown-menu">
      {#each missingValues as item}
        <RadioItem
          name={item.name}
          value={item.value}
          bind:group={$modelOptions.missing}
        />
      {/each}
    </ul>
  </li>
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
