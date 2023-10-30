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
    padding: 8px 16px;
  }

  .minimal:hover,
  .minimal:focus {
    background-color: #f5f5f5;
  }
</style>
