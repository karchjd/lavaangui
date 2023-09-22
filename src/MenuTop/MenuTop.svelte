<script>
  import HelpPage from "./HelpPage.svelte";
  import Navbar from "./Navbar.svelte";
  import FileMenu from "./FileMenu.svelte";
  import ViewMenu from "./ViewMenu.svelte";
  import MeanMenu from "./MeanMenu.svelte";
  import EstimationMenu from "./EstimationMenu.svelte";
  import Layouts from "./Layouts.svelte";
</script>

<HelpPage />
<Navbar>
  <FileMenu />
  <ViewMenu />
  <MeanMenu />
  <EstimationMenu />
  <HelpPage />
  <Layouts />
</Navbar>
