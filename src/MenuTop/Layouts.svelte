<script>
  import dagre from "cytoscape-dagre";
  import cytoscape from "cytoscape";
  import { onMount } from "svelte";
  import fcose from "cytoscape-fcose";
  import { cyStore, appState, ur } from "../stores.js";
  import { get } from "svelte/store";
  import DropDownLinks from "./helpers/DropDownLinks.svelte";
  import { createSyntax } from "../Shiny/toR";
  import cola from "cytoscape-cola";

  let cy = get(cyStore);
  let counter = 0;

  function serverAvail() {
    return typeof Shiny === "object" && Shiny !== null;
  }

  onMount(() => {
    // Initialize the Cytoscape instance
    cytoscape.use(dagre);
    cytoscape.use(fcose);
    cytoscape.use(cola);
  });

  function objectOfArraysToArrayOfObjects(obj) {
    const keys = Object.keys(obj);
    const length = obj[keys[0]].length;
    const result = [];

    for (let i = 0; i < length; i++) {
      const newObj = {};
      for (const key of keys) {
        newObj[key] = obj[key][i];
      }
      result.push(newObj);
    }

    return result;
  }

  function applySemLayout(name) {
    counter = counter + 1;
    let for_R = createSyntax(true);
    for_R.name = name;
    for_R.counter = counter;
    if (serverAvail()) Shiny.setInputValue("layout", JSON.stringify(for_R));
  }

  if (serverAvail()) {
    Shiny.addCustomMessageHandler("semPlotLayout", function (layout_R) {
      layout_R = objectOfArraysToArrayOfObjects(layout_R);
      // Determine scale and translation factors
      const differenceX = 125;
      const differenceY = 300;
      let minDiffX = Infinity;
      let minDiffY = Infinity;

      for (let i = 0; i < layout_R.length; i++) {
        for (let j = i + 1; j < layout_R.length; j++) {
          const diffX = Math.abs(layout_R[i].x - layout_R[j].x);
          const diffY = Math.abs(layout_R[i].y - layout_R[j].y);

          if (diffX < minDiffX && layout_R[i].y === layout_R[j].y)
            minDiffX = diffX;
          if (diffY < minDiffY && layout_R[i].x === layout_R[j].x)
            minDiffY = diffY;
        }
      }
      const xScale = differenceX / minDiffX;
      const yScale = differenceY / minDiffY;

      let options = {
        name: "preset",
        positions: function (node) {
          // find the node in your predefined nodes array
          const nodeName = node.data("label");
          const nodeInfo = layout_R.find((n) => n.name === nodeName);

          if (nodeInfo) {
            return {
              x: nodeInfo.x * xScale + 400,
              y: nodeInfo.y * -1 * yScale + 400,
            };
          }
          return undefined; // return undefined if not found in your predefined array
        },
        fit: true,
        padding: 60,
        animate: true,
      };

      // Run the layout
      $ur.do("layout", { options: options });
    });
  }

  function applyDagre() {
    const options = { name: "dagre", rankSep: 150, animate: true };
    $ur.do("layout", { options: options });
  }

  function applyBF() {
    const options = { name: "breadthfirst", animate: true, spacingFactor: 1 };
    $ur.do("layout", { options: options });
  }

  function applyCircle() {
    const options = { name: "circle", animate: true };
    $ur.do("layout", { options: options });
  }

  function applyfcose() {
    const options = {
      name: "fcose",
      animate: true,
      idealEdgeLength: (edge) => 150,
      quality: "proof",
      randomize: false,
      nodeSeparation: 200,
    };
    $ur.do("layout", { options: options });
  }

  function applycola() {
    const options = {
      name: "cola",
      animate: true,
      nodeSpacing: function (node) {
        return 50;
      },
    };
    $ur.do("layout", { options: options });
  }

  $: menuItems = [
    {
      name: "Recommended: Tree",
      action: () => applySemLayout("tree"),
      disable: $appState.modelEmpty,
    },
    {
      name: "Recommended: Tree2",
      action: () => applySemLayout("tree2"),
      disable: $appState.modelEmpty,
    },
    {
      name: "Experimental: Tree",
      action: applyDagre,
      disable: $appState.modelEmpty,
    },
    {
      name: "Experimental: Tree2",
      action: applyBF,
      disable: $appState.modelEmpty,
    },
    {
      name: "Experimental: Circle",
      action: applyCircle,
      disable: $appState.modelEmpty,
    },
    {
      name: "Experimental: Force-directed",
      action: applyfcose,
      disable: $appState.modelEmpty,
    },
    {
      name: "Experimental: Cola",
      action: applycola,
      disable: $appState.modelEmpty,
    },
  ];
</script>

<DropDownLinks name={"Apply Layout"} {menuItems} />
