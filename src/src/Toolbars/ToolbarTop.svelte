<script>
  import { addNode } from "../Graph/graphmanipulation.js";
  import { appState } from "../stores";
  import DataInfo from "./DataInfo.svelte";
  import { OBSERVED, LATENT, CONSTANT } from "../Graph/classNames.js";
  let state = {};

  let unsubscribe = appState.subscribe((newState) => {
    state = newState;
  });

  function dragStart(variable) {
    $appState.dragged = variable;
  }

  function alertDrag() {
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
      bootbox.alert(
        "Connect two nodes with a directed edge by dragging from one to another while holding the CTRL or CMD key. The direction will be from the first node you click to the second.",
      );
    } else if (type === "undirected") {
      bootbox.alert(
        "Connect two nodes with a directed edge by dragging from one to another while holding the SHIFT key.",
      );
    } else {
      bootbox.alert("Error: Unknown edge type.");
    }
  }
</script>

<div class="toolbox">
  <div id="buttonCont">
    <div id="buttons">
      <button
        id="directed-arrow"
        class="arrow-btn"
        title="Directed Arrow"
        on:click={() => {
          alertEdge("directed");
        }}>➔</button
      >
      <button
        id="undirected-arrow"
        class="arrow-btn"
        title="Undirected Arrow"
        on:click={() => {
          alertEdge("undirected");
        }}>↔</button
      >
      <button
        id="add-manifest-variable"
        title="Create Observed Variable"
        draggable="true"
        class="variable-button"
        data-button-type={OBSERVED}
        on:dragstart={() => {
          dragStart(OBSERVED);
        }}
        on:click={() => {
          alertDrag();
        }}
      />
      <button
        id="add-latent-variable"
        title="Create Latent Variable"
        draggable="true"
        class="variable-button"
        data-button-type={LATENT}
        on:dragstart={() => {
          dragStart(LATENT);
        }}
        on:click={() => {
          alertDrag();
        }}
      />
      <button
        id="add-constant-variable"
        class="variable-button"
        title="Create Constant Variable"
        data-button-type="const"
        draggable="true"
        on:dragstart={() => {
          dragStart(CONSTANT);
        }}
        on:click={() => {
          alertDrag();
        }}
      />
    </div>
  </div>
  {#if $appState.dataAvail}
    <div class="vertical-bar"></div>
    <div>
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
      {#each $appState.columnNames as name}
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
    cursor: pointer;
    border: none;
    background: none;
    vertical-align: middle;
  }

  #directed-arrow {
    font-size: 20px;
  }

  #undirected-arrow {
    font-size: 20px;
  }

  #buttonCont button {
    height: 30px;
    width: 30px;
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

  button::before {
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

  #buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 0px; /* Adjust the gap as necessary */
  }

  /* #means {
    display: flex;
    justify-content: center;
    align-items: center;
  } */

  /*
  #means span {
    white-space: nowrap; 
    overflow: hidden; 
    text-overflow: ellipsis; 
    max-width: 100%; 
  }*/

  /* span {
    margin-left: 10px;
    margin-bottom: 0px;
    padding: 1px;
    background-color: white;
    border: solid 1px black;
    height: 20px;
  } */
</style>
