import { get } from "svelte/store";
import { cyStore, gridViewOptions } from "../stores.js";
import { updateLabels } from "../MenuTop/viewModule.js";

export function activateEstimateGroup(groupId) {
  const cy = get(cyStore);
  if (!cy || groupId == null) return;

  const key = String(groupId);
  cy.edges().forEach((edge) => {
    const legacyDisplayClass = ["hasEst", "hasEstFixed", "hasEstStd"]
      .find((className) => edge.hasClass(className));
    const legacyFixedUnderStd = edge.hasClass("fixedUnderStd");
    edge.removeClass("hasEst hasEstFixed hasEstStd fixedUnderStd");
    const estimatesByGroup = edge.data("estimatesByGroup");
    if (!estimatesByGroup) return;

    if (Object.prototype.hasOwnProperty.call(estimatesByGroup, key)) {
      const estimates = estimatesByGroup[key];
      edge.data("estimates", estimates);
      const displayClass = estimates.displayClass || legacyDisplayClass;
      if (displayClass) {
        edge.addClass(displayClass);
      }
      if (
        estimates.fixedUnderStd ||
        (!estimates.displayClass && legacyFixedUnderStd)
      ) {
        edge.addClass("fixedUnderStd");
      }
    } else {
      edge.removeData("estimates");
    }
  });

  const view = get(gridViewOptions);
  updateLabels(view.view, view.std, view.number_digits);
}
