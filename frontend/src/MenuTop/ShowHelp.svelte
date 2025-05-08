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
      size: "large",
      message: `Version: ${version}<br> Author: Julian D. Karch<br> Email: j.d.karch@fsw.leidenuniv.nl <br> lavaangui is BETA software. Please report any bugs at https://github.com/karchjd/lavaangui/issues.`,
    });
  }

  function openCite() {
    bootbox.alert({
      title: "How to Cite",
      className: "dialogWide",
      message: `To cite this package in publications, please use:<br><br>
              <div style="margin-left: 20px;">
                  Karch, J. D. (2025). lavaangui: A Web-Based Graphical Interface for Specifying Lavaan Models by Drawing Path Diagrams.
                  <i>Structural Equation Modeling: A Multidisciplinary Journal,</i> 1–12. 
                  <a href="https://doi.org/10.1080/10705511.2024.2420678" target="_blank">https://doi.org/10.1080/10705511.2024.2420678</a>
              </div>
              <br>
              A BibTeX entry for LaTeX users is:<br><br>
              <div style="margin-left: 20px;">
                  <pre>
@Article{,
  author = {J. D. Karch},
  year = {2025},
  title = {{lavaangui}: A Web-Based Graphical Interface for Specifying Lavaan Models by Drawing Path Diagrams},
  journal = {Structural Equation Modeling: A Multidisciplinary Journal},
  doi = {10.1080/10705511.2024.2420678},
  publisher = {Routledge},
  pages = {1--12},
}</pre>
              </div>`,
    });
  }

  // @ts-expect-error
  Shiny.addCustomMessageHandler("version", function (lavguiVersion) {
    version = lavguiVersion[0].join(".");
  });
</script>

<DropdownLinks name={"Help"} {menuItems} />
