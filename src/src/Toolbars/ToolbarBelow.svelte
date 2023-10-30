<script>
  import { appState, cyStore, modelOptions } from "../stores";
  import { createSyntax } from "../Shiny/toR";
  import { get } from "svelte/store";

  function serverAvail() {
    // @ts-expect-error
    return typeof Shiny === "object" && Shiny !== null;
  }

  function tolavaan(mode) {
    let cy = get(cyStore);
    const edges = cy.edges();

    for (var i = 0; i < edges.length; i++) {
      edges[i].removeData("est");
      edges[i].removeClass("hasEst");
    }
    const tolavaan = mode !== "user model";
    let for_R = createSyntax(tolavaan);
    $appState.result = "script";
    if (mode != "user model" && serverAvail()) {
      $modelOptions.showLav = true;
      // @ts-expect-error
      for_R.mode = mode;
      // @ts-expect-error
      Shiny.setInputValue("fromJavascript", JSON.stringify(for_R));
      // @ts-expect-error
      Shiny.setInputValue("runCounter", Math.random());
    } else if (mode == "user model") {
      $modelOptions.showLav = false;
      if (!serverAvail()) {
        // @ts-expect-error
        document.getElementById("lavaan_syntax_R").innerText = for_R;
      } else {
        const for_R_con = { mode: mode, syntax: for_R };
        // @ts-expect-error
        Shiny.setInputValue("fromJavascript", JSON.stringify(for_R_con));
        // @ts-expect-error
        Shiny.setInputValue("runCounter", Math.random());
      }
      cy.edges(".byLav").forEach((existingEdge) => {
        existingEdge.removeClass("fixed");
        existingEdge.addClass("free");
        existingEdge.removeData("value");
        existingEdge.removeClass("byLav");
      });
    }
  }
</script>

<div class="toolbox navbar-static-bottom">
  <div class="btn-group" role="group">
    <button
      type="button"
      class="btn btn-default"
      on:click={() => {
        tolavaan("user model");
      }}
      disabled={$appState.modelEmpty}
    >
      Show User Model / Script
    </button>
    <button
      type="button"
      class="btn btn-default"
      on:click={() => {
        tolavaan("full model");
      }}
      disabled={$appState.modelEmpty}
    >
      Show Full Model
    </button>
    <button
      type="button"
      class="btn btn-default"
      on:click={() => {
        tolavaan("estimate");
      }}
      disabled={$appState.modelEmpty || !$appState.dataAvail}
    >
      Fit Model
    </button>
  </div>
</div>

<style>
  div {
    height: 50px;
    padding: 0px;
  }

  .btn-group {
    display: flex;
    align-items: center;
    justify-content: center;
  }
</style>
