var nodeIdCounter = 0;
var edgeIdCounter = 0;
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
    
    if(nodeType !== "constant"){
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

// First, let's keep track of the last known mouse position within the Cytoscape container.
var lastMousePosition = { x: 0, y: 0 };

// Adding a mousemove event listener to the Cytoscape container.
$('#cy').mousemove(function(event) { // Assuming 'cy' is the id of the Cytoscape container.
    lastMousePosition = {
        x: event.offsetX,
        y: event.offsetY
    };
});

// Grab the container div and make it focusable
var cyContainer = document.getElementById("cy");
cyContainer.setAttribute('tabindex', '0');

// Focus the container so it can receive keyboard events
cyContainer.focus();

// Add keydown event listeners to the div
cyContainer.addEventListener('keydown', function (event) {
    // Check if the Command key was pressed
    if (event.key === 'Meta' || event.key === 'Control') {
        eh.enableDrawMode();
    }

    if (event.key === 'Backspace') {
        var selectedElements = cy.$(':selected');

        selectedElements.forEach(function(element) {
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



// Grab the container div and make it focusable
var cyContainer = document.getElementById("cy");
cyContainer.setAttribute('tabindex', '0');

// Focus the container so it can receive keyboard events
cyContainer.focus();

// Add keydown event listeners to the div
cyContainer.addEventListener('keydown', function (event) {
    // ... existing keydown event code
});

// Add keyup event listeners to the div
cyContainer.addEventListener('keyup', function (event) {
    // Check if the Command key was released
    if (event.key === 'Meta' || event.key === 'Control') {
        eh.disableDrawMode();
    }
});


addNode('observed-variable');
addNode('observed-variable');
addNode('observed-variable');


function countEdgesConnectedToNodeSides(nodeId) {
    var node = cy.getElementById(nodeId);
    if (node.length === 0) {
        console.log("Node with ID " + nodeId + " does not exist.");
        return;
    }

    var topCount = 0;
    var bottomCount = 0;

    var nodePosition = node.position();
    var nodeHeight = node.height();

    node.connectedEdges().forEach(function (edge) {
        var source = edge.source();
        var target = edge.target();
        var otherNode = source.id() === node.id() ? target : source;
        if (node.id() !== otherNode.id()) {
            var otherNodePosition = otherNode.position();
            if (otherNodePosition.y < nodePosition.y - nodeHeight / 2) {
                // This edge connects to the top of the node
                topCount++;
            } else if (otherNodePosition.y > nodePosition.y + nodeHeight / 2) {
                // This edge connects to the bottom of the node
                bottomCount++;
            } else if (otherNodePosition.y == nodePosition.y) {
                console.log('kacke dampft')
            }
        }
    });
    if (topCount > 0 && bottomCount == 0) {
        return "bottom"
    }

    if (topCount == 0 && bottomCount > 0) {
        return "top"
    }

    if (topCount == 0 && bottomCount > 0) {
        return "keep"
    }

}

function moveLoopNode(nodeId, action) {
    var node = cy.getElementById(nodeId);

    if (node.length === 0) {
        console.log("Node with ID " + nodeId + " does not exist.");
        return;
    }

    var loopEdge = null;

    node.connectedEdges().forEach(function (edge) {
        var source = edge.source();
        var target = edge.target();


        if (source.id() === nodeId && target.id() === nodeId) {
            loopEdge = edge; // Found a loop connected to the node itself
            return;
        }
    });
    moveLoopEdge(loopEdge, action)
}


// Function to move edge loops to the bottom of nodes
function moveLoopEdge(selfEdge, action) {
    if (selfEdge != null) {
        var currentLoopDirection = selfEdge.style('loop-direction');
        if (action == "bottom" && currentLoopDirection == '0rad') {
            selfEdge.style('loop-direction', '3.14');

        } else if (action == "top" && currentLoopDirection == '3.14rad') {
            selfEdge.style('loop-direction', '0');
        }
    }
};



function checkNodeLoop(nodeID) {
    action = countEdgesConnectedToNodeSides(nodeID);
    moveLoopNode(nodeID, action);
}

function isNode(str) {
    // Regular expression pattern to match strings of form "node" followed by one or more digits
    const pattern = /^node\d+$/;
    return pattern.test(str);
}

// ceck for collision when adding
cy.on('add', 'edge', function (event) {
    var edge = event.target;
    var sourceNodeId = edge.source().id();
    var targetNodeId = edge.target().id();
    edge.addClass('free');
    edge.addClass('nolabel');

    if (sourceNodeId !== targetNodeId && isNode(sourceNodeId) && isNode(targetNodeId)) {
        // Call your function for both nodes
        checkNodeLoop(sourceNodeId);
        checkNodeLoop(targetNodeId);
        edge.addClass('directed');
    }else if (sourceNodeId === targetNodeId && isNode(sourceNodeId) && isNode(targetNodeId)){
        edge.addClass('loop');
    }
    if ((edge.hasClass('undirected') || edge.hasClass('loop')) && (edge.source().hasClass('constant') || edge.target().hasClass('constant'))){
        cy.remove(edge);
    }

    if(edge.hasClass('directed') && (edge.target().hasClass('constant'))){
        cy.remove(edge);
    }

    if(edge.hasClass('directed') && (edge.source().hasClass('constant'))){
        t_node = edge.target()
        conConstant = t_node.connectedEdges(function(edge){return edge.source().hasClass('constant')})
        if(conConstant.length > 1){
            cy.remove(edge);
        }
    }

    if(edge.hasClass('directed') && (edge.source().hasClass('constant'))){
        edge.data('isMean', "1");
    }else{
        edge.data('isMean', "0");
    }
});

// check for collision when moving stuff
cy.on('position', 'node', function (event) {
    var node = event.target; // Get the node whose position changed
    var newPosition = node.position(); // Get the new position of the node

    // Retrieve the connected nodes
    var connectedNodes = node.neighborhood().nodes();

    // Apply the checkNodeLoop function to each connected node
    connectedNodes.forEach(function (connectedNode) {
        var connectedNodeId = connectedNode.id();
        checkNodeLoop(connectedNodeId);
    });
});

$("#add-latent-variable").click(function() {
    addNode("latent-variable");
  });

  // Button click event for "Create Observed Variable"
  $("#add-manifest-variable").click(function() {
    addNode("observed-variable");
  });

  // Button click event for "Create Constant Variable"
  $("#add-constant-variable").click(function() {
    addNode("constant");
  });
