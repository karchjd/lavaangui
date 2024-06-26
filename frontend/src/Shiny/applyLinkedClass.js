import { cyStore, setAlert } from "../stores";
import { get } from "svelte/store";

export function applyLinkedClass(columnNames, apply) {
  if (columnNames == null) {
    throw new Error("Columnnames may not be null.");
  }
  let cy = get(cyStore);
  const nodes = cy.nodes(function (node) {
    return node.isObserved();
  });
  if (nodes.length > 0) {
    for (var i = 0; i < nodes.length; i++) {
      const node = nodes[i];
      const label = node.getLabel();
      if (columnNames.includes(label) && !node.isLinked()) {
        node.link();
      } else if (!columnNames.includes(label) && node.isLinked()) {
        node.unlink();
      }
    }
  }
}
