import { cyStore } from "../stores.js";
import { get } from "svelte/store";

let obCounter = 1;
let latentCounter = 1;
// let edgeIdCounter = 0;
let nodeIdCounter = 0;

// Adding new nodes via mouse, toolbar, or hotkey
export function addNode(nodeType, position) {
  let cy = get(cyStore);
  let nodeId = "node" + nodeIdCounter++;
  let label;
  if (nodeType == "observed-variable") {
    label = "x" + obCounter++;
  } else if (nodeType == "latent-variable") {
    label = "f" + latentCounter++;
  } else {
    label = "hallo";
  }

  // Check if position is provided, if not, use random position
  let finalPosition = position
    ? position
    : { x: Math.random() * 400 + 50, y: Math.random() * 400 + 50 };

  cy.add({
    group: "nodes",
    data: { id: nodeId, label: label },
    classes: nodeType,
    position: finalPosition,
  });
  console.log(nodeIdCounter);

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
