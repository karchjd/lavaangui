<script>
  import { onMount } from "svelte";
  import { addNode } from "./graphmanipulation.js";
  import { cyStore, ehStore, appState} from "../stores.js";
  import { get } from "svelte/store";
  import { checkNodeLoop} from "./checkNodeLoop.js";


  let cy = get(cyStore);
  let eh = get(ehStore);
  let cyContainer;
  let m = { x: 0, y: 0 };

  let spaceKeyDown =false;


  onMount(() => {
    // Initialize the Cytoscape instance
    cy.mount(cyContainer);
  });

  function handleKeyDown(event) {
    if (event.key === "Meta" || event.key === "Control" || ' ') {
      eh.enableDrawMode();
    }

    if (event.key === ' ') {
      spaceKeyDown = true;
    }
    // Handle Backspace key
    if (event.key === "Backspace") {
      let selectedElements = cy.$(":selected");
      selectedElements.forEach(function (element) {
        if (element.isNode()) {
          element.remove();
        } else if (element.isEdge()) {
          element.remove();
        }
      });
    }

    // Handle 'l', 'o', 'c' keys
    if (["l", "o", "c"].includes(event.key.toLowerCase())) {
      let nodeType;
      switch (event.key.toLowerCase()) {
        case "l":
          nodeType = "latent-variable";
          break;
        case "o":
          nodeType = "observed-variable";
          break;
        case "c":
          nodeType = "constant";
          break;
      }
      addNode(nodeType, { ...m }); // Use the last known mouse position within Cytoscape container.
    }
  }

  function makeNodesGrabbable() {
    cy.autoungrabify(false);
    cy.nodes().grabify();
  }

  function handleKeyUp() {
    if (event.key === "Meta" || event.key === "Control" || ' ') {
      eh.disableDrawMode();
      makeNodesGrabbable();
    }
    if (event.key === ' ') {
    spaceKeyDown = false;
  }
  }

  function handleMouseOver() {
    document.addEventListener("keydown", handleKeyDown);
    document.addEventListener("keyup", handleKeyUp);
  }

  function handleMouseOut() {
    document.removeEventListener("keydown", handleKeyDown, false);
    document.removeEventListener("keyup", handleKeyUp, false);
  }

  function handleMousemove(event) {
    m.x = event.offsetX;
    m.y = event.offsetY;
  }

 
 cy.on('ehcomplete', (event, sourceNode, targetNode, addedEdge) => {
      const edge = addedEdge;
      const sourceNodeId = sourceNode.id();
      const targetNodeId = targetNode.id();
      edge.addClass("free");
      edge.addClass("nolabel");
      if (
        sourceNodeId !== targetNodeId &&
        isNode(sourceNodeId) &&
        isNode(targetNodeId)
      ) {
        if(spaceKeyDown){
          edge.addClass("undirected");
        }else{
          edge.addClass("directed");
        }
        checkNodeLoop(sourceNodeId);
        checkNodeLoop(targetNodeId);
      } else if (
        sourceNodeId === targetNodeId &&
        isNode(sourceNodeId) &&
        isNode(targetNodeId)
      ) {
        edge.addClass("loop");
      }
      //removers
      if (
        (edge.hasClass("undirected") || edge.hasClass("loop")) &&
        (sourceNode.hasClass("constant") ||
          edge.target().hasClass("constant"))
      ) {
        cy.remove(edge);
      }

      if (edge.hasClass("directed") && edge.target().hasClass("constant")) {
        cy.remove(edge);
      }

      if (edge.hasClass("directed") && targetNode.hasClass("constant")) {
        const t_node = edge.target();
        const conConstant = t_node.connectedEdges((edge) =>
        sourceNode.hasClass("constant")
        );
        if (conConstant.length > 1) {
          cy.remove(edge);
        }
      }

      if (edge.hasClass("directed") && sourceNode.hasClass("constant")) {
        edge.data("isMean", "1");
      } else {
        edge.data("isMean", "0");
      }
  });

  function isNode(str) {
  // Regular expression pattern to match strings of form "node" followed by one or more digits
  const pattern = /^node\d+$/;
  return pattern.test(str);
}


</script>

<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<div
  id="cy"
  class="graph"
  bind:this={cyContainer}
  on:mouseover={handleMouseOver}
  on:mouseout={handleMouseOut}
  on:mousemove={handleMousemove}
/>

<style>
  div {
    z-index: 1;
    width: 70%;
    height: 100%;
    padding: 0px;
    margin: 0px;
  }
</style>
