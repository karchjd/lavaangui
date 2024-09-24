import { get } from "svelte/store";
import { cyStore } from "../stores";
import { checkNodeLoop } from "../Graph/checkNodeLoop";

export const edgeItems = [
  {
    name: "Arrows Created by Lavaan",
    modelSlot: "showLav",
  },
  { name: "Variance Arrows", modelSlot: "showVar" },
  { name: "Mean Arrows", modelSlot: "showMean" },
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

  const fixedEstStyle = generateFixedEstStyle(viewOption, postfix, number_digits);
  cy.style().selector("edge.hasEstFixed").style({ label: fixedEstStyle }).update();
}

export function updateVisibility(showVar, showLav, showMean, menuItems) {
  const cy = get(cyStore);
  const showElement = [showLav, showVar, showMean];

  function applyFunction(i, elements) {
    const functionsArray = [
      elements => elements.isLavaanAdded(),
      elements => elements.isLoop(),
      elements => elements.isMean(),
      // Add more functions as needed
    ];
    return functionsArray[i](elements);
  }
  for (let i of [0, 1, 2]) {
    const elements = cy.elements(function (ele) { return applyFunction(i, ele) });
    if (showElement[i]) {
      elements.removeClass('hidden');
    } else {
      elements.addClass('hidden');
    }
    if (i == 2) {
      const conNodes = elements.connectedEdges().connectedNodes();
      const connectedEdges = elements.connectedEdges();
      if (showElement[i]) {
        connectedEdges.forEach(edge => {
          edge.removeClass('hidden');
        });
      } else {
        connectedEdges.forEach(edge => {
          edge.addClass('hidden');
        });
      }
      conNodes.forEach(node => {
        checkNodeLoop(node.id());
      });
    } else {
      elements.forEach(ele => {
        checkNodeLoop(ele.source().id());
        checkNodeLoop(ele.target().id());
      });
    }
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

function generateFixedEstStyle(viewOption, postfix, number_digits) {
  const formatValue = (value) => value === null ? "NA" : value.toFixed(number_digits);
  return (edge) => {
    return "@" + formatValue(edge.data("estimates")["estFixed" + postfix]);
  };
}
