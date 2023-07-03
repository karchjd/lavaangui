var layout = cy.layout({ name: "grid" });

// Initialize edgehandles extension
var eh = cy.edgehandles({
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
});

var options = {
  // On/Off Modules
  /* From the following four snap options, at most one should be true at a given time */
  snapToGridOnRelease: false, // Snap to grid on release
  snapToGridDuringDrag: false, // Snap to grid during drag
  snapToAlignmentLocationOnRelease: false, // Snap to alignment location on release
  snapToAlignmentLocationDuringDrag: false, // Snap to alignment location during drag
  distributionGuidelines: true, // Distribution guidelines
  geometricGuideline: true, // Geometric guidelines
  initPosAlignment: false, // Guideline to initial mouse position
  centerToEdgeAlignment: false, // Center to edge alignment
  resize: false, // Adjust node sizes to cell sizes
  parentPadding: false, // Adjust parent sizes to cell sizes by padding
  drawGrid: false, // Draw grid background

  // Guidelines
  guidelinesStackOrder: 4, // z-index of guidelines
  guidelinesTolerance: 0.5, // Tolerance distance for rendered positions of nodes' interaction.
  guidelinesStyle: {
    // Set ctx properties of line. Properties are here:
    strokeStyle: "#8b7d6b", // color of geometric guidelines
    geometricGuidelineRange: 400, // range of geometric guidelines
    range: 100, // max range of distribution guidelines
    minDistRange: 10, // min range for distribution guidelines
    distGuidelineOffset: 10, // shift amount of distribution guidelines
    horizontalDistColor: "#ff0000", // color of horizontal distribution alignment
    verticalDistColor: "#00ff00", // color of vertical distribution alignment
    initPosAlignmentColor: "#0000ff", // color of alignment to initial mouse location
    lineDash: [0, 0], // line style of geometric guidelines
    horizontalDistLine: [0, 0], // line style of horizontal distribution guidelines
    verticalDistLine: [0, 0], // line style of vertical distribution guidelines
    initPosAlignmentLine: [0, 0], // line style of alignment to initial mouse position
  },

  // Parent Padding
  parentSpacing: -1, // -1 to set paddings of parents to gridSpacing
};

cy.gridGuide(options);

