<script>
  import GridGuides from "./Graph/GridGuides.svelte";
  import Init from "./Graph/Init.svelte";
  import Graph from "./Graph/MountGraphSimple.svelte";
  import OnEvents from "./Graph/OnEvents.svelte";
  import MenuTop from "./MenuTop/MenuTop.svelte";
  import Navbar from "./MenuTop/Navbar.svelte";
  import Results from "./Results/Results.svelte";
  import ToolbarDown from "./Toolbars/ToolbarBelow.svelte";
  import ToolbarTop from "./Toolbars/ToolbarTop.svelte";
  import Debug from "./Debug.svelte";
  import ContextMenus from "./Graph/ContextMenus.svelte";
</script>

<Init />
<MenuTop />
<ToolbarTop />
<div>
  <Graph />
  <GridGuides />
  <ContextMenus />
  <OnEvents />
  <Results />
</div>
<Debug />

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
