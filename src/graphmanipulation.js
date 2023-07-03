let nodeIdCounter = 0;
let edgeIdCounter = 0;

// Adding new nodes via mouse, toolbar, or hotkey
export function addNode(cy, nodeType, position) {
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
  console.log(nodeIdCounter)

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

// // Keyboard and mouse actions

// // Grab the container div, make it focusable and focus it
// let $cyContainer = $("#cy").attr("tabindex", "0").focus();

// // Keep track of mouse position
// let lastMousePosition = { x: 0, y: 0 };
// $("#cy").mousemove(function (event) {
//   lastMousePosition = {
//     x: event.offsetX,
//     y: event.offsetY,
//   };
// });

// // Focus the container when mouse is over it
// $cyContainer.on("mouseover", function () {
//   $(this).focus();
// });

// // Keyboard events
// $cyContainer.on("keydown", function (event) {
//   // Check if the Command key was pressed
//   if (event.key === "Meta" || event.key === "Control") {
//     eh.enableDrawMode();
//   }

//   // Handle Backspace key
//   if (event.key === "Backspace") {
//     let selectedElements = cy.$(":selected");
//     selectedElements.forEach(function (element) {
//       if (element.isNode()) {
//         element.remove();
//       } else if (element.isEdge()) {
//         element.remove();
//       }
//     });
//   }

//   // Handle 'l', 'o', 'c' keys
//   if (["l", "o", "c"].includes(event.key.toLowerCase())) {
//     let nodeType;
//     switch (event.key.toLowerCase()) {
//       case "l":
//         nodeType = "latent-variable";
//         break;
//       case "o":
//         nodeType = "observed-variable";
//         break;
//       case "c":
//         nodeType = "constant";
//         break;
//     }
//     addNode(nodeType, lastMousePosition); // Use the last known mouse position within Cytoscape container.
//   }
// });

// $cyContainer.on("keyup", function (event) {
//   // Check if the Command key was released
//   if (event.key === "Meta" || event.key === "Control") {
//     eh.disableDrawMode();
//   }
// });
