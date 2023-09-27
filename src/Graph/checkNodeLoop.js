export function checkNodeLoop(nodeID) {
  const selfLoop = getSelfLoop(nodeID);
  if (selfLoop != null) {
    const edgePostions = getEdgePositions(nodeID);
    const angles = getOccupiedAngles(edgePostions);
    const freeDefault = defaultPositionsFree(angles);
    let goalAngle;
    if (freeDefault.length > 1) {
      if (freeDefault.includes("top")) {
        goalAngle = 0;
      } else if (freeDefault.includes("bottom")) {
        goalAngle = 180;
      } else if (freeDefault.includes("right")) {
        goalAngle = 90;
      } else if (freeDefault.includes("left")) {
        goalAngle = 270;
      }
    } else {
      goalAngle = getBestFreeAngle(angles);
    }

    selfLoop.style("loop-direction", `${goalAngle}deg`);
  }
}

function defaultPositionsFree(angles) {
  const intervals = {
    top: [315, 45],
    right: [45, 135],
    bottom: [135, 225],
    left: [225, 315],
  };

  let freeIntervals = [];

  for (let key in intervals) {
    const [start, end] = intervals[key];
    let isFree = true;

    for (const angle of angles) {
      const normalizedAngle = ((angle % 360) + 360) % 360;
      if (start <= end) {
        if (normalizedAngle >= start && normalizedAngle <= end) {
          isFree = false;
          break;
        }
      } else {
        if (normalizedAngle >= start || normalizedAngle <= end) {
          isFree = false;
          break;
        }
      }
    }

    if (isFree) {
      freeIntervals.push(key);
    }
  }

  return freeIntervals;
}

function getEdgePositions(nodeID) {
  const node = cy.getElementById(nodeID);
  if (node.length === 0) {
    console.error(`Node with ID ${nodeID} does not exist.`);
    return;
  }
  let edgePostions = [];
  debugger;
  node.connectedEdges().forEach((edge) => {
    const source = edge.source();
    const target = edge.target();
    let toAdd;
    if (source.id() !== node.id() || target.id() !== node.id()) {
      if (source.id() === node.id()) {
        console.log("sourceEndpointAdded");
        toAdd = elementWiseSubtract(edge.sourceEndpoint(), node.position());
      } else {
        toAdd = elementWiseSubtract(edge.targetEndpoint(), node.position());
      }
      edgePostions.push(toAdd);
    }
  });
  return edgePostions;
}

function elementWiseSubtract(obj1, obj2) {
  return Object.keys(obj1).reduce((acc, key) => {
    if (obj2.hasOwnProperty(key)) {
      acc[key] = obj1[key] - obj2[key];
    } else {
      throw new Error(`Key ${key} not found in second object`);
    }
    return acc;
  }, {});
}

function getOccupiedAngles(edgePostions) {
  let angles = [];
  debugger;
  edgePostions.forEach((position) => {
    angles.push(getAngleFromPos(position));
  });
  console.log(angles);
  return angles;
}

function getAngleFromPos(position) {
  let angle = (Math.atan2(position.y, position.x) * 180) / Math.PI;
  angle = (angle + 90) % 360;
  return angle;
}

function getBestFreeAngle(angles) {
  let maxDistance = -1;
  let furthestDegree = null;

  for (let i = 0; i <= 360; i++) {
    let minDistance = Infinity;

    for (let j = 0; j < angles.length; j++) {
      let d = Math.abs(angles[j] - i);
      // Adjust distance considering that 0 and 360 are the same
      d = Math.min(d, 360 - d);

      minDistance = Math.min(minDistance, d);
    }

    if (minDistance > maxDistance) {
      maxDistance = minDistance;
      furthestDegree = i;
    }
  }
  return furthestDegree;
}

function moveEdge(edge, angle) {}

function countEdgesConnectedToNodeSides(nodeId) {
  const node = cy.getElementById(nodeId);
  if (node.length === 0) {
    console.error(`Node with ID ${nodeId} does not exist.`);
    return;
  }

  let topCount = 0;
  let bottomCount = 0;

  const nodePosition = node.position();
  const nodeHeight = node.height();

  if (topCount > 0 && bottomCount === 0) {
    return "bottom";
  }
  if (topCount === 0 && bottomCount > 0) {
    return "top";
  }
  return "keep";
}

// Rest of the functions remain unchanged

function getSelfLoop(nodeId, angle) {
  var node = cy.getElementById(nodeId);
  var loopEdge = null;

  node.connectedEdges().forEach(function (edge) {
    var source = edge.source();
    var target = edge.target();

    if (source.id() === nodeId && target.id() === nodeId) {
      loopEdge = edge; // Found a loop connected to the node itself
      return;
    }
  });
  return loopEdge;
}
