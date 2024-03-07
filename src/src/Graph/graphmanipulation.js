import { cyStore, ur } from "../stores.js";
import { get } from "svelte/store";
import { v4 as uuidv4 } from "uuid";
import { OBSERVED, LATENT } from "./classNames.js";


let obCounter;
let latentCounter;

export function resetCounters() {
  obCounter = 1;
  latentCounter = 1;
}

resetCounters();

// Adding new nodes via mouse, toolbar, or hotkey
export function addNode(nodeType, position, customLabel = null) {
  let cy = get(cyStore);
  let nodeId = uuidv4();
  let label;

  if (customLabel !== null) {
    label = customLabel;
  } else {
    if (nodeType == OBSERVED) {
      label = "x" + obCounter++;
    } else if (nodeType == LATENT) {
      label = "f" + latentCounter++;
    } else {
      label = undefined;
    }
  }

  // Check if position is provided, if not, use random position
  let urLocal = get(ur);
  if (position) {
    urLocal.do("add", {
      group: "nodes",
      data: { id: nodeId, label: label },
      classes: [nodeType, "continous"],
      renderedPosition: position,
    });
  } else {
    position = { x: Math.random() * 400 + 50, y: Math.random() * 400 + 50 };
    cy.add({
      group: "nodes",
      data: { id: nodeId, label: label },
      classes: [nodeType, "continous"],
      renderedPosition: position,
    });
  }

  return nodeId;
  // if (nodeType !== "constant") {
  //     let edgeId = 'edge' + edgeIdCounter++;
  //     cy.add({
  //         group: 'edges',
  //         data: {
  //             id: edgeId,
  //             source: nodeId,
  //             target: nodeId,
  //             label: ''
  //         },
  //         classes: 'loop free nolabel'
  //     });
  // }
}
