function isEmpty(cytoscapeInstance) {
    return cytoscapeInstance.elements().length == 0;
}
// Attach click event handler to load data menu item
$("#newDiagramMenuItem").on("click", function () {
    if (isEmpty(cy) || confirm('Are you sure you want to create a new model? This will delete the current model.')) {
        cy.elements().remove();
    }
});

function jsonModel(){
     //remove link with data set
     let cy_save = cy;
     cy_save.nodes().removeClass('linked');
 
     // Convert diagram data to JSON string
     const json = cy_save.json();
     const str = JSON.stringify(json);
     return str
}

// Attach click event handler to save diagram menu item
$("#saveDiagramMenuItem").on('click', function () {

    const str = jsonModel();
    // Create a new Blob object using the JSON string
    let blob = new Blob([str], {type: "application/json;charset=utf-8"});
    let url = URL.createObjectURL(blob);

    // Create and trigger download link for the JSON data
    $('<a>').attr({href: url, download: 'diagram.json'})[0].click();
});

// Attach click event handler to save diagram menu item
$("#saveModelDataMenuItem").on('click', function () {

    const str = jsonModel();
    Shiny.setInputValue("model", str);
    Shiny.setInputValue('triggerDownload', Math.random());
});

function loadModel(content){
    let json = JSON.parse(content);
    // Set loading mode, update diagram and perform checks
    appState.setLoadingMode(true)
    cy.json(json);
    cy.style(myStyle);
    let nodes = cy.nodes();
    for (let i = 0; i < nodes.length; i++) {
        console.log(nodes[i].data('label'));
        checkNodeLoop(nodes[i].id());
    }
    if(appState.getColumnNamesGlobal() != null){
        applyLinkedClass(appState.getColumnNamesGlobal() , false)
    }
}

// Attach click event handler to load diagram menu item
$("#loadDiagramMenuItem").on('click', function () {
    if (isEmpty(cy) || confirm('Are you sure you want to load a model? This will delete the current model.')) {
    // Create file input element
    let $input = $('<input>').attr({type: 'file', accept: '.json'});

    // Attach change event handler to the file input element
    $input.on('change', function (e) {
        // Read the selected file
        let file = e.target.files[0];
        let reader = new FileReader();
        reader.readAsText(file, 'UTF-8');

        // Handle file content after it's read
        reader.onload = function (readerEvent) {
            // Parse file content as JSON
            let content = readerEvent.target.result;
            loadModel(content)
        }
    });

    // Trigger the file input click action
    $input.click();
}
});

// Attach click event handler to load data menu item
$("#loadDataMenuItem").on("click", function () {
    // Trigger the file input click action
    $("#fileInput").click();
});

$("#loadModelDataMenuItem").on("click", function () {
    // Create file input element
    let $input = $('<input>').attr({type: 'file', accept: '.zip'});

    // Attach change event handler to the file input element
    $input.on('change', function (e) {
        // Read the selected file
        let file = e.target.files[0];
        let reader = new FileReader();
        reader.readAsArrayBuffer(file);

        // Handle file content after it's read
        reader.onload = function (readerEvent) {
            // Use JSZip to unzip the file content
            JSZip.loadAsync(readerEvent.target.result).then(function(zip) {
                // Apply loadModel to model.json file within the zip
                zip.file("model.json").async("text").then(function(content) {
                    loadModel(content);
                });
                
                 // Send data.csv file to the shiny server
                 zip.file("data.csv").async("base64").then(function(content) {
                    // Send the content of the file as a base64 string
                    Shiny.setInputValue("fileInput", {content: content});
                });

            });
        }
    });

    // Trigger the file input click action
    $input.click();
});

$("#removeDataItem").on("click", function () {
    appState.setDataAvail(false)
    alert("Data removed");
});






