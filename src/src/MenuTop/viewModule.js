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

export function updateLabels(viewOption, std) {
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
      return (edge) => edge.data("estimates")["est" + postfix];
    case "ci":
      return (edge) =>
        `[${edge.data("estimates")["ciLow" + postfix]}, ${edge.data("estimates")["ciHigh" + postfix]
        }]`;
    case "estPVal":
      return (edge) =>
        `${edge.data("estimates")["est" + postfix]}${getStars(
          edge.data("estimates")["p_value"]
        )}`;
    case "estSE":
      return (edge) =>
        `${edge.data("estimates")["est" + postfix]} (${edge.data("estimates")["se" + postfix]
        })`;
    default:
      return (edge) => ""; // Or some default behavior
  }
}

function generateLabeledStyleEst(viewOption, postfix) {
  const baseStyle = generateStyleEst(viewOption, postfix);
  return (edge) => `${edge.data("label")} = ${baseStyle(edge)}`;
}
