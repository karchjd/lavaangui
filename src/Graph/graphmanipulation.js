import { cyStore } from "../stores.js";
import { get } from "svelte/store";

let nodeIdCounter = 0;
let edgeIdCounter = 0;

// Adding new nodes via mouse, toolbar, or hotkey
export function addNode(nodeType, position) {
  let cy = get(cyStore);
  let nodeId = "node" + nodeIdCounter++;
  // if (label == undefined) {
  let label = "x" + nodeIdCounter;
  // }

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
