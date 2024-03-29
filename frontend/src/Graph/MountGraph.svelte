<script>
  import { onMount } from "svelte";
  import { addNode, addEdge } from "./graphmanipulation.js";
  import {
    cyStore,
    ehStore,
    appState,
    modelOptions,
    setAlert,
    ur,
  } from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop } from "./checkNodeLoop.js";
  import { OBSERVED, LATENT, CONSTANT, NODEWITH } from "./classNames.js";
  import { tolavaan } from "../Shiny/toR.js";

  let cy = get(cyStore);
  let eh = get(ehStore);
  let cyContainer;
  let m = { x: 0, y: 0 };

  let undirected;

  onMount(() => {
    // Initialize the Cytoscape instance
    cy.mount(cyContainer);
  });

  function handleKeyDown(event) {
    $appState.buttonDown = true;
    if (event.key === "Alt" || event.key === " ") {
      eh.enableDrawMode();
      undirected = false;
      $appState.drawing = true;
      if (event.key === "Alt") {
        undirected = true;
      }
    }

    // Handle Backspace key
    if (event.key === "Backspace") {
      let selectedElements = cy.$(":selected");
      if (selectedElements.length > 0) {
        $ur.do("remove", selectedElements);
      }
      $appState.buttonDown = false;
    }

    // Handle 'l', 'o', 'c' keys
    if (["l", "o", "c"].includes(event.key.toLowerCase())) {
      let nodeType;
      switch (event.key.toLowerCase()) {
        case "l":
          nodeType = LATENT;
          break;
        case "o":
          nodeType = OBSERVED;
          break;
        case "c":
          nodeType = CONSTANT;
          break;
      }
      addNode(nodeType, { ...m }); // Use the last known mouse position within Cytoscape container.
      $appState.buttonDown = false;
    }
    $appState.buttonDown = false;
  }

  function makeNodesGrabbable() {
    cy.autoungrabify(false);
    cy.nodes().grabify();
  }

  function handleKeyUp() {
    if (event.key === "Alt" || event.key === " ") {
      eh.disableDrawMode();
      $appState.drawing = false;
      makeNodesGrabbable();
    }
  }

  function handleMouseOver() {
    document.addEventListener("keydown", handleKeyDown);
    document.addEventListener("keyup", handleKeyUp);
  }

  function handleMouseOut() {
    document.removeEventListener("keydown", handleKeyDown, false);
    document.removeEventListener("keyup", handleKeyUp, false);
    eh.disableDrawMode();
  }

  function handleMousemove(event) {
    m.x = event.offsetX;
    m.y = event.offsetY;
  }

  cy.on("ehcomplete", (event, sourceNode, targetNode, addedEdge) => {
    const edge = addedEdge;
    const sourceNodeId = sourceNode.id();
    const targetNodeId = targetNode.id();
    edge.remove();
    edge.init();
    if (sourceNodeId !== targetNodeId) {
      if (undirected) {
        edge.setUndirected();
      } else {
        edge.setDirected();
      }
      checkNodeLoop(sourceNodeId);
      checkNodeLoop(targetNodeId);
    } else {
      edge.makeLoop();
      checkNodeLoop(targetNodeId);
    }
    //removers
    if (
      (edge.isUndirected() || edge.myIsLoop()) &&
      (sourceNode.isConstant() || targetNode.isConstant())
    ) {
      return;
    }

    if (edge.isDirected() && targetNode.isConstant()) {
      return;
    }

    if (edge.isDirected() && sourceNode.isConstant()) {
      const conConstant = targetNode.connectedEdges(
        (edge_local) =>
          edge_local.isUserAdded() && edge_local.source().isConstant(),
      );
      if (conConstant.length > 1) {
        return;
      }
    }

    if (edge.isDirected() && sourceNode.isConstant()) {
      edge.makeMeanEdge();
    } else {
      edge.makeOtherEdge();
    }
    $ur.do("add", edge);
  });

  function handleDragOver(event) {
    event.preventDefault();
  }

  function handleCreateNode(event) {
    let offset = 0;
    const gap = 100;
    const ygap = gap * 2;
    event.preventDefault();
    let pos = { x: event.offsetX, y: event.offsetY };

    function createBootPrompt(title, callback) {
      let inputOptions;
      if ($appState.dataAvail) {
        inputOptions = $appState.columnNames.map((item) => {
          return { text: item, value: item };
        });
      } else {
        inputOptions = Array.from({ length: 100 }, (_, i) => `var${i + 1}`);
      }
      const promptSettings = {
        title: title,
        inputType: "select",
        multiple: true,
        value: "",
        inputOptions: inputOptions,
        callback: callback, // Include the callback function here
      };
      // @ts-ignore
      bootbox.prompt(promptSettings);
    }

    function showError() {
      setAlert(
        "danger",
        "Either no variable selected or at least one selected variable already is in the model.",
      );
    }

    function checkValid(result) {
      return result && !cy.nodes().some((node) => node.data().label === result);
    }

    if ($appState.dragged == "observed-with-name") {
      addNode(OBSERVED, pos, true, $appState.draggedName);
    } else if ($appState.dragged == "multiple") {
      createBootPrompt("Select Variables", function (result) {
        if (checkValid(result)) {
          const zoom = cy.zoom();
          result.forEach((name) => {
            addNode(
              OBSERVED,
              { x: pos.x + offset * zoom, y: pos.y },
              true,
              name,
            );
            offset += gap; // Update offset for next node
          });
        } else {
          showError();
        }
      });
    } else if ($appState.dragged == "factor") {
      // @ts-ignore
      createBootPrompt("Select Variables", function (result) {
        if (checkValid(result)) {
          const zoom = cy.zoom();
          const latentID = addNode(LATENT, {
            x: pos.x + (gap * zoom * result.length) / 2 - (NODEWITH / 2) * zoom,
            y: pos.y,
          });
          result.forEach((name) => {
            const itemItem = addNode(
              OBSERVED,
              { x: pos.x + offset * zoom, y: pos.y + zoom * ygap },
              true,
              name,
            );
            offset += gap;
            addEdge(latentID, itemItem);
          });
          $modelOptions.fix_first = true;
          $modelOptions.fix_single = true;
          $modelOptions.auto_var = true;
          $modelOptions.intOvFree = true;
          $modelOptions.intLvFree = false;
        } else {
          showError();
        }
      });
    } else if ($appState.dragged == "growth") {
      let offset = 0;
      createBootPrompt("Select Time Points", function (result) {
        if (checkValid(result)) {
          const zoom = cy.zoom();
          const constantID = addNode(
            CONSTANT,
            {
              x:
                pos.x +
                (gap * zoom * result.length) / 2 -
                (NODEWITH / 2) * zoom,
              y: pos.y,
            },
            true,
          );
          const interceptID = addNode(
            LATENT,
            {
              x: pos.x + (NODEWITH / 2) * zoom,
              y: pos.y + 1 * ygap * zoom,
            },
            true,
            "Intercept",
          );
          const slopeID = addNode(
            LATENT,
            {
              x:
                pos.x +
                gap * zoom * (result.length - 1) -
                (NODEWITH / 2) * zoom,
              y: pos.y + 1 * ygap * zoom,
            },
            true,
            "Slope",
          );
          addEdge(constantID, interceptID, true, false);
          addEdge(constantID, slopeID, true, false);
          let counter = 1;
          result.forEach((name) => {
            const itemItem = addNode(
              OBSERVED,
              { x: pos.x + offset * zoom, y: pos.y + 2 * ygap * zoom },
              true,
              name,
            );
            offset += gap;
            addEdge(interceptID, itemItem, true, true, 1);
            if (counter != 1) {
              addEdge(slopeID, itemItem, true, true, counter - 1);
            }
            counter += 1;
          });
          $modelOptions.auto_var = true;
          $modelOptions.intOvFree = false;
          $modelOptions.intLvFree = true;
        }
      });
    } else {
      addNode($appState.dragged, pos);
    }
    if (
      $appState.dragged == "multiple" ||
      $appState.dragged == "factor" ||
      $appState.dragged == "growth"
    ) {
      tolavaan($modelOptions.mode);
    }
  }

  let isMouseDown = false;
  let currentEdge = null;

  cy.on("mousedown", "edge.loop", function (event) {
    isMouseDown = true;
    currentEdge = event.target;
    currentEdge.unpanify();
    currentEdge.addClass("fixDeg");
  });

  function vectorAngleDegrees(x, y) {
    let angle = Math.atan2(x, -y) * (180 / Math.PI);
    if (angle < 0) angle += 360;
    return angle;
  }

  cy.on("mousemove", function (event) {
    if (!isMouseDown || !currentEdge) return;

    let sourceNode = currentEdge.source();
    let nodePosition = sourceNode.renderedPosition();
    let angle = vectorAngleDegrees(m.x - nodePosition.x, m.y - nodePosition.y);

    const tolerance = 5;
    const targetAngles = [0, 90, 180, 270];
    for (let i = 0; i < targetAngles.length; i++) {
      if (Math.abs(angle - targetAngles[i]) <= tolerance) {
        angle = targetAngles[i];
        break;
      }
    }
    $ur.do("style", {
      eles: currentEdge,
      style: { "loop-direction": `${angle}deg` },
    });
  });

  window.addEventListener("mouseup", function () {
    if (isMouseDown) {
      isMouseDown = false;
      currentEdge = null;
    }
  });
</script>

<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<div
  id="cy"
  class="graph"
  style="flex-basis: {$appState.full ? '70%' : '100%'};"
  bind:this={cyContainer}
  on:mouseover={handleMouseOver}
  on:mouseout={handleMouseOut}
  on:mousemove={handleMousemove}
  on:drop={handleCreateNode}
  on:dragover={handleDragOver}
/>

<style>
  div {
    z-index: 1;
    display: flex;
    flex-basis: 70%;
    padding: 0px;
    min-width: 0;
    min-height: 0;
  }
</style>
