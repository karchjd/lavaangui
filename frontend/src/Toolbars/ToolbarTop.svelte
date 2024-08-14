<script>
  import { appState, cyStore, ehStore } from "../stores";
  import { OBSERVED, LATENT, CONSTANT } from "../Graph/classNames.js";
  import { get } from "svelte/store";

  let state = {};

  let unsubscribe = appState.subscribe((newState) => {
    state = newState;
  });

  function dragStart(variable) {
    $appState.dragged = variable;
  }

  function alertDrag() {
    // @ts-ignore
    bootbox.alert("Drag me on the model window to create a variable");
  }

  function handleDragStart(event, name) {
    $appState.dragged = "observed-with-name";
    $appState.draggedName = name;
  }

  function handleDragStartMultiple(event) {
    $appState.dragged = "multiple";
  }

  function handleDragStarFactor(event) {
    $appState.dragged = "factor";
  }

  function handleDragStarGrowth(event) {
    $appState.dragged = "growth";
  }

  function alertEdge(type) {
    if (type === "directed") {
      // @ts-ignore
      bootbox.alert(
        "Connect two nodes with a directed edge by dragging from one to another while holding the SPACE key or the X key.",
      );
    } else if (type === "undirected") {
      // @ts-ignore
      bootbox.alert(
        "Connect two nodes with an undirected edge by dragging from one to another while holding the ALT or OPTION key.",
      );
    } else {
      // @ts-ignore
      bootbox.alert("Error: Unknown edge type.");
    }
  }
  let varNames;

  let eh = get(ehStore);

  function toggleArrowState(direction) {
    if ($appState.drawing === direction) {
      eh.disableDrawMode();
      $appState.drawing = "none";
    } else {
      eh.enableDrawMode();
      $appState.drawing = direction;
    }
  }

  $: {
    if (
      typeof $cyStore.getObservedNodes === "function" &&
      $appState.columnNames !== null
    ) {
      const inModel = $cyStore.getObservedNodes().map((node) => {
        return node.data("label");
      });
      varNames = $appState.columnNames.filter((name) => {
        return !inModel.includes(name);
      });
    }
  }
</script>

<div class="toolbox">
  <div id="buttonCont">
    <div id="buttons">
      <button
        class="arrow-btn direct-arrow"
        title="Draw Directed Arrows"
        class:active={$appState.drawing === "directed"}
        on:click={() => {
          toggleArrowState("directed");
        }}
      ></button>
      <button
        class="arrow-btn undirected-arrow"
        title="Draw Undirected Arrows"
        class:active={$appState.drawing === "undirected"}
        on:click={() => {
          toggleArrowState("undirected");
        }}
      ></button>
      <div
        role="button"
        id="add-manifest-variable"
        title="Create Observed Variable"
        draggable="true"
        class="variable-button"
        data-button-type={OBSERVED}
        tabindex="0"
        on:dragstart={() => {
          event.dataTransfer.setData("text/plain", "node");
          dragStart(OBSERVED);
        }}
      />
      <div
        role="button"
        tabindex="0"
        id="add-latent-variable"
        title="Create Latent Variable"
        draggable="true"
        class="variable-button"
        data-button-type={LATENT}
        on:dragstart={() => {
          dragStart(LATENT);
        }}
      />
      <div
        role="button"
        tabindex="0"
        id="add-constant-variable"
        class="variable-button"
        title="Create Constant Variable"
        data-button-type="const"
        draggable="true"
        on:dragstart={() => {
          dragStart(CONSTANT);
        }}
      />
    </div>
  </div>
  {#if $appState.dataAvail}
    <div class="vertical-bar"></div>
    <div id="model-buttons">
      <button
        class="draggable-item"
        draggable="true"
        on:dragstart={(event) => handleDragStartMultiple(event)}
        >Multiple Variables
      </button>
      <button
        class="draggable-item"
        draggable="true"
        on:dragstart={(event) => handleDragStarFactor(event)}
        >Factor
      </button>
      <button
        class="draggable-item"
        draggable="true"
        on:dragstart={(event) => handleDragStarGrowth(event)}
        >Growth
      </button>
    </div>
    <div class="vertical-bar"></div>
    <ul class="draggable-list">
      {#each varNames as name}
        <li
          draggable="true"
          class="draggable-item"
          on:dragstart={(event) => handleDragStart(event, name)}
        >
          {name}
        </li>
      {/each}
    </ul>
  {/if}
</div>

<style>
  .toolbox {
    height: 60px;
    display: flex; /* Use flexbox for layout */
    align-items: center; /* Vertically align items in the middle */
    justify-content: space-between; /* Distribute space between the children */
    gap: 20px; /* Set a gap between the children for equal spacing */
    padding: 0 10px; /* Optional: Add some padding on the left and right sides */
    width: 100%; /* Ensure the toolbox takes full width */
  }

  /* #messages */
  #buttonCont,
  .draggable-list {
    display: flex;
    align-items: center; /* Align items in the center vertically */
  }

  #buttonCont {
    flex-grow: 0; /* Do not allow buttonCont to grow; it should only be as wide as it needs to be */
    flex-shrink: 0; /* Do not allow buttonCont to shrink */
  }

  .draggable-list {
    flex-grow: 1; /* Allow draggable-list to grow and take up remaining space */
    flex-shrink: 1; /* Allow it to shrink if necessary */
    overflow-x: auto; /* Show horizontal scrollbar if needed */
  }

  /* #messages { 
    flex-grow: 0; 
    flex-shrink: 0; 
  }

  #messages {
    display: flex;
    margin-right: 20px;
  }
  */
  .vertical-bar {
    height: 100%; /* Makes the bar stretch to fill the height of its container */
    width: 2px; /* Adjust the thickness of the vertical bar here */
    background-color: #000; /* Adjust the color of the vertical bar here */
    flex-shrink: 0; /* Prevents the bar from shrinking */
  }

  .arrow-btn {
    font-size: 20px; /* Adjust font size as needed */
    text-align: center; /* Ensure the arrow is centered horizontally */
    background: none;
    vertical-align: middle;
    border: 1px solid transparent;
  }

  .direct-arrow::after {
    content: "→";
  }
  .undirected-arrow::after {
    content: "↔";
  }

  .variable-button {
    margin: 0 5px;
    padding: 8px 16px;
    cursor: pointer;
    height: 30px;
    width: 30px;
    position: relative;
    border: none;
    background: none;
    cursor: grab;
  }

  .variable-button::before {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }

  #add-latent-variable::before {
    width: 20px;
    height: 20px;
    background-color: white;
    border: 2px solid black;
    border-radius: 50%;
  }

  #add-manifest-variable::before {
    width: 20px;
    height: 20px;
    background-color: white;
    border: 2px solid black;
  }

  #add-constant-variable::before {
    width: 0;
    height: 0;
    border-left: 12px solid transparent;
    border-right: 12px solid transparent;
    border-bottom: 21px solid black;
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }

  #add-constant-variable::after {
    content: "";
    position: absolute;
    width: 0;
    height: 0;
    border-left: 11.5px solid transparent; /* Approximately half of 23.09px */
    border-right: 11.5px solid transparent;
    border-bottom: 20px solid white; /* Same height as the manifest variable */
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }

  .draggable-list {
    display: flex;
    gap: 15px;
    list-style-type: none;
    padding: 0;
    margin: 0;
    overflow: hidden;
    overflow-x: auto;
    max-width: 0.5wv;
  }

  .draggable-item {
    padding: 3px 6px;
    background-color: white;
    border: 1px solid #000;
    cursor: grab;
    white-space: nowrap;
  }

  #buttonCont {
    display: flex;
    justify-content: space-around;
    align-items: center;
    flex-wrap: nowrap;
  }

  #model-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
  }

  #buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 0px; /* Adjust the gap as necessary */
  }

  .arrow-btn.active {
    background-color: #e0e0e0;
    border: 1px solid #888;
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.3);
    border-radius: 4px;
  }

  .arrow-btn:active {
    background-color: #d0d0d0;
    border-color: #777;
  }
</style>
