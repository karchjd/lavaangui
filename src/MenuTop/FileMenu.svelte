<script>
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  function nothing() {}
  let menuItems = [
    { name: "New Model", action: nothing, divider: false },
    { name: "Load Model", action: nothing, divider: false },
    { name: "Load Data", action: nothing, divider: false },
    { name: "Load Model and Data", action: nothing, divider: true },
    { name: "Download Model", action: nothing, divider: false },
    { name: "Download Model and Data", action: nothing, divider: true },
    { name: "Remove Data", action: nothing, divider: false },
    { name: "Export Model to PNG", action: nothing, divider: false },
    { name: "Load Data", action: nothing, divider: false },
  ];
</script>

<DropdownLinks name={"File"} {menuItems} />
