<script>
  import Dropdown from "./helpers/Dropdown.svelte";
  import CheckItem from "./helpers/CheckItem.svelte";
  import { appState } from "../stores.js";
  let name = "Mean Options";
  let structureRadios = [
    { name: "Automatic", value: "default" },
    { name: "Yes", value: "true" },
    { name: "No", value: "false" },
  ];
  $: console.log($appState.intLvFree);
  $: disabledInts = $appState.meanStruc === "false";
</script>

<Dropdown {name}>
  <li class="dropdown-submenu">
    <a tabindex="-1" href="#">Model Means?</a>
    <ul class="dropdown-menu">
      {#each structureRadios as item}
        <li>
          <label>
            <input
              type="radio"
              name="meanStruc"
              value={item.value}
              bind:group={$appState.meanStruc}
            />
            {#if $appState.meanStruc === item.value}<span
                class="glyphicon glyphicon-ok check-mark"
                aria-hidden="true"
              />
            {:else}
              <span
                class="glyphicon glyphicon-ok check-mark invisible"
                aria-hidden="true"
              />
            {/if}
            {item.name}
          </label>
        </li>
      {/each}
    </ul>
    <CheckItem
      name="Add intercepts for all observed variables"
      bind:checked={$appState.intOvFree}
      bind:disable={disabledInts}
    />
    <CheckItem
      name="Add intercepts for all latent variables"
      bind:checked={$appState.intLvFree}
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

  li label {
    display: block;
    padding: 3px 10px;
    clear: both;
    font-weight: normal;
    line-height: 1.42857143;
    color: #333;
    white-space: nowrap;
    margin: 0;
    transition: background-color 0.4s ease;
  }

  input[type="radio"] {
    display: none;
  }

  li input {
    margin: 0px 5px;
    top: 2px;
    position: relative;
  }

  li label:hover,
  li label:focus {
    background-color: #f5f5f5;
  }
</style>
