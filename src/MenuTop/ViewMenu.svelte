<script>
  import { cyStore, modelOptions } from "../stores";
  import { get } from "svelte/store";
  import CheckItem from "./helpers/CheckItem.svelte";
  import Dropdown from "./helpers/Dropdown.svelte";
  import RadioItem from "./helpers/RadioItem.svelte";
  import { onMount } from "svelte";

  const edgeItems = [
    {
      name: "Arrows Created by Lavaan",
      modelSlot: "showLav",
      class: "fromLav",
    },
    { name: "Variance Arrows", modelSlot: "showVar", class: "loop" },
  ];

  let viewRadios = [
    { name: "Estimate", value: "est" },
    { name: "Confidence Interval", value: "ci" },
    { name: "Estimate + p-value (stars)", value: "estPVal" },
    { name: "Estimate + Standard Error", value: "estSE" },
  ];

  $: {
    updateVisibility($modelOptions, edgeItems);
  }
  let mounted = false;

  //to make sure the cy instance exists before first update
  onMount(() => {
    mounted = true;
  });

  $: {
    if (mounted) {
      updateLabels($modelOptions.view, $modelOptions.std);
    }
  }

  function updateVisibility(modelOptions, menuItems) {
    const cy = get(cyStore);
    if (modelOptions.showLav && modelOptions.showVar) {
      cy.elements("." + menuItems[0].class).show();
      cy.elements("." + menuItems[1].class).show();
    } else if (modelOptions.showLav && !modelOptions.showVar) {
      cy.elements("." + menuItems[0].class).show();
      cy.elements("." + menuItems[1].class).hide();
    } else if (!modelOptions.showLav && modelOptions.showVar) {
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

  function generateStyleEst(viewOption, postfix) {
    switch (viewOption) {
      case "est":
        return (edge) => edge.data("est" + postfix);
      case "ci":
        return (edge) =>
          `[${edge.data("ciLow" + postfix)}, ${edge.data("ciHigh" + postfix)}]`;
      case "estPVal":
        return (edge) =>
          `${edge.data("est" + postfix)}${getStars(edge.data("p_value"))}`;
      case "estSE":
        return (edge) =>
          `${edge.data("est" + postfix)} (${edge.data("se" + postfix)})`;
      default:
        return (edge) => ""; // Or some default behavior
    }
  }

  function generateLabeledStyleEst(viewOption, postfix) {
    const baseStyle = generateStyleEst(viewOption, postfix);
    return (edge) => `${edge.data("label")} = ${baseStyle(edge)}`;
  }

  function updateLabels(viewOption, std) {
    const cy = get(cyStore);
    const postfix = std ? "_std" : "";

    const styleEst = generateStyleEst(viewOption, postfix);
    cy.style().selector("edge.hasEst").style({ label: styleEst }).update();

    const labeledStyleEst = generateLabeledStyleEst(viewOption, postfix);
    cy.style()
      .selector("edge.hasEst.label")
      .style({ label: labeledStyleEst })
      .update();
  }
</script>

<Dropdown name="View">
  {#each edgeItems as item}
    <CheckItem
      bind:name={item.name}
      bind:checked={$modelOptions[item.modelSlot]}
      disable={false}
    />
  {/each}
  <li class="divider" />
  <CheckItem
    name={"Standardized Estimates"}
    bind:checked={$modelOptions.std}
    disable={false}
  />
  <li class="divider" />
  {#each viewRadios as item}
    <RadioItem
      name={item.name}
      value={item.value}
      bind:group={$modelOptions.view}
    />
  {/each}
</Dropdown>
