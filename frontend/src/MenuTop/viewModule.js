import { get } from "svelte/store";
import { appState, cyStore } from "../stores.js";
import { checkNodeLoop } from "../Graph/checkNodeLoop.js";
import * as Constants from "../Graph/classNames.js";
import {
  formatGroupEstimateDisplay,
} from "../Graph/groupDisplay.js";
import {
  groupedLabelWidth,
  groupedParameterLabel,
} from "../Graph/cytoscape_settings.js";

export const edgeItems = [
  {
    name: "Arrows Created by Lavaan",
    modelSlot: "showLav",
  },
  { name: "Variance Arrows", modelSlot: "showVar" },
  { name: "Mean Arrows", modelSlot: "showMean" },
  { name: "Undirected Arrows", modelSlot: "showCov" }
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

  // For fixed edges, to show estimates when standardized estimates are requested
  if (std) {
    cy.style().selector("edge.hasEstStd").style({ label: styleEst }).update();
    cy.style().selector("edge.hasEstStd.label").style({ label: labeledStyleEst }).update();
    cy.style().selector("edge.fixedUnderStd").style({
      label: function (edge) {
        return "@1";
      }
    }).update();
    cy.style().selector("edge.fixedUnderStd.label").style({
      label: function (edge) {
        return (edge.data("displayLabel") || edge.data("label")) + "@1";
      }
    }).update();
  } else {
    cy.style().selector(`edge.${Constants.FIXED}.${Constants.NOT_LABEL}`).style(Constants.FIXEDSTYLE).update();
    cy.style().selector(`edge.${Constants.FIXED}.${Constants.LABEL}`).style(Constants.FIXEDSTYLELABEL).update();
  }


  // Update fixed estimates for ordinal variables
  const fixedEstStyle = generateFixedEstStyle(viewOption, postfix, number_digits);
  cy.style().selector("edge.hasEstFixed").style({ label: fixedEstStyle }).update();

  // Parsing may give a grouped edge a legacy fixed/label class based on group
  // one. Reapply the grouped parameter style after all legacy style rules.
  cy.style()
    .selector(`edge.groupParameters`)
    .style({
      label: groupedParameterLabel,
      "text-max-width": groupedLabelWidth,
    })
    .update();

  const groups = get(appState).groupLabels;
  if (groups.length > 1) {
    const groupedEstimateStyle = function (edge) {
      const display = formatGroupEstimateDisplay(
        groups,
        edge.data("estimatesByGroup"),
        {
          viewOption,
          standardized: std,
          digits: number_digits,
        },
        edge.data("groupParameters"),
      ).text;
      const state = edge.data("groupParameters");
      const prefix = edge.data("displayLabel")
        || (!state ? edge.data("label") : null);
      return prefix ? `${prefix} = ${display}` : display;
    };
    const groupedWidth = Math.min(500, Math.max(140, groups.length * 100));
    cy.style()
      .selector(`edge.${Constants.HAS_GROUP_ESTIMATES}`)
      .style({
        label: groupedEstimateStyle,
        "text-max-width": groupedWidth,
      })
      .update();
  }
}

export function updateVisibility(showVar, showLav, showMean, showCov) {
  function which(logicalVector) {
    return logicalVector.reduce((indices, value, index) => {
      if (value) {
        indices.push(index);
      }
      return indices;
    }, []);
  }

  const cy = get(cyStore);
  const showElement = [showLav, showVar, showMean, showCov];
  const trueIndices = which(showElement);
  const falseIndices = which(showElement.map((x) => !x));
  const allIndices = trueIndices.concat(falseIndices);


  function applyFunction(i, elements) {
    const functionsArray = [
      elements => elements.isLavaanAdded(),
      elements => elements.isLoop(),
      elements => elements.isMean(),
      elements => elements.isUndirected()
    ];
    return functionsArray[i](elements);
  }
  for (let i of allIndices) {
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
  const formatOrNA = (estimates, field) => {
    if (!estimates || estimates[field] == null) {
      return "NA";
    }
    const value = estimates[field];
    return value.toFixed(number_digits);
  };

  switch (viewOption) {
    case "est":
      return (edge) => formatOrNA(edge.data("estimates"), "est" + postfix);
    case "ci":
      return (edge) =>
        `[${formatOrNA(edge.data("estimates"), "ciLow" + postfix)}, ${formatOrNA(edge.data("estimates"), "ciHigh" + postfix)}]`;
    case "estPVal":
      return (edge) =>
        `${formatOrNA(edge.data("estimates"), "est" + postfix)}${getStars(formatOrNA(edge.data("estimates"), "p_value" + postfix))}`;
    case "estSE":
      return (edge) =>
        `${formatOrNA(edge.data("estimates"), "est" + postfix)} (${formatOrNA(edge.data("estimates"), "se" + postfix)})`;
    default:
      return () => "NA"; // Or some default behavior
  }
}


function generateLabeledStyleEst(viewOption, postfix, number_digits) {
  const baseStyle = generateStyleEst(viewOption, postfix, number_digits);
  return (edge) => `${edge.data("displayLabel") || edge.data("label")} = ${baseStyle(edge)}`;
}

function generateFixedEstStyle(viewOption, postfix, number_digits) {
  const formatValue = (value) => value === null ? "NA" : value.toFixed(number_digits);
  return (edge) => {
    return "@" + formatValue(edge.data("estimates")["estFixed" + postfix]);
  };
}
