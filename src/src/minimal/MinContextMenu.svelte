<script>
  import { appState } from "../stores";
  import { onMount } from "svelte";
  let x = 0;
  let y = 0;

  let showMenu = false;

  function showDropdown(event) {
    event.preventDefault(); // Prevent the default context menu
    x = event.clientX;
    y = event.clientY;
    showMenu = true;
  }

  function hideMenu() {
    showMenu = false;
  }

  onMount(() => {
    if (!$appState.full) {
      const removeListener = addEventListener("contextmenu", showDropdown);
    }
  });
</script>

{#if showMenu}
  <ul
    class="nav navbar-nav navbar-left"
    style={`position: absolute; top: ${y}px; left: ${x}px; z-index: 9999;`}
  >
    <div style="display: flex; flex-direction: column;">
      <slot />
      <li><a href={"#"} on:click={hideMenu}>Close Menu</a></li>
    </div>
  </ul>
{/if}
