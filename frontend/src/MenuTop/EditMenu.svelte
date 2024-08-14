<script>
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  import { ur } from "../stores.js";
  function undo() {
    $ur.undo();
  }

  function redo() {
    $ur.redo();
  }
  let menuItems = [
    { name: "Undo", action: undo, divider: false },
    { name: "Redo", action: redo, divider: false },
  ];
</script>

<DropdownLinks name={"Edit"} {menuItems} />
