<script>
  import DropdownLinks from "./helpers/DropDownLinks.svelte";

  const menuItems = [
    {
      name: "Show Commands",
      action: showCommands,
    },
    {
      name: "Open Manual",
      action: openManual,
    },
  ];

  function showCommands() {
    Shiny.setInputValue("show_help", Math.random());
  }

  function openManual() {
    window.open("https://karchjd.github.io/docs.lavaangui/", "_blank");
  }
</script>

<DropdownLinks name={"Help"} {menuItems} />
