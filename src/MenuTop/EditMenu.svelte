<script>
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  function nothing() {}
  let menuItems = [
    { name: "Cut", action: nothing, divider: false },
    { name: "Copy", action: nothing, divider: false },
    { name: "Paste", action: nothing, divider: false },
  ];
</script>

<DropdownLinks name={"Edit"} {menuItems} />
