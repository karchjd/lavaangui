<script>
  import { cyStore, modelOptions } from "../stores";
  import { get } from "svelte/store";
  import CheckItem from "./helpers/CheckItem.svelte";
  import Dropdown from "./helpers/Dropdown.svelte";
  import RadioItem from "./helpers/RadioItem.svelte";
  import { onMount } from "svelte";

  $: edgeItems = [
    {
      name: "Edges Created by Lavaan",
      checked: $modelOptions.showLav,
      class: "fromLav",
    },
    { name: "Variance Edges", checked: $modelOptions.showVar, class: "loop" },
  ];

  let viewRadios = [
    { name: "Estimate", value: "est" },
    { name: "Confidence intervals", value: "ci" },
    { name: "Estimate + p-value (stars)", value: "estPVal" },
  ];

  $: {
    updateVisibility(edgeItems);
  }
  let mounted = false;

  //to make sure the cy instance exists before first update
  onMount(() => {
    mounted = true;
  });

  $: {
    if (mounted) {
      updateLabels($modelOptions.view);
    }
  }

  function updateVisibility(menuItems) {
    const cy = get(cyStore);
    if (menuItems[0].checked && menuItems[1].checked) {
      cy.elements("." + menuItems[0].class).show();
      cy.elements("." + menuItems[1].class).show();
    } else if (menuItems[0].checked && !menuItems[1].checked) {
      cy.elements("." + menuItems[0].class).show();
      cy.elements("." + menuItems[1].class).hide();
    } else if (!menuItems[0].checked && menuItems[1].checked) {
      cy.elements("." + menuItems[1].class).show();
      cy.elements("." + menuItems[0].class).hide();
    } else {
      cy.elements("." + menuItems[1].class).hide();
      cy.elements("." + menuItems[0].class).hide();
    }
  }

  function getStars(pval) {
    if (pval < 0.001) {
      return "***";
    } else if (pval < 0.01) {
      return "**";
    } else if (pval < 0.05) {
      return "*";
    } else {
      return "";
    }
  }

  function updateLabels(viewOption) {
    const cy = get(cyStore);
    let styleEst;
    if (viewOption == "est") {
      styleEst = function (edge) {
        return edge.data("est");
      };
    } else if (viewOption == "ci") {
      styleEst = function (edge) {
        return "[" + edge.data("ciLow") + ", " + edge.data("ciHigh") + "]";
      };
    } else if (viewOption == "estPVal") {
      styleEst = function (edge) {
        return edge.data("est") + getStars(edge.data("p_value"));
      };
    }
    cy.style()
      .selector("edge.hasEst")
      .style({
        label: styleEst,
      })
      .update();
  }
</script>

<Dropdown name="View">
  {#each edgeItems as item}
    <CheckItem
      bind:name={item.name}
      bind:checked={item.checked}
      disable={false}
    />
  {/each}
  <li class="divider" />
  {#each viewRadios as item}
    <RadioItem
      name={item.name}
      value={item.value}
      bind:group={$modelOptions.view}
    />
  {/each}
</Dropdown>
