<script>
  import Dropdown from "./helpers/Dropdown.svelte";
  import { modelOptions } from "../stores.js";
  import RadioItem from "./helpers/RadioItem.svelte";

  const estimatorRadios = [
    { value: "ML", name: "Maximum likelihood" },
    { value: "GLS", name: "Generalized least squares" },
    {
      value: "WLS",
      name: "Weighted least squares",
    },
    { value: "ULS", name: "Unweighted least squares" },
    { value: "DWLS", name: "Diagonally weighted least squares" },
    { value: "DLS", name: "Distributionally-weighted least squares" },
  ];

  const standardErrors = [
    { value: "standard", name: "Conventional" },
    { value: "robust", name: "Robust" },
    { value: "boot", name: "Bootstrap" },
  ];

  const missingValues = [
    { value: "listwise", name: "Listwise" },
    { value: "ml", name: "Full information maximum likelihood" },
  ];

  $: if ($modelOptions.se == "boot") {
    bootbox.prompt({
      title: "Enter the number of bootstrap draws:",
      value: $modelOptions.n_boot,
      callback: function (result) {
        if (result !== null) {
          const parsedValue = parseInt(result, 10);
          if (Number.isInteger(parsedValue) && parsedValue > 0) {
            $modelOptions.n_boot = parsedValue;
            return true;
          } else {
            return false;
            bootbox.alert("Please enter a positive whole number.");
          }
        }
      },
    });
  }
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
