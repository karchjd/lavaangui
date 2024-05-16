<script>
  import GridGuides from "./Graph/GridGuides.svelte";
  import Init from "./Graph/Init.svelte";
  import Graph from "./Graph/MountGraph.svelte";
  import OnEvents from "./Graph/OnEvents.svelte";
  import MenuTop from "./MenuTop/MenuTop.svelte";
  import Results from "./Shiny/Results.svelte";
  import Debug from "./Debug.svelte";
  import ContextMenus from "./Graph/ContextMenus.svelte";
  import DataInput from "./Shiny/DataInput.svelte";
  import ToolbarBelow from "./Toolbars/ToolbarBelow.svelte";
  import FromR from "./Shiny/fromR.svelte";
  import Zoom from "./Graph/Zoom.svelte";
  import MainContainer from "./Graph/MainContainer.svelte";
  import DuckTapeFixes from "./DuckTapeFixes.svelte";
  import EstimationWait from "./Shiny/EstimationWait.svelte";
  import Alert from "./Toolbars/Alert.svelte";
  import UndoRedo from "./Graph/UndoRedo.svelte";
  import { appState } from "./stores.js";
  import AppReady from "./Shiny/AppReady.svelte";
  import ViewUpdater from "./MenuTop/ViewUpdater.svelte";
  import ViewMenu from "./MenuTop/ViewMenu.svelte";
  import Layouts from "./MenuTop/Layouts.svelte";
  import MinContextMenu from "./minimal/MinContextMenu.svelte";
  import Errors from "./Errors.svelte";
  import FileMenu from "./MenuTop/FileMenu.svelte";
  import Reactive from "./Shiny/Reactive.svelte";
  import AutoMove from "./Graph/AutoMove.svelte";
  import NodeEditing from "./Graph/NodeEditing.svelte";
  import ExtendCyto from "./Graph/ExtendCyto.svelte";
  import BendEdges from "./Graph/BendEdges.svelte";
  import GridOptions from "./MenuTop/GridOptions.svelte";
</script>

<AppReady />
{#if $appState.ready}
  {#if $appState.full}
    <EstimationWait />
  {/if}

  <Init />
  <div>
    {#if $appState.full}
      <MenuTop />
    {:else}
      <MinContextMenu>
        <FileMenu full={false} />
        <ViewMenu minimal={true} />
        <Layouts minimal={true} />
        <GridOptions minimal={true} />
      </MinContextMenu>
    {/if}
    <MainContainer>
      <Graph />
      <!-- UndoRedo must be before all components that use it -->
      <UndoRedo />
      <ExtendCyto />
      <GridGuides />
      <AutoMove />
      <NodeEditing />
      <Zoom />
      <ContextMenus />
      <OnEvents />
      <ViewUpdater />
      <BendEdges />
      {#if $appState.full}
        <Results />
      {/if}
    </MainContainer>
    {#if $appState.full}
      <Alert />
      <ToolbarBelow />
      <Reactive />
    {/if}
  </div>
  <Debug />
  <FromR />
  <DuckTapeFixes />
{/if}
<!-- Warning: never ever put this inside ready, this will break them
Shiny needs to see them to attach listeners -->
<DataInput />
<Errors />

<style>
  div {
    display: flex;
    flex-direction: column;
    height: 100vh;
  }
</style>
