cy.contextMenus({
    menuItems: [
        {
            id: 'toggle-direction',
            content: 'Toggle Direction',
            selector: 'edge',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                var direction = edge.data('direction');
                var sourceId = edge.source().id();
                var targetId = edge.target().id();
                edge.move({
                    source: targetId,
                    target: sourceId
                });
            },
            hasTrailingDivider: true
        },
        {
            id: 'toggle-directed',
            content: 'Toggle Directed',
            selector: 'edge',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;

                // Check if the edge is currently connected
                var undirected = edge.hasClass('undirected');

                // Toggle the connected state
                if (!undirected) {
                    // Remove the 'connected' class and add the 'unconnected' class
                    edge.addClass('undirected');

                    // Remove the direction data attribute
                    edge.removeData('direction');

                } else {
                    // Remove the 'unconnected' class and add the 'connected' class
                    edge.removeClass('undirected');

                    // Set the direction data attribute to 'forward'
                    edge.data('direction', 'forward');
                }
            },
            hasTrailingDivider: true
        },

        {
            id: 'toggle-directed',
            content: 'Toggle Directed',
            selector: 'edge',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;

                // Check if the edge is currently connected
                var undirected = edge.hasClass('undirected');

                // Toggle the connected state
                if (!undirected) {
                    // Remove the 'connected' class and add the 'unconnected' class
                    edge.addClass('undirected');

                    // Remove the direction data attribute
                    edge.removeData('direction');

                } else {
                    // Remove the 'unconnected' class and add the 'connected' class
                    edge.removeClass('undirected');

                    // Set the direction data attribute to 'forward'
                    edge.data('direction', 'forward');
                }
            },
            hasTrailingDivider: true
        },


        {
            id: 'toggle-free',
            content: 'Toggle Free',
            selector: 'edge',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                var edgeId = edge.id();

                if (edge.data('free') === true) {
                    edge.data('free', false);
                } else {
                    edge.data('free', true);
                }

            },
            hasTrailingDivider: false
        },
        {
            id: 'remove-edge',
            content: 'remove edge',
            selector: 'edge',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                edge.remove()
            },
            hasTrailingDivider: true
        },
        {
            id: 'remove-node',
            content: 'remove node',
            selector: 'node',
            onClickFunction: function (event) {
                var node = event.target || event.cyTarget;
                node.remove();
            },
            hasTrailingDivider: true
        },
        {
            id: 'rename-node',
            content: 'Rename Node',
            selector: 'node',
            onClickFunction: function (event) {
                var node = event.target || event.cyTarget;
                var currentLabel = node.data('label');
                var newLabel = prompt('Enter the new label for the node:', currentLabel);
                if (newLabel !== null) {
                    node.data('label', newLabel);
                    node.style('label', newLabel);
                }
            }
        },
        {
            id: 'non-free-edge-item',
            content: 'Non-Free Edge Menu Item',
            selector: 'edge[data-isFree = "false"]',
            onClickFunction: function (event) {
                console.log('Non-Free Edge Menu Item clicked');
            }
        }

    ]
});




$('#create-lavaan-syntax').on('click', function () {
    var nodes = cy.nodes();
    var edges = cy.edges();
    var syntax = '';

    // Generate regression connection statements for all edges
    edges.forEach(function (edge) {
        var sourceId = edge.data('source');
        var targetId = edge.data('target');
        syntax += targetId + ' ~ ' + sourceId + '\n';
    });

    // Display the generated Lavaan syntax
    $('#lavaan-syntax').html(('<pre>' + syntax + '</pre>'));
});