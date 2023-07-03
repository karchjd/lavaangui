<script>
  import Graph from "./Graph/Graph.svelte";
  import MenuTop from "./MenuTop/MenuTop.svelte";
  import Navbar from "./MenuTop/Navbar.svelte";
  import Results from "./Results/Results.svelte";
  import ToolbarDown from "./Toolbars/ToolbarBelow.svelte";
  import ToolbarTop from "./Toolbars/ToolbarTop.svelte";
</script>

<MenuTop />

<!-- 
<ToolbarTop />
<div>
  <Graph />
  <Results />
</div>
<ToolbarDown />  -->

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
