<script>
  import cytoscape from "cytoscape";
  import GraphStyles from "./GraphStyles.js";
  import { cyStore, ehStore } from "../stores.js";
  import edgehandles from "cytoscape-edgehandles";

  cytoscape.use(edgehandles);

  var cy = cytoscape({
    autoungrabify: false,
    autolock: false,
    style: GraphStyles,
  });

  cyStore.set(cy);
  ehStore.set(
    cy.edgehandles({
      preview: false, // disables the ghost edge preview
      hoverDelay: 150, // time spend over a target node before it's considered a hover
      handleNodes: "node", // selector/filter for whether edges can be made from a given node
      snap: true, // when enabled, the edge can be drawn by just moving close to a target node (can be confusing on compound graphs because you don't need to actually start on the node itself to start drawing)
      handleColor: "#ff0000", // bright red
      handleSize: 10, // increase the size
      canConnect: function (sourceNode, targetNode) {
        // Allow connection if it doesn't create a parallel edge
        return !cy.elements(
          'edge[source = "' +
            sourceNode.id() +
            '"][target = "' +
            targetNode.id() +
            '"]'
        ).length;
      },
    })
  );
</script>
