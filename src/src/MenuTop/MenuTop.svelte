<script>
  import Navbar from "./Navbar.svelte";
  import FileMenu from "./FileMenu.svelte";
  import ViewMenu from "./ViewMenu.svelte";
  import MeanMenu from "./MeanMenu.svelte";
  import EstimationMenu from "./EstimationMenu.svelte";
  import Layouts from "./Layouts.svelte";
  import AddMenu from "./AddMenu.svelte";
  import ShowHelp from "./ShowHelp.svelte";
  import GridOptions from "./GridOptions.svelte";
</script>

<Navbar>
  <FileMenu />
  <ViewMenu />
  <MeanMenu />
  <AddMenu />
  <EstimationMenu />
  <Layouts />
  <GridOptions />
  <ShowHelp />
</Navbar>
