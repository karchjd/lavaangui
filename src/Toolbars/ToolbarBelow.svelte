<script>
  import { appState, modelOptions } from "../stores";
  import { createSyntax } from "../Shiny/toR";

  function serverAvail() {
    return typeof Shiny === "object" && Shiny !== null;
  }

  function tolavaan(mode) {
    if (mode == "estimate") {
      const nodes = cy.nodes(function (node) {
        return node.hasClass("observed-variable");
      });
      for (var i = 0; i < nodes.length; i++) {
        const node = nodes[i];
        if (!node.hasClass("linked")) {
          bootbox.alert(
            "Observed variable " +
              node.data("label") +
              " is not linked to data. Cannot run."
          );
          return;
        }
      }
    }

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
      for_R.mode = mode;
      Shiny.setInputValue("fromJavascript", JSON.stringify(for_R));
      $appState.runCounter = $appState.runCounter + 1;
      Shiny.setInputValue("runCounter", $appState.runCounter);
    } else if (mode == "user model") {
      $modelOptions.showLav = false;
      document.getElementById("lavaan_syntax_R").innerText = for_R;
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
      disabled={$appState.modelEmpty}
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
