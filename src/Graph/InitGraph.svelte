<script>
  import cytoscape from "cytoscape";
  import GraphStyles from "./GraphStyles.js";
  import { cyStore } from "../stores.js";
  var cy = cytoscape({
    autoungrabify: false,
    autolock: false,
    style: GraphStyles,
  });
  cyStore.set(cy);
  console.log("init");
</script>
