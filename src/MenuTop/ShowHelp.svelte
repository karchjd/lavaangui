<script>
  import DropdownLinks from "./helpers/DropDownLinks.svelte";

  const menuItems = [
    {
      name: "Show Commands",
      action: showCommands,
    },
    {
      name: "Open Manual",
      action: showCommands,
    },
  ];

  function showCommands() {
    const event = new CustomEvent("reset-content");
    document.body.dispatchEvent(event);
  }
</script>

<DropdownLinks name={"Help"} {menuItems} />
