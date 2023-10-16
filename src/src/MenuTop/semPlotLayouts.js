import { cyStore, ur } from "../stores.js";
import { get } from "svelte/store";
import { createSyntax } from "../Shiny/toR.js";

let lur = get(ur);
let counter = 0;
let undo = false;

function serverAvail() {
  return typeof Shiny === "object" && Shiny !== null;
}
function objectOfArraysToArrayOfObjects(obj) {
  const keys = Object.keys(obj);
  const length = obj[keys[0]].length;
  const result = [];

  for (let i = 0; i < length; i++) {
    const newObj = {};
    for (const key of keys) {
      newObj[key] = obj[key][i];
    }
    result.push(newObj);
  }

  return result;
}

export function applySemLayout(name, undo = true) {
  undo = undo;
  counter = counter + 1;
  let for_R = createSyntax(true);
  for_R.name = name;
  for_R.counter = counter;
  console.log("semLayout called");

  if (serverAvail()) {
    Shiny.setInputValue("layout", JSON.stringify(for_R));
    console.log("layout sent to R");
  }
}

if (serverAvail()) {
  Shiny.addCustomMessageHandler("semPlotLayout", function (layout_R) {
    console.log("layout received");

    layout_R = objectOfArraysToArrayOfObjects(layout_R);
    // Determine scale and translation factors
    const differenceX = 125;
    const differenceY = 300;
    let minDiffX = Infinity;
    let minDiffY = Infinity;

    for (let i = 0; i < layout_R.length; i++) {
      for (let j = i + 1; j < layout_R.length; j++) {
        const diffX = Math.abs(layout_R[i].x - layout_R[j].x);
        const diffY = Math.abs(layout_R[i].y - layout_R[j].y);

        if (diffX < minDiffX && layout_R[i].y === layout_R[j].y)
          minDiffX = diffX;
        if (diffY < minDiffY && layout_R[i].x === layout_R[j].x)
          minDiffY = diffY;
      }
    }
    const xScale = differenceX / minDiffX;
    const yScale = differenceY / minDiffY;

    let options = {
      name: "preset",
      positions: function (node) {
        // find the node in your predefined nodes array
        const nodeName = node.data("label");
        const nodeInfo = layout_R.find((n) => n.name === nodeName);

        if (nodeInfo) {
          return {
            x: nodeInfo.x * xScale + 400,
            y: nodeInfo.y * -1 * yScale + 400,
          };
        }
        return undefined; // return undefined if not found in your predefined array
      },
      fit: true,
      padding: 60,
      animate: true,
    };

    // Run the layout
    if (undo) {
      lur.do("layout", { options: options });
    } else {
      const cy = get(cyStore);
      cy.layout(options).run();
      console.log("layout applied");
    }
  });
}
