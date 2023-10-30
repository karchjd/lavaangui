<script>
  import dagre from "cytoscape-dagre";
  import cytoscape from "cytoscape";
  import { onMount } from "svelte";
  import fcose from "cytoscape-fcose";
  import { cyStore, appState, ur } from "../stores.js";
  import { get } from "svelte/store";
  import DropDownLinks from "./helpers/DropDownLinks.svelte";
  import cola from "cytoscape-cola";
  import { applySemLayout } from "./semPlotLayouts.js";
  export let minimal = false;
  let cy = get(cyStore);

  onMount(() => {
    // Initialize the Cytoscape instance
    cytoscape.use(dagre);
    cytoscape.use(fcose);
    cytoscape.use(cola);
  });

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

<DropDownLinks name={"Apply Layout"} {menuItems} {minimal} />
