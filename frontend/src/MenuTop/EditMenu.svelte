<script>
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  import { appState, ur } from "../stores.js";
  function undo() {
    $ur.undo();
  }

  function redo() {
    $ur.redo();
  }
  let menuItems = [];
  $: {
    menuItems = [
      {
        name: "Undo",
        action: undo,
        disable: $appState.undoEmpty,
      },
      {
        name: "Redo",
        action: redo,
        disable: $appState.redoEmpty,
      },
    ];
  }
</script>

<DropdownLinks name={"Edit"} {menuItems} />
