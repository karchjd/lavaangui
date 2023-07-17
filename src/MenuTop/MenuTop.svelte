<script>
  import HelpPage from "./HelpPage.svelte";
  import Navbar from "./Navbar.svelte";
  import FileMenu from "./FileMenu.svelte";
  import EditMenu from "./EditMenu.svelte";
  import ViewMenu from "./ViewMenu.svelte";
</script>

<HelpPage />
<Navbar>
  <FileMenu />
  <ViewMenu/>
  <HelpPage />
</Navbar>
