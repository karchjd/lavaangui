<script>
  import Dropdown from "./helpers/Dropdown.svelte";
  import CheckItem from "./helpers/CheckItem.svelte";
  import { modelOptions } from "../stores.js";
  import RadioItem from "./helpers/RadioItem.svelte";

  let name = "Mean Options";
  let structureRadios = [
    { name: "Automatic", value: "default" },
    { name: "Yes", value: "true" },
    { name: "No", value: "false" },
  ];
  $: disabledInts = $modelOptions.meanStruc === "false";
</script>

<Dropdown {name}>
  <li class="dropdown-submenu">
    <a tabindex="-1" href="#">Model Means?</a>
    <ul class="dropdown-menu">
      {#each structureRadios as item}
        <RadioItem
          name={item.name}
          value={item.value}
          bind:group={$modelOptions.meanStruc}
        />
      {/each}
    </ul>
    <CheckItem
      name="Add intercepts for all observed variables"
      bind:checked={$modelOptions.intOvFree}
      bind:disable={disabledInts}
    />
    <CheckItem
      name="Add intercepts for all latent variables"
      bind:checked={$modelOptions.intLvFree}
      bind:disable={disabledInts}
    />
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

  .dropdown-submenu.pull-left {
    float: none;
  }

  .dropdown-submenu.pull-left > .dropdown-menu {
    left: -100%;
    margin-left: 10px;
    -webkit-border-radius: 6px 0 6px 6px;
    -moz-border-radius: 6px 0 6px 6px;
    border-radius: 6px 0 6px 6px;
  }
</style>
