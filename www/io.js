// Attach click event handler to save diagram menu item
$("#saveDiagramMenuItem").on('click', function () {
    // Convert diagram data to JSON string
    let json = cy.json();
    let str = JSON.stringify(json);
    
    // Create a new Blob object using the JSON string
    let blob = new Blob([str], {type: "application/json;charset=utf-8"});
    let url = URL.createObjectURL(blob);

    // Create and trigger download link for the JSON data
    $('<a>').attr({href: url, download: 'diagram.json'})[0].click();
});

// Attach click event handler to load diagram menu item
$("#loadDiagramMenuItem").on('click', function () {
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
            appState.setLoadingMode(false)
        }
    });

    // Trigger the file input click action
    $input.click();
});

// Attach click event handler to load data menu item
$("#loadDataMenuItem").on("click", function () {
    // Trigger the file input click action
    $("#fileInput").click();
});
