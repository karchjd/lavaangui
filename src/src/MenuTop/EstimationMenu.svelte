<script>
  import Dropdown from "./helpers/Dropdown.svelte";
  import { modelOptions } from "../stores.js";
  import RadioItem from "./helpers/RadioItem.svelte";

  const estimatorRadios = [
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
    { value: "standard", name: "Standard" },
    { value: "robust", name: "Robust" },
    { value: "boot", name: "Bootstrap" },
  ];

  const robustSupported = ["ML", "ULS", "DWLS"];

  $: {
    if (
      $modelOptions.se == "robust" &&
      !robustSupported.includes($modelOptions.estimator)
    ) {
      $modelOptions.se = "standard";
      // @ts-expect-error
      bootbox.alert(
        "Standard error reset to Standard because selected estimator does not support robust standad errors."
      );
    }
  }

  const missingValues = [
    { value: "listwise", name: "Listwise" },
    { value: "ml", name: "Full Information Maximum Likelihood (FIML)" },
  ];

  const fimlSupported = ["ML"];

  $: {
    if (
      $modelOptions.missing == "ml" &&
      !fimlSupported.includes($modelOptions.estimator)
    ) {
      $modelOptions.missing = "listwise";
      // @ts-expect-error
      bootbox.alert(
        "Missing values set back to listwise. Only the maximum likelihood estimator supports Full information maximum likelihood."
      );
    }
  }

  let previousSE = null;

  $: {
    if ($modelOptions.se == "boot" && previousSE !== "boot") {
      // @ts-expect-error
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
              // @ts-expect-error
              bootbox.alert("Please enter a positive whole number.");
            }
          }
        },
      });
    }
    previousSE = $modelOptions.se;
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
          isDisabled={item.value == "robust" &&
            !fimlSupported.includes($modelOptions.estimator)}
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
          isDisabled={item.value == "ml" &&
            !robustSupported.includes($modelOptions.estimator)}
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
