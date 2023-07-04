<script>
  import cytoscape from "cytoscape";
  import GraphStyles from "./GraphStyles.js";
  import { cyStore } from "../stores.js";
  import edgehandles from "cytoscape-edgehandles";
  cytoscape.use(edgehandles);
  var cy = cytoscape({
    autoungrabify: false,
    autolock: false,
    style: GraphStyles,
  });
  cyStore.set(cy);
</script>
