import { get } from "svelte/store";
import { cyStore, gridViewOptions } from "../stores.js";
import { updateLabels } from "../MenuTop/viewModule.js";

export function activateEstimateGroup(groupId) {
  const cy = get(cyStore);
  if (!cy || groupId == null) return;

  const key = String(groupId);
  cy.edges().forEach((edge) => {
    const estimatesByGroup = edge.data("estimatesByGroup");
    if (!estimatesByGroup) return;

    if (Object.prototype.hasOwnProperty.call(estimatesByGroup, key)) {
      edge.data("estimates", estimatesByGroup[key]);
    } else {
      edge.removeData("estimates");
    }
  });

  const view = get(gridViewOptions);
  updateLabels(view.view, view.std, view.number_digits);
}
