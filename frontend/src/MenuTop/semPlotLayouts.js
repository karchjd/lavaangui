import { cyStore, ur } from "../stores.js";
import { get } from "svelte/store";
import { createSyntax } from "../Shiny/toR.js";

let counter = 0;
let undo = false;

function serverAvail() {
  // @ts-expect-error
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

export function applySemLayout(name, undoArg = true) {
  undo = undoArg;
  counter = counter + 1;
  let for_R = createSyntax(true);
  // @ts-expect-error
  for_R.name = name;
  // @ts-expect-error
  for_R.counter = counter;

  if (serverAvail()) {
    // @ts-expect-error
    Shiny.setInputValue("layout-layout", JSON.stringify(for_R));
  }
}

if (serverAvail()) {
  // @ts-expect-error
  Shiny.addCustomMessageHandler("semPlotLayout", function (layout_R) {
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

    // Create an object to hold the positions
    let preCalculatedPositions = {};

    layout_R.forEach((nodeInfo) => {
      const x = nodeInfo.x * xScale + 400;
      const y = nodeInfo.y * -1 * yScale + 400;
      preCalculatedPositions[nodeInfo.name] = { x, y };
    });
    // Configure the options
    let options = {
      name: "preset",
      positions: function (node) {
        const nodeName = node.data("label");
        return preCalculatedPositions[nodeName];
      },
      fit: true,
      padding: 60,
      animate: true,
    };
    // Run the layout
    if (undo) {
      const lur = get(ur);
      lur.do("layout", { options: options });
    } else {
      const cy = get(cyStore);
      cy.layout(options).run();
    }
  });
}
