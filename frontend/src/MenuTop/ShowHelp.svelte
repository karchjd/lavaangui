<script>
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  let version;

  const menuItems = [
    {
      name: "Show Commands",
      action: showCommands,
    },
    {
      name: "Open Manual",
      action: openManual,
    },
    {
      name: "About",
      action: openAbout,
    },
  ];

  function showCommands() {
    // @ts-ignore
    Shiny.setInputValue("show_help", Math.random());
  }

  function openManual() {
    window.open("https://karchjd.github.io/docs.lavaangui/", "_blank");
  }

  function openAbout() {
    bootbox.alert({
      title: "About Lavaangui",
      message: `Version: ${version}<br> Author: Julian D. Karch<br> Email: j.d.karch@fsw.leidenuniv.nl`,
    });
  }

  // @ts-expect-error
  Shiny.addCustomMessageHandler("version", function (lavguiVersion) {
    version = lavguiVersion[0].join(".");
  });
</script>

<DropdownLinks name={"Help"} {menuItems} />
