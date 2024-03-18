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
</script>

<div class="toolbox">
  <div id="buttonCont">
    <div id="buttons">
      <button
        id="add-manifest-variable"
        title="Create Observed Variable"
        draggable="true"
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
  <div id="messages">
    {#if $appState.parsedModel}
      <div id="means">
        {#if $appState.meansModelled}
          <span>Means are Modelled</span>
        {:else}
          <span>Means are NOT Modelled</span>
        {/if}
      </div>
    {/if}
  </div>
</div>

<style>
  .toolbox {
    height: 60px;
    justify-content: space-between;
    align-items: left;
  }

  #messages {
    display: flex;
    margin-right: 20px;
  }

  button {
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

  span {
    margin-left: 10px;
    margin-bottom: 0px;
    padding: 1px;
    background-color: white;
    border: solid 1px black;
    height: 20px;
  }

  #buttons {
    margin-left: 300px;
  }

  .draggable-list {
    display: flex;
    gap: 10px;
    list-style-type: none;
    padding: 0;
    margin: 0;
    overflow: hidden;
    overflow-x: scroll;
    width: 60%;
  }
  .draggable-item {
    padding: 2px 5px;
    background-color: #f0f0f0;
    border: 1px solid #ddd;
    cursor: grab;
  }
</style>
