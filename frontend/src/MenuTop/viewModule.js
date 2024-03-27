import { get } from "svelte/store";
import { cyStore } from "../stores";

export const edgeItems = [
  {
    name: "Arrows Created by Lavaan",
    modelSlot: "showLav",
    class: "fromLav",
  },
  { name: "Variance Arrows", modelSlot: "showVar", class: "loop" },
];

export let viewRadios = [
  { name: "Estimate", value: "est" },
  { name: "Confidence Interval", value: "ci" },
  { name: "Estimate + p-value (stars)", value: "estPVal" },
  { name: "Estimate + Standard Error", value: "estSE" },
];

export function updateLabels(viewOption, std, number_digits) {
  const cy = get(cyStore);
  const postfix = std ? "_std" : "";

  const styleEst = generateStyleEst(viewOption, postfix, number_digits);
  cy.style().selector("edge.hasEst").style({ label: styleEst }).update();

  const labeledStyleEst = generateLabeledStyleEst(viewOption, postfix, number_digits);
  cy.style()
    .selector("edge.hasEst.label")
    .style({ label: labeledStyleEst })
    .update();
}

export function updateVisibility(showVar, showLav, menuItems) {
  const cy = get(cyStore);
  if (showLav && showVar) {
    cy.elements("." + menuItems[0].class).show();
    cy.elements("." + menuItems[1].class).show();
  } else if (showLav && !showVar) {
    cy.elements("." + menuItems[0].class).show();
    cy.elements("." + menuItems[1].class).hide();
  } else if (!showLav && showVar) {
    cy.elements("." + menuItems[1].class).show();
    cy.elements("." + menuItems[0].class).hide();
  } else {
    cy.elements("." + menuItems[1].class).hide();
    cy.elements("." + menuItems[0].class).hide();
  }
}

function getStars(pval) {
  if (pval === null) return "NA";
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


function generateStyleEst(viewOption, postfix, number_digits) {
  const formatValue = (value) => value === null ? "NA" : value.toFixed(number_digits);

  switch (viewOption) {
    case "est":
      return (edge) => formatValue(edge.data("estimates")["est" + postfix]);
    case "ci":
      return (edge) =>
        `[${formatValue(edge.data("estimates")["ciLow" + postfix])}, ${formatValue(edge.data("estimates")["ciHigh" + postfix])}]`;
    case "estPVal":
      return (edge) =>
        `${formatValue(edge.data("estimates")["est" + postfix])}${getStars(edge.data("estimates")["p_value"])}`;
    case "estSE":
      return (edge) =>
        `${formatValue(edge.data("estimates")["est" + postfix])} (${formatValue(edge.data("estimates")["se" + postfix])})`;
    default:
      return () => "NA"; // Or some default behavior
  }
}


function generateLabeledStyleEst(viewOption, postfix, number_digits) {
  const baseStyle = generateStyleEst(viewOption, postfix, number_digits);
  return (edge) => `${edge.data("label")} = ${baseStyle(edge)}`;
}
