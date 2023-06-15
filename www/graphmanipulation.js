var nodeIdCounter = 0;
var edgeIdCounter = 0;

// adding new nodes via mouse, toolbar, or hotkey
function addNode(nodeType, position) {
    var nodeId = 'node' + nodeIdCounter++;
    var label = 'x' + nodeIdCounter;

    // Check if position is provided, if not, use random position
    var finalPosition = position ? position : { x: Math.random() * 400 + 50, y: Math.random() * 400 + 50 };

    cy.add({
        group: 'nodes',
        data: { id: nodeId, label: label },
        classes: nodeType,
        position: finalPosition
    });

    if (nodeType !== "constant") {
        var edgeId = 'edge' + edgeIdCounter++;
        cy.add({
            group: 'edges',
            data: {
                id: edgeId,
                source: nodeId,
                target: nodeId,
                label: ''
            },
            classes: 'loop free nolabel'
        });
    }
}

// keyboard and mouse actions


// Grab the container div and make it focusable
var cyContainer = document.getElementById("cy");
cyContainer.setAttribute('tabindex', '0');

// Focus the container so it can receive keyboard events
cyContainer.focus();

// keep track of mouse position
var lastMousePosition = { x: 0, y: 0 };
$('#cy').mousemove(function (event) { 
    lastMousePosition = {
        x: event.offsetX,
        y: event.offsetY
    };
});

document.getElementById("cy").addEventListener("mouseover", function () {
    this.focus();
});

// keyboard events
cyContainer.addEventListener('keydown', function (event) {
    // Check if the Command key was pressed
    if (event.key === 'Meta' || event.key === 'Control') {
        eh.enableDrawMode();
    }

    if (event.key === 'Backspace') {
        var selectedElements = cy.$(':selected');

        selectedElements.forEach(function (element) {
            if (element.isNode()) {
                element.remove();
            } else if (element.isEdge()) {
                element.remove();
            }
        });
    }

    if (['l', 'o', 'c'].includes(event.key.toLowerCase())) {
        var nodeType;
        switch (event.key.toLowerCase()) {
            case 'l':
                nodeType = 'latent-variable';
                break;
            case 'o':
                nodeType = 'observed-variable';
                break;
            case 'c':
                nodeType = 'constant';
                break;
        }
        addNode(nodeType, lastMousePosition); // Use the last known mouse position within Cytoscape container.
    }
});


cyContainer.addEventListener('keyup', function (event) {
    // Check if the Command key was released
    if (event.key === 'Meta' || event.key === 'Control') {
        eh.disableDrawMode();
    }
});