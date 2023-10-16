<script>
  export let name;
</script>

<li class="dropdown">
  <a
    href={"#"}
    class="dropdown-toggle"
    data-toggle="dropdown"
    role="button"
    aria-haspopup="true"
    aria-expanded="false"
  >
    {name}<span class="caret" /></a
  >
  <ul class="dropdown-menu">
    <slot />
  </ul>
</li>
