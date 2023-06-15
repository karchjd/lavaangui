// checks after adding a node
cy.on('add', 'node', function (event) {
    var node = event.target;
    if (node.hasClass('observed-variable')) {
        if (columnNamesGlobal && columnNamesGlobal.includes(node.data('label'))) {
            node.addClass('linked');
            if(!appState.isLoadingMode()){
                alert('Variable connected with data set');
            }
        }
    }
});

// checks afer adding an edge
cy.on('add', 'edge', function (event) {
    if (!appState.isLoadingMode()) {
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
        } else if (sourceNodeId === targetNodeId && isNode(sourceNodeId) && isNode(targetNodeId)) {
            edge.addClass('loop');
        }
        if ((edge.hasClass('undirected') || edge.hasClass('loop')) && (edge.source().hasClass('constant') || edge.target().hasClass('constant'))) {
            cy.remove(edge);
        }

        if (edge.hasClass('directed') && (edge.target().hasClass('constant'))) {
            cy.remove(edge);
        }

        if (edge.hasClass('directed') && (edge.source().hasClass('constant'))) {
            t_node = edge.target()
            conConstant = t_node.connectedEdges(function (edge) { return edge.source().hasClass('constant') })
            if (conConstant.length > 1) {
                cy.remove(edge);
            }
        }

        if (edge.hasClass('directed') && (edge.source().hasClass('constant'))) {
            edge.data('isMean', "1");
        } else {
            edge.data('isMean', "0");
        }
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

function checkNodeLoop(nodeID) {
    action = countEdgesConnectedToNodeSides(nodeID);
    moveLoopNode(nodeID, action);
}

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

function isNode(str) {
    // Regular expression pattern to match strings of form "node" followed by one or more digits
    const pattern = /^node\d+$/;
    return pattern.test(str);
}
