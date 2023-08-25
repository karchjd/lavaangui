<script>
  import HelpPage from "./HelpPage.svelte";
  import Navbar from "./Navbar.svelte";
  import FileMenu from "./FileMenu.svelte";
  import ViewMenu from "./ViewMenu.svelte";
  import MeanMenu from "./MeanMenu.svelte";
</script>

<HelpPage />
<Navbar>
  <FileMenu />
  <ViewMenu />
  <MeanMenu />
  <HelpPage />
</Navbar>
