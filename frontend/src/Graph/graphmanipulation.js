import { cyStore, modelOptions, setAlert, ur } from "../stores.js";
import { get } from "svelte/store";
import { v4 as uuidv4 } from "uuid";
import { OBSERVED, LATENT, FROM_USER, FROM_LAV, FIXED, FREE, NOT_LABEL, CONTINOUS, DIRECTED, UNDIRECTED } from "./classNames.js";
import { tolavaan } from "../Shiny/toR.js";


let obCounter;
let latentCounter;

export function resetCounters() {
  obCounter = 1;
  latentCounter = 1;
}

resetCounters();

function isValidName(str) {
  const rVarNameRegex = /^[a-zA-Z\._][a-zA-Z0-9\._]*(?<!\.)$/;
  return rVarNameRegex.test(str);
}

function validLabel(str) {
  if (!isValidName(str)) {
    // @ts-expect-error
    bootbox.alert(`The variable <b>${str}</b> was not added to the model because <b>${str}</b> is not a valid lavaan variable name. Please use only letters, numbers, underscores, and dots. The name must start with a letter or underscore and cannot end with a dot. You can use the <b>Show Data</b> menu to rename <b>${str}</b>`);
    return false;
  }
  return true;
}


// Adding new nodes via mouse, toolbar, or hotkey
export function addNode(nodeType, position, fromUser = true, customLabel = null, checkLabel = false) {
  let cy = get(cyStore);
  let nodeId = uuidv4();
  let label;
  if (customLabel !== null) {
    if (!validLabel(customLabel)) {


      return;
    }
    if (cy.nodes().find(node => node.data().label === customLabel)) {
      setAlert('danger', "Node with the same label already exists.");
      return;
    }

    label = customLabel;
  } else {
    if (nodeType == OBSERVED) {
      label = "x" + obCounter++;
    } else if (nodeType == LATENT) {
      label = "f" + latentCounter++;
    } else {
      label = undefined;
    }
    if (cy.nodes().find(node => node.data().label === label)) {
      label = label + ".1";
    }
  }

  // Check if position is provided, if not, use random position
  let urLocal = get(ur);
  if (position) {
    urLocal.do("add", {
      group: "nodes",
      data: { id: nodeId, label: label },
      classes: [nodeType, CONTINOUS],
      renderedPosition: position,
    });
  } else {
    position = { x: Math.random() * 400 + 50, y: Math.random() * 400 + 50 };
    cy.add({
      group: "nodes",
      data: { id: nodeId, label: label },
      classes: [nodeType, CONTINOUS],
      renderedPosition: position,
    });
  }

  if (fromUser) {
    tolavaan(get(modelOptions).mode)
  }

  return nodeId;
}


export function addEdge(source, target, directed = true, fixed = false, fixedValue = null, fromUser = true) {
  let cy = get(cyStore);
  let edgeId = uuidv4();
  let edge = cy.add({
    group: "edges",
    data: {
      id: edgeId,
      source: source,
      target: target,
      value: fixed ? fixedValue : undefined // Added fixedValue as input
    },
    classes: `${directed ? DIRECTED : UNDIRECTED} ${fromUser ? FROM_USER : FROM_LAV} ${fixed ? FIXED : FREE} ${NOT_LABEL}`
  });
  return edge;
}


