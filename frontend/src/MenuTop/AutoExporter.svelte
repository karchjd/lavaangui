<script>
    import {
        exportPNG,
        exportJPG,
        exportSVG,
        exportPDF,
        parseModel,
    } from "./exportImport.js";
    // @ts-ignore
    Shiny.addCustomMessageHandler("autoExport", function (message) {
        console.log(message);
        setTimeout(() => {
            exportPDF().then((pdfData) => {
                Shiny.setInputValue("exportedGraph", pdfData);
            });
        }, 1000);
    });

    Shiny.addCustomMessageHandler("savedModel", function (model) {
        parseModel(model);
    });
</script>
