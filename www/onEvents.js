cy.on('add', 'node', function (event) {
    const node = event.target;
    if (node.hasClass('observed-variable')) {
        columnNames =  appState.getColumnNamesGlobal();
        if (columnNames && columnNames.includes(node.data('label'))) {
            node.addClass('linked');
            if (!appState.isLoadingMode()) {
                alert('Variable connected with data set');
            }
        }
    }
});

cy.on('add', 'edge', function (event) {
    if (!appState.isLoadingMode()) {
        const edge = event.target;
        const sourceNodeId = edge.source().id();
        const targetNodeId = edge.target().id();
        edge.addClass('free');
        edge.addClass('nolabel');
        if (sourceNodeId !== targetNodeId && isNode(sourceNodeId) && isNode(targetNodeId)) {
            checkNodeLoop(sourceNodeId);
            checkNodeLoop(targetNodeId);
            edge.addClass('directed');
        } else if (sourceNodeId === targetNodeId && isNode(sourceNodeId) && isNode(targetNodeId)) {
            edge.addClass('loop');
        }
        //removers
        if ((edge.hasClass('undirected') || edge.hasClass('loop')) && (edge.source().hasClass('constant') || edge.target().hasClass('constant'))) {
            cy.remove(edge);
        }

        if (edge.hasClass('directed') && (edge.target().hasClass('constant'))) {
            cy.remove(edge);
        }

        if (edge.hasClass('directed') && (edge.source().hasClass('constant'))) {
            const t_node = edge.target();
            const conConstant = t_node.connectedEdges(edge => edge.source().hasClass('constant'));
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

cy.on('position', 'node', function (event) {
    const node = event.target;
    const connectedNodes = node.neighborhood().nodes();

    connectedNodes.forEach(connectedNode => {
        const connectedNodeId = connectedNode.id();
        checkNodeLoop(connectedNodeId);
    });
});

function checkNodeLoop(nodeID) {
    const action = countEdgesConnectedToNodeSides(nodeID);
    moveLoopNode(nodeID, action);
}

function countEdgesConnectedToNodeSides(nodeId) {
    const node = cy.getElementById(nodeId);
    if (node.length === 0) {
        console.error(`Node with ID ${nodeId} does not exist.`);
        return;
    }

    let topCount = 0;
    let bottomCount = 0;

    const nodePosition = node.position();
    const nodeHeight = node.height();

    node.connectedEdges().forEach(edge => {
        const source = edge.source();
        const target = edge.target();
        const otherNode = source.id() === node.id() ? target : source;
        const otherNodePosition = otherNode.position();
        if (node.id() !== otherNode.id()) {
            if (otherNodePosition.y < nodePosition.y - nodeHeight / 2) {
                topCount++;
            } else if (otherNodePosition.y > nodePosition.y + nodeHeight / 2) {
                bottomCount++;
            }
        }
    });

    if (topCount > 0 && bottomCount === 0) {
        return "bottom";
    }
    if (topCount === 0 && bottomCount > 0) {
        return "top";
    }
    return "keep";
}

// Rest of the functions remain unchanged


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
