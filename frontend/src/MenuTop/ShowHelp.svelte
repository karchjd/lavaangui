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
    {
      name: "Cite",
      action: openCite,
    },
  ];

  function showCommands() {
    // @ts-ignore
    Shiny.setInputValue("show_help", Math.random());
  }

  function openManual() {
    window.open("https://doi.org/10.1080/10705511.2024.2420678", "_blank");
  }

  function openAbout() {
    bootbox.alert({
      title: "About Lavaangui",
      message: `Version: ${version}<br> Author: Julian D. Karch<br> Email: j.d.karch@fsw.leidenuniv.nl <br> lavaangui is BETA software. Please report any bugs at https://github.com/karchjd/lavaangui/issues.`,
    });
  }

  function openCite() {
    bootbox.alert({
      title: "How to Cite",
      message: `If you use lavaangui, please consider citing the following paper:<br> Karch, J. D. (2025). lavaangui: A Web-Based Graphical Interface for Specifying Lavaan Models by Drawing Path Diagrams. <i>Structural Equation Modeling: A Multidisciplinary Journal.</i> <a href="https://doi.org/10.1080/10705511.2024.2420678" target="_blank">https://doi.org/10.1080/10705511.2024.2420678</a>`,
    });
  }

  // @ts-expect-error
  Shiny.addCustomMessageHandler("version", function (lavguiVersion) {
    version = lavguiVersion[0].join(".");
  });
</script>

<DropdownLinks name={"Help"} {menuItems} />
