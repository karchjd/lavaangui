<script>
  import ToolbarTop from "../Toolbars/ToolbarTop.svelte";
</script>

<nav class="navbar navbar-default navbar-static-top navbar-left">
  <ul class="nav navbar-nav navbar-left">
    <slot />
  </ul>
  <ToolbarTop />
</nav>

<style>
  nav {
    width: 100%;
    margin: 0;
    padding: 0;
  }
</style>
