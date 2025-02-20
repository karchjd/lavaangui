<script>
  import { cyStore, appState, setAlert, modelOptions } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "./checkNodeLoop.js";
  import { tolavaan } from "../Shiny/toR.js";
  let cy = get(cyStore);

  function getEdgeVector(edge) {
    const edgeSourcePos = edge.source().position();
    const edgeTargetPos = edge.target().position();

    const edgeVector = {
      x: edgeTargetPos.x - edgeSourcePos.x,
      y: edgeTargetPos.y - edgeSourcePos.y,
    };
    const edgeVectorMagnitude = Math.sqrt(
      edgeVector.x ** 2 + edgeVector.y ** 2,
    );

    return {
      normalizedEdgeVector: {
        x: edgeVector.x / edgeVectorMagnitude,
        y: edgeVector.y / edgeVectorMagnitude,
      },
      edgeMidpoint: edge.midpoint(),
      edgeSourcePos,
      edgeTargetPos,
    };
  }

  function calculateDisplacement(edge, displacement) {
    const { normalizedEdgeVector, edgeMidpoint, edgeSourcePos, edgeTargetPos } =
      getEdgeVector(edge);

    const TargetMax =
      (edgeTargetPos.y - edgeMidpoint.y) / normalizedEdgeVector.y - 70;
    const SourceMin =
      (edgeSourcePos.y - edgeMidpoint.y) / normalizedEdgeVector.y + 70;

    let displacementAlongEdgeCut = Math.min(TargetMax, displacement);
    displacementAlongEdgeCut = Math.max(SourceMin, displacementAlongEdgeCut);

    return {
      newMarginX: displacementAlongEdgeCut * normalizedEdgeVector.x,
      newMarginY: displacementAlongEdgeCut * normalizedEdgeVector.y,
    };
  }

  function updateEdgeStyle(edge, displacement) {
    const { newMarginX, newMarginY } = calculateDisplacement(
      edge,
      displacement,
    );
    edge.style({
      "text-margin-x": newMarginX,
      "text-margin-y": newMarginY,
    });
  }

  cy.on("add", "node", function (event) {
    const node = event.target;
    if (node.isObserved()) {
      let columnNames = $appState.columnNames;
      if (columnNames && columnNames.includes(node.getLabel())) {
        node.link();
        setAlert("success", `Variable ${node.getLabel()} linked to data`);
      }
    }
    if ($appState.modelEmpty && cy.edges().length > 0) {
      $appState.modelEmpty = false;
    }
  });

  cy.on("remove", "node", function (event) {
    if (cy.getUserEdges().length == 0) {
      $appState.modelEmpty = true;
      Shiny.setInputValue("show_help", Math.random());
    }
    if (!$appState.loadingMode) {
      tolavaan($modelOptions.mode);
    }
  });

  cy.on("remove", "edge", function (event) {
    checkNodeLoop(event.target.source().id());
    checkNodeLoop(event.target.target().id());
  });

  cy.on("add", "edge", function (event) {
    $appState.everEdge = true;
    if ($appState.modelEmpty && cy.edges().length > 0) {
      $appState.modelEmpty = false;
    }
    checkNodeLoop(event.target.source().id());
    checkNodeLoop(event.target.target().id());
  });

  cy.on("position", "node", function (event) {
    const node = event.target;
    const connectedNodes = node.neighborhood().nodes();
    const connectedEdges = node.connectedEdges((edge) => edge.isDirected());

    connectedNodes.forEach((connectedNode) => {
      checkNodeLoop(connectedNode.id());
    });

    connectedEdges.forEach((connectedEdge) => {
      const displacement = connectedEdge.data("displacement");
      updateEdgeStyle(connectedEdge, displacement);
    });
  });

  let selectedEdge = null;
  let isDraggingLabel = false;

  cy.on("mousedown", function (evt) {
    const convertPxToNumber = (str) => parseFloat(str.replace("px", ""));
    const mousePosition = evt.position;
    let nearestEdge = null;
    let minDistance = Infinity;
    const clickThreshold = 30; // Adjust based on your needs
    cy.edges().forEach(function (edge) {
      if (edge.isDirected()) {
        const labelOffsetX = convertPxToNumber(edge.style("text-margin-x"));
        const labelOffsetY = convertPxToNumber(edge.style("text-margin-y"));

        // Calculate the adjusted label position
        const edgeMidpoint = edge.midpoint();
        const labelPosition = {
          x: edgeMidpoint.x + labelOffsetX,
          y: edgeMidpoint.y + labelOffsetY,
        };

        const dx = Math.abs(mousePosition.x - labelPosition.x);
        const dy = mousePosition.y - labelPosition.y;
        const distance = Math.sqrt(dx * dx + dy * dy);
        // Check if this is the nearest label so far
        if (distance < minDistance && distance < clickThreshold) {
          nearestEdge = edge;
          minDistance = distance;
        }
      }
    });

    // If a nearest edge label was found within threshold, set it as selected for dragging
    if (nearestEdge !== null) {
      selectedEdge = nearestEdge;
      isDraggingLabel = true;
      // Prevent the event from being handled further
      evt.preventDefault();
      nearestEdge.unpanify();
    }
  });

  cy.on("mousemove", function (evt) {
    if (isDraggingLabel && selectedEdge) {
      const { normalizedEdgeVector, edgeMidpoint } =
        getEdgeVector(selectedEdge);
      const mousePosition = evt.position;

      // Calculate vector from the midpoint to the mouse position
      const midpointToMouseVector = {
        x: mousePosition.x - edgeMidpoint.x,
        y: mousePosition.y - edgeMidpoint.y,
      };

      // Project onto the normalized edge vector
      let displacementAlongEdge =
        midpointToMouseVector.x * normalizedEdgeVector.x +
        midpointToMouseVector.y * normalizedEdgeVector.y;

      selectedEdge.data("displacement", displacementAlongEdge);
      updateEdgeStyle(selectedEdge, displacementAlongEdge);
    }
  });

  cy.on("mouseup", function (evt) {
    isDraggingLabel = false;
    selectedEdge = null;
  });
</script>
