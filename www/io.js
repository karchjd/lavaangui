function saveGraph() {
    // Get the graph data
    var graphData = cy.json();

    // Convert it to a JSON string
    var graphDataString = JSON.stringify(graphData);

    // Create a blob object representing the data as bytes
    var blob = new Blob([graphDataString], { type: 'application/json' });

    // Create a link element
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = 'graphData.json';

    // Append the link to the body, trigger the click event, and remove it
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
}

function loadGraph(event) {
    // Get the file the user uploaded
    var file = event.target.files[0];

    // Read the file
    var reader = new FileReader();
    reader.onload = function (e) {
        console.log('File content:', e.target.result); // Logging the file content

        try {
            // Parse the file data as JSON
            var graphData = JSON.parse(e.target.result);
            console.log('Parsed graph data:', graphData); // Logging the parsed data

            // Clear the current graph
            cy.elements().remove();

            // Load the graph data
            cy.add(graphData.elements); // Adding elements instead of setting the entire JSON

            // Apply a layout to the loaded graph
            var layout = cy.layout({
                name: 'grid', // Changing layout to grid for demonstration
                fit: true
            });
            layout.run();
        } catch (error) {
            console.error('Error parsing/loading the graph data:', error);
        }
    };
    reader.readAsText(file);
}
