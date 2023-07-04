<script>
  import GridGuides from "./Graph/GridGuides.svelte";
  import InitGraph from "./Graph/InitGraph.svelte";
  import Graph from "./Graph/MountGraphSimple.svelte";
  import MenuTop from "./MenuTop/MenuTop.svelte";
  import Navbar from "./MenuTop/Navbar.svelte";
  import Results from "./Results/Results.svelte";
  import ToolbarDown from "./Toolbars/ToolbarBelow.svelte";
  import ToolbarTop from "./Toolbars/ToolbarTop.svelte";
</script>

<InitGraph />
<MenuTop />
<ToolbarTop />
<div>
  <Graph />
  <GridGuides />
  <Results />
</div>

<!-- <ToolbarDown /> -->

<style>
  div {
    display: flex;
    height: 88vh;
    width: 100%;
    border: 1px solid lightgrey;
    padding: 0px;
    margin: 0px;
  }
</style>
