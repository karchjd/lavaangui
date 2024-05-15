<script>
  export let left = 100;
  export let top = 100;

  let moving = false;
  let offsetX = 0;
  let offsetY = 0;

  function onMouseDown(e) {
    moving = true;
    offsetX = e.clientX - left;
    offsetY = e.clientY - top;
  }

  function onMouseMove(e) {
    if (moving) {
      left = e.clientX - offsetX;
      top = e.clientY - offsetY;
    }
  }

  function onMouseUp() {
    moving = false;
  }
</script>

<section
  on:mousedown={onMouseDown}
  style="left: {left}px; top: {top}px;"
  class="draggable"
>
  <slot />
</section>

<svelte:window on:mouseup={onMouseUp} on:mousemove={onMouseMove} />

<style>
  .draggable {
    user-select: none;
    cursor: move;
    border: solid 1px gray;
    position: absolute;
    z-index: 10000;
    background-color: white;
  }
</style>
