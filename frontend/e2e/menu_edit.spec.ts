/// <reference types="node" />

import { test, expect } from "./fixtures";
import path from "path";
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);

// test("testundoredo", async ({ page }) => {
//     await page.waitForTimeout(500);
//     const targetNodeId = "c0dd806d-56fa-415f-b43f-1bc10b21b1e8";
//     const nodePosition = await ((id) => {
//         // Check if the Cytoscape instance is available on the window object
//         // NOTE: Replace 'cy' with the actual global variable name if different
//         const cy = window.cy;

//         if (!cy) {
//             throw new Error('Cytoscape instance (window.cy) not found.');
//         }

//         // Get the specific element by its ID
//         const element = cy.getElementById(id);
//         console.log("Element found:", element);


//         // Get the rendered position of the element's center.
//         // This position is relative to the top-left corner of the canvas container.
//         const renderedPos = element.renderedPosition();

//         // Return only the x and y coordinates.
//         return {
//             x: renderedPos.x,
//             y: renderedPos.y,
//         };

//     }, targetNodeId); // Pass the node ID into the evaluate function

//     // 3. Select the canvas element and click it at the calculated position
//     // (This is the same locator you used before)
//     await page.locator('#cy-node-edge-editing-stage0 canvas').click({
//         position: {
//             x: Math.round(nodePosition.x), // Ensure coordinates are integers
//             y: Math.round(nodePosition.y),
//         }
//     });
// });