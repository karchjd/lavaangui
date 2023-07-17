<script>
  import { createSyntax } from "../Shiny/RModelInterface";
  import { appState } from "../stores";
  function tolavaan(run) {
    if (run) {
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
      const edges = cy.edges();
      for (var i = 0; i < edges.length; i++) {
        edges[i].removeData("est");
        edges[i].removeClass("hasEst");
      }
    }
    let R_script = createSyntax(run);
    Shiny.setInputValue("run", run);
    Shiny.setInputValue("R_script", R_script);
    $appState.runCounter = $appState.runCounter + 1;
    Shiny.setInputValue("runCounter", $appState.runCounter);
  }
</script>
<div class="toolbox navbar-fixed-bottom">
  <div class="btn-group" role="group">
    <button
      type="button"
      class="btn btn-default"
      on:click={() => {
        tolavaan(false);
      }}
    >
      Create Script
    </button>
    <button
      type="button"
      class="btn btn-default"
      on:click={() => {
        tolavaan(true);
      }}
    >
      Run lavaan
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
