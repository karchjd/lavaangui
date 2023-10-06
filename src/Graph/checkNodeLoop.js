export function checkNodeLoop(nodeID) {
  const selfLoop = getSelfLoop(nodeID);
  if (selfLoop != null) {
    const edgePostions = getEdgePositions(nodeID);
    const angles = getOccupiedAngles(edgePostions);
    const freeDefault = defaultPositionsFree(angles);
    let goalAngle = getBestFreeAngle(angles);
    goalAngle = checkDefaultsFree(goalAngle, angles);
    selfLoop.style("loop-direction", `${goalAngle}deg`);
  }
}

function checkDefaultsFree(goalAngle, angles) {
  const defaultAngles = [0, 90, 180, 270];

  // Sort default angles by their shortest distance to goalAngle considering angle wrap-around
  const sortedDefaultAngles = defaultAngles.sort((a, b) => {
    const diffA = Math.min(
      Math.abs(a - goalAngle),
      360 - Math.abs(a - goalAngle)
    );
    const diffB = Math.min(
      Math.abs(b - goalAngle),
      360 - Math.abs(b - goalAngle)
    );
    return diffA - diffB;
  });

  // Check each default angle starting from the closest
  for (const defaultAngle of sortedDefaultAngles) {
    const isFree = !angles.some((angle) => {
      const diff = Math.abs(defaultAngle - angle);
      return Math.min(diff, 360 - diff) <= 45;
    });

    if (isFree) {
      return defaultAngle;
    }
  }

  return goalAngle;
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
  node.connectedEdges().forEach((edge) => {
    const source = edge.source();
    const target = edge.target();
    let toAdd;
    if (source.id() !== node.id() || target.id() !== node.id()) {
      if (source.id() === node.id()) {
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
  edgePostions.forEach((position) => {
    angles.push(getAngleFromPos(position));
  });
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
  if (
    loopEdge !== null &&
    node.connectedEdges().length > 1 &&
    !loopEdge.hasClass("fixDeg")
  ) {
    return loopEdge;
  } else {
    return null;
  }
}
