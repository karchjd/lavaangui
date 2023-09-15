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
    selector: "node.observed-variable",
    style: {
      shape: "rectangle",
    },
  },
  {
    selector: "node.latent-variable",
    style: {
      shape: "ellipse",
      "border-color": "black",
    },
  },
  {
    selector: "node.constant",
    style: {
      shape: "triangle",
      label: "1",
      "text-valign": "center",
      "text-margin-y": "10px",
      "border-color": "black",
    },
  },
  {
    selector: "node.linked",
    style: {
      "border-color": "black",
    },
  },
  {
    selector: "edge",
    style: {
      width: 3,
      "line-color": "#000",
      "target-arrow-color": "#000", // Set target arrow color to black
      "source-arrow-color": "#000", // Set target arrow color to black
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
      "edge-text-rotation": "autorotate",
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
      "control-point-step-size": 60,
    },
  },
  {
    selector: "edge.undirected",
    style: {
      "curve-style": "unbundled-bezier",
      "control-point-distances": [-100],
      "control-point-weights": [0.5],
      "target-arrow-shape": "triangle",
      "source-arrow-shape": "triangle",
    },
  },
  {
    selector: "edge.undirected.fromLav",
    style: {
      "control-point-distances": [100],
    },
  },
  {
    selector: "edge.label, edge.label",
    style: {
      label: function (edge) {
        return edge.data("label");
      },
    },
  },
  {
    selector: "edge.fixed.label",
    style: {
      label: function (edge) {
        return edge.data("label") + "@" + edge.data("value");
      },
    },
  },
  {
    selector: "edge.fixed.nolabel",
    style: {
      label: function (edge) {
        return "@" + edge.data("value");
      },
    },
  },
  {
    selector: "edge.hasEst",
    style: {
      label: function (edge) {
        return edge.data("est");
      },
    },
  },
  {
    selector: "edge.hasEst.label",
    style: {
      label: function (edge) {
        return edge.data("label") + "=" + edge.data("est");
      },
    },
  },
  {
    selector: "edge.forcefree",
    style: {
      "line-color": "blue",
    },
  },
  {
    selector: "edge.fromLav, edge.byLav",
    style: {
      "line-style": "dashed",
    },
  },
  {
    selector: "edge:selected",
    style: {
      "line-color": "red",
      "target-arrow-color": "red",
      "source-arrow-color": "red",
    },
  },
  {
    selector: "node:selected",
    style: {
      "border-color": "red",
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
