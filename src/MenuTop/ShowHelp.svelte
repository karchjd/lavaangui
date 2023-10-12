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
    Shiny.setInputValue("show_help", Math.random());
  }
</script>

<DropdownLinks name={"Help"} {menuItems} />
