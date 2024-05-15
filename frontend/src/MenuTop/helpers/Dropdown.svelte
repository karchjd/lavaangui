<script>
  export let name;
  export let minimal = false;
</script>

<li class="dropdown">
  <a
    href={"#"}
    class="dropdown-toggle"
    data-toggle="dropdown"
    role="button"
    aria-haspopup="true"
    aria-expanded="false"
    class:minimal
    draggable="false"
  >
    {name}<span class="caret" /></a
  >
  <ul class="dropdown-menu">
    <slot />
  </ul>
</li>

<style>
  .minimal {
    color: black;
    text-decoration: none;
    padding: 3px 16px;
    margin: 12px 8px;
  }

  .minimal:hover,
  .minimal:focus {
    background-color: #f5f5f5;
  }
</style>
