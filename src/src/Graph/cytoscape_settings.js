import * as Constants from "./classNames.js";


export const graphStyles = [
  {
    selector: "node",
    style: {
      width: "80", // Set the width of the nodes to 80
      height: "80", // Set the height of the nodes to 80
      "background-color": "white",
      "border-color": "grey",
      "border-width": "2px", // Set border width of nodes to 2 pixels
      label: "data(label)", // Use the 'label' property from the data for the node's label
      "text-valign": "center",
      "text-halign": "center",
    },
  },
  {
    selector: `node.${Constants.OBSERVED}`,
    style: {
      shape: "rectangle",
    },
  },
  {
    selector: `node.${Constants.OBSERVED}.${Constants.ORDERED}`,
    style: {
      "border-style": "double",
      "border-width": 5
    },
  },
  {
    selector: `node.${Constants.LATENT}`,
    style: {
      shape: "ellipse",
      "border-color": "black",
    },
  },
  {
    selector: `node.${Constants.CONSTANT}`,
    style: {
      shape: "triangle",
      label: "1",
      "text-valign": "center",
      "text-margin-y": "10px",
      "border-color": "black",
    },
  },
  {
    selector: `node.${Constants.LINKED}`,
    style: {
      "border-color": "black",
    },
  },
  {
    selector: "edge",
    style: {
      width: 3,
      "line-color": "#000",
      "target-arrow-color": "#000",
      "source-arrow-color": "#000",
      "target-arrow-shape": "triangle",
      "curve-style": "bezier",
      "text-valign": "center",
      "text-halign": "center",
      "text-wrap": "wrap",
      "text-max-width": 80,
      "font-size": "14px",
      "z-index": 10,
      color: "#000",
      "text-outline-color": "#fff",
      "text-outline-width": "2px",
      "text-background-color": "#fff",
      "text-background-opacity": 1,
      "text-background-padding": "4px",
    },
  },
  {
    selector: "edge.loop",
    style: {
      "curve-style": "bezier",
      "loop-direction": 0, // -Math.PI / 2 in radians to position at top
      "loop-sweep": 0.8, // rounding of the loop, in radians
      "target-arrow-shape": "triangle",
      "source-arrow-shape": "triangle",
      "target-arrow-fill": "filled",
      "source-arrow-fill": "filled",
      "target-arrow-color": "#000",
      "source-arrow-color": "#000",
      "control-point-step-size": (edge) => {
        const sourceNode = edge.source();
        const height = parseInt(sourceNode.style('height'));
        const width = parseInt(sourceNode.style('width'));
        let maxVal;
        if (edge.style("loop-direction") == "0deg" || edge.style("loop-direction") == "180deg") {
          maxVal = height;
        } else if ((edge.style("loop-direction") == "90deg" || edge.style("loop-direction") == "270deg")) {
          maxVal = width;
        } else {
          maxVal = Math.max(width, height);
        }
        return maxVal / 80 * 60;
      },
    },
  },
  {
    selector: `edge.${Constants.UNDIRECTED}`,
    style: {
      "curve-style": "unbundled-bezier",
      "control-point-distances": [-100],
      "control-point-weights": [0.5],
      "target-arrow-shape": "triangle",
      "source-arrow-shape": "triangle",
    },
  },
  {
    selector: `edge.${Constants.UNDIRECTED}.${Constants.FROM_LAV}`,
    style: {
      "control-point-distances": [100],
    },
  },
  {
    selector: `edge.${Constants.LABEL}, edge.${Constants.LABEL}`,
    style: {
      label: function (edge) {
        return edge.data("label");
      },
    },
  },
  {
    selector: `edge.${Constants.FIXED}.${Constants.LABEL}`,
    style: {
      label: function (edge) {
        return edge.data("label") + "@" + edge.data("value");
      },
    },
  },
  {
    selector: `edge.${Constants.FIXED}.${Constants.NOT_LABEL}`,
    style: {
      label: function (edge) {
        return "@" + edge.data("value");
      },
    },
  },
  {
    selector: `edge.${Constants.FORCE_FREE}`,
    style: {
      "line-color": "blue",
    },
  },
  {
    selector: `edge.${Constants.FROM_LAV}, edge.${Constants.BY_LAV}`,
    style: {
      "line-style": "dashed",
    },
  },
  {
    selector: "edge:selected",
    style: {
      'underlay-opacity': 0.5,
      'underlay-color': "#928ff8",
    },
  },
  {
    selector: "node:selected",
    style: {
      'underlay-color': "#928ff8",
      'underlay-opacity': 0.5,
    },
  },
];

export const graphSettings = {
  autoungrabify: false,
  autolock: false,
  style: graphStyles,
  minZoom: 0.2,
  maxZoom: 5,
};

export const ehSettings = {
  preview: false, // disables the ghost edge preview
  hoverDelay: 150, // time spend over a target node before it's considered a hover
  handleNodes: "node", // selector/filter for whether edges can be made from a given node
  snap: true, // when enabled, the edge can be drawn by just moving close to a target node (can be confusing on compound graphs because you don't need to actually start on the node itself to start drawing)
  handleColor: "#ff0000", // bright red
  handleSize: 10, // increase the size
  canConnect: function (sourceNode, targetNode) {
    // Allow connection if it doesn't create a parallel edge
    return !cy.elements(
      'edge[source = "' +
      sourceNode.id() +
      '"][target = "' +
      targetNode.id() +
      '"]'
    ).length;
  },
};
