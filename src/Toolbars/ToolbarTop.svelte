<script>
  import { addNode } from "../Graph/graphmanipulation.js";
  import { appState } from "../stores";
  import DataInfo from "./DataInfo.svelte";
  let state = {};

  let unsubscribe = appState.subscribe((newState) => {
    state = newState;
  });
</script>

<div class="toolbox">
  <DataInfo />
  <div id="buttons">
    <button
      id="add-manifest-variable"
      title="Create Observed Variable"
      on:click={() => {
        addNode("observed-variable");
      }}
    />
    <button
      id="add-latent-variable"
      title="Create Latent Variable"
      on:click={() => {
        addNode("latent-variable");
      }}
    />
    <button
      id="add-constant-variable"
      title="Create Constant Variable"
      on:click={() => {
        addNode("constant");
      }}
    />
  </div>
</div>

<style>
  .toolbox {
    height: 30px;
    justify-content: space-between;
    align-items: center;
  }

  #buttons {
    margin: 0 auto;
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
</style>
