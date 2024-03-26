<script>
  import Draggable from "./Draggable.svelte";
</script>

<Draggable>
  <ul
    class="nav navbar-nav navbar-left"
    style="border: 1px solid black; z-index: 9999;"
  >
    <div style="display: flex; flex-direction: column;">
      <slot />
    </div>
  </ul>
</Draggable>
