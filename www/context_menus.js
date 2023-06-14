
cy.contextMenus({
    //core menus

    menuItems: [
        // existing menu items...

        // Add variable as top-level items
        {
            id: 'add-constant',
            content: 'Add Constant Variable',
            coreAsWell: true,
            onClickFunction: function (event) {
                var position = event.position || event.cyPosition;
                addNode('constant', position);
            }
        },
        {
            id: 'add-latent',
            content: 'Add Latent Variable',
            coreAsWell: true,
            onClickFunction: function (event) {
                var position = event.position || event.cyPosition;
                addNode('latent-variable', position);
            }
        },
        {
            id: 'add-observed',
            content: 'Add Observed Variable',
            coreAsWell: true,
            onClickFunction: function (event) {
                var position = event.position || event.cyPosition;
                addNode('observed-variable', position);
            }
        },

        //edge menus

        {
            id: 'revert-arrow',
            content: 'Revert Direction',
            selector: 'edge[isMean="0"].directed',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                var sourceId = edge.source().id();
                var targetId = edge.target().id();
                ur.do("move", {
                    eles: edge,
                    location: {
                        source: targetId,
                        target: sourceId
                    }
                });
            },
            hasTrailingDivider: false
        },
        {
            id: 'revert-arrow',
            content: 'Set Undirected',
            selector: 'edge[isMean="0"].directed',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                edge.removeClass("directed")
                edge.addClass("undirected")
            },
            hasTrailingDivider: false
        },

        {
            id: 'revert-arrow',
            content: 'Set Directed',
            selector: 'edge.undirected',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                edge.removeClass("undirected")
                edge.addClass("directed")
            },
            hasTrailingDivider: false
        },



        {
            id: 'fix-para',
            content: 'Fix Parameter',
            selector: 'edge.free, edge.forcefree',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;

                // Ask the user for a value
                var value = prompt("Please enter a value:");

                // Store the value in the edge's data
                if (value !== null) {
                    edge.data('value', value);
                }
                edge.removeClass('free');
                edge.removeClass('forcefree')
                edge.addClass('fixed');
            },
            hasTrailingDivider: false
        },
        {
            id: 'free-force-para',
            content: 'Force Parameter Free',
            selector: 'edge.free, edge.fixed',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                edge.removeClass('free');
                edge.removeClass('fixed');
                edge.addClass('forcefree');
            },
            hasTrailingDivider: false
        },
        {
            id: 'free-para',
            content: 'Free Parameter',
            selector: 'edge.fixed, edge.forcefree',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                edge.removeClass('fixed');
                edge.removeClass('forcefree');
                edge.addClass('free');
            },
            hasTrailingDivider: false
        },
        {
            id: 'label-para',
            content: 'Set Label',
            selector: 'edge',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                // Regular expression to check for strings that start with a letter
                // and contain only alphanumeric characters (a-z, A-Z, 0-9)
                var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
                
                // Ask the user for a value
                var value = prompt("Please enter a label:");
        
                // Validate the input
                while (value !== null && !regex.test(value)) {
                    // Show an error message and ask for a new string
                    value = prompt("Invalid input. Please enter a label that starts with a letter and contains only alphanumeric characters:");
                }
        
                // Store the label in the edge's data if it's not null
                if (value !== null) {
                    edge.data('label', value);
                    edge.addClass("label");
                    edge.removeClass('nolabel')
                    console.log(value)
                }
            },
            hasTrailingDivider: true
        },
        {
            id: 'label-para',
            content: 'Remove Label',
            selector: 'edge.label',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                edge.removeClass('label')
                edge.addClass('nolabel')
                edge.data('label', undefined);
            },
            hasTrailingDivider: true
        },
        
        {
            id: 'remove-edge',
            content: 'Delete edge',
            selector: 'edge',
            onClickFunction: function (event) {
                var edge = event.target || event.cyTarget;
                edge.remove()
            },
            hasTrailingDivider: true
        },
        //node menus


        {
            id: 'change-latent',
            content: 'Change to Latent',
            selector: 'node.observed-variable',
            onClickFunction: function (event) {
                var node = event.target || event.cyTarget;
                node.removeClass('observed-variable');
                node.addClass('latent-variable')
            },
            hasTrailingDivider: false
        },
        {
            id: 'rename-node',
            content: 'Rename Variable',
            selector: 'node.latent-variable, node.observed-variable',
            onClickFunction: function (event) {
                var node = event.target || event.cyTarget;
                var currentLabel = node.data('label');
                var newLabel = prompt('Enter the new label for the node:', currentLabel);
                var available = document.getElementById("selectedVariables").options;
                document.getElementById("selectedVariables").options

                if (newLabel !== null) {
                    var isLabelAvailable = false;
                    for (var i = 0; i < available.length; i++) {
                        if (available[i].value === newLabel) {
                            isLabelAvailable = true;
                            break;
                        }
                    }
                    node.data('label', newLabel);
                    node.style('label', newLabel);
                    if (isLabelAvailable && node.hasClass('observed-variable')) {
                        node.addClass('linked');
                        alert('Variable connected with data set to the user');
                    }
                }
            },
            hasTrailingDivider: true
        },
        {
            id: 'remove-node',
            content: 'Delete Variable',
            selector: 'node',
            onClickFunction: function (event) {
                var node = event.target || event.cyTarget;
                node.remove();
            },
            hasTrailingDivider: false
        },
        {
            id: 'change-observed',
            content: 'Change to Observed',
            selector: 'node.latent-variable',
            onClickFunction: function (event) {
                var node = event.target || event.cyTarget;
                node.removeClass('latent-variable');
                node.addClass('observed-variable')
            }
        },
    ]
});