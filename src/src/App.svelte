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
  import DownloadModelData from "./Shiny/DownloadModelData.svelte";
  import Zoom from "./Graph/Zoom.svelte";
  import MainContainer from "./Graph/MainContainer.svelte";
  import DuckTapeFixes from "./DuckTapeFixes.svelte";
  import DataInfoModal from "./Toolbars/DataInfoModal.svelte";
  import EstimationWait from "./Shiny/EstimationWait.svelte";
  import Alert from "./Toolbars/Alert.svelte";
  import UndoRedo from "./Graph/UndoRedo.svelte";
  import { appState } from "./stores.js";
  import AppReady from "./Shiny/AppReady.svelte";
  import ViewUpdater from "./MenuTop/ViewUpdater.svelte";
</script>

<AppReady />
{#if $appState.ready}
  {#if $appState.full}
    <DataInfoModal />
    <EstimationWait />
  {/if}

  <Init />
  <div>
    {#if $appState.full}
      <MenuTop />
    {/if}
    <MainContainer>
      <Graph />
      <GridGuides />
      <Zoom />
      <ContextMenus />
      <OnEvents />
      <UndoRedo />
      <ViewUpdater />
      {#if $appState.full}
        <Results />
      {/if}
    </MainContainer>
    {#if $appState.full}
      <Alert />
      <ToolbarBelow />
    {/if}
  </div>
  <Debug />
  {#if $appState.full}
    <DataInput />
  {/if}
  <FromR />
  {#if $appState.full}
    <DownloadModelData />
  {/if}
  <DuckTapeFixes />
{/if}

<style>
  div {
    display: flex;
    flex-direction: column;
    height: 100vh;
  }
</style>
