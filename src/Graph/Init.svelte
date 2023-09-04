<script>
  import cytoscape from "cytoscape";
  import { graphSettings, ehSettings } from "./cytoscape_settings.js";
  import { cyStore, ehStore } from "../stores.js";
  import edgehandles from "cytoscape-edgehandles";

  cytoscape.use(edgehandles);

  var cy = cytoscape(graphSettings);

  cy.boxSelectionEnabled(true);

  cyStore.set(cy);
  ehStore.set(cy.edgehandles(ehSettings));
</script>
