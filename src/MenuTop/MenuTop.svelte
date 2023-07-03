<script>
  import HelpPage from "./HelpPage.svelte";
  import Navbar from "./Navbar.svelte";
  import FileMenu from "./FileMenu.svelte";
  import EditMenu from "./EditMenu.svelte";
</script>

<HelpPage />
<Navbar>
  <FileMenu />
  <EditMenu />
  <HelpPage />
</Navbar>
