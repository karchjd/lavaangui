<script>
  import GridGuides from "./Graph/GridGuides.svelte";
  import Init from "./Graph/Init.svelte";
  import Graph from "./Graph/MountGraphSimple.svelte";
  import OnEvents from "./Graph/OnEvents.svelte";
  import MenuTop from "./MenuTop/MenuTop.svelte";
  import Results from "./Shiny/Results.svelte";
  import ToolbarTop from "./Toolbars/ToolbarTop.svelte";
  import Debug from "./Debug.svelte";
  import ContextMenus from "./Graph/ContextMenus.svelte";
  import DataInput from "./Shiny/DataInput.svelte";
  import ToolbarBelow from "./Toolbars/ToolbarBelow.svelte";
  import RDataInterface from "./Shiny/RDataInterface.svelte";
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
<DataInput />
<RDataInterface />
<ToolbarBelow />

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
