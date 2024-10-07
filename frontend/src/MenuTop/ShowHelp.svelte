<script>
  import DropdownLinks from "./helpers/DropDownLinks.svelte";
  let version;

  const menuItems = [
    {
      name: "Show Commands",
      action: showCommands,
    },
    {
      name: "Open Tutorial",
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
    window.open("https://doi.org/10.31234/osf.io/f4ary", "_blank");
  }

  function openAbout() {
    bootbox.alert({
      title: "About Lavaangui",
      message: `Version: ${version}<br> Author: Julian D. Karch<br> Email: j.d.karch@fsw.leidenuniv.nl <br> lavaangui is BETA software. Please report any bugs at https://github.com/karchjd/lavaangui/issues.`,
    });
  }

  // @ts-expect-error
  Shiny.addCustomMessageHandler("version", function (lavguiVersion) {
    version = lavguiVersion[0].join(".");
  });
</script>

<DropdownLinks name={"Help"} {menuItems} />
