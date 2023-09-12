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
</script>

<DataInfoModal />
<EstimationWait />
<Init />
<MenuTop />
<MainContainer>
  <Graph />
  <GridGuides />
  <Zoom />
  <ContextMenus />
  <OnEvents />
  <Results />
</MainContainer>
<Alert />
<ToolbarBelow />
<Debug />
<DataInput />
<FromR />
<DownloadModelData />
<DuckTapeFixes />
