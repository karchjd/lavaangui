
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

    // Create a backdrop
    var backdrop = document.createElement('div');
    backdrop.style.position = 'fixed';
    backdrop.style.top = 0;
    backdrop.style.left = 0;
    backdrop.style.width = '100vw';
    backdrop.style.height = '100vh';
    backdrop.style.backgroundColor = 'rgba(0, 0, 0, 0.5)'; // semi-transparent
    backdrop.style.zIndex = 1000; // ensure it's on top

    // Create a modal
    var modal = document.createElement('div');
    modal.style.position = 'fixed';
    modal.style.top = '50%';
    modal.style.left = '50%';
    modal.style.transform = 'translate(-50%, -50%)';
    modal.style.backgroundColor = 'white';
    modal.style.padding = '20px';
    modal.style.border = '1px solid #ccc';
    modal.style.zIndex = 1001; // ensure it's above the backdrop

    var select = false;
    // Add select box if columnNamesGlobal is defined
    if (typeof columnNamesGlobal !== 'undefined' && node.hasClass('observed-variable')) {
        select = true;
        // Add label for the select box
        var selectLabel = document.createElement('label');
        selectLabel.textContent = "Available Variables";
        selectLabel.setAttribute('for', 'variables-select');
        selectLabel.style.marginRight = '10px'; // Add margin to the right side of the label
        modal.appendChild(selectLabel);

        var selectBox = document.createElement('select');
        selectBox.id = 'variables-select';
        // Get all current node labels
        var currentLabels = cy.nodes().map(node => node.data('label'));

        columnNamesGlobal.forEach(function (columnName) {
            // Only add as option if not already a node label
            if (!currentLabels.includes(columnName)) {
                var option = document.createElement('option');
                option.value = columnName;
                option.textContent = columnName;
                selectBox.appendChild(option);
            }
        });
        modal.appendChild(selectBox);
        var lineBreak = document.createElement('br');
        modal.appendChild(lineBreak);
    }

    var inputLabel = document.createElement('label');
    inputLabel.style.marginRight = '10px'; // Add margin to the right side of the label
    inputLabel.textContent = "New label";
    inputLabel.setAttribute('for', 'new-label-input');
    modal.appendChild(inputLabel);

    // Add input field under the select box
    var inputField = document.createElement('input');
    inputField.type = 'text';
    inputField.value = ""; // set the default value as empty
    inputField.id = "rename-input"
    modal.appendChild(inputField);

    var lineBreak = document.createElement('br');
    modal.appendChild(lineBreak);
    
    // Create a submit button
    var submitButton = document.createElement('button');
    submitButton.textContent = 'Submit';
    modal.appendChild(submitButton);

    // Create a cancel button
    var cancelButton = document.createElement('button');
    cancelButton.textContent = 'Cancel';
    cancelButton.style.marginLeft = '10px';
    modal.appendChild(cancelButton);

    // Add the backdrop and modal to the document
    document.body.appendChild(backdrop);
    document.body.appendChild(modal);

    //focus input field
    var field = document.getElementById("rename-input");
    field.focus();


    // Handle the submit button click
    submitButton.addEventListener('click', function () {
        handleSubmit();
    });

    // Handle the cancel button click
    cancelButton.addEventListener('click', function () {
        close();
    });

    // Handle the Enter key in the input field
    inputField.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            handleSubmit();
        }
    });

    function handleSubmit() {
        if (inputField.value !== '' || select) {
            var newLabel;
            if (inputField.value !== '') {
                newLabel = inputField.value;
            } else {
                newLabel = selectBox.value;
            }
            node.data('label', newLabel);

            if (node.hasClass('observed-variable')) {
                if (columnNamesGlobal && columnNamesGlobal.includes(newLabel)) {
                    node.addClass('linked');
                    alert('Variable connected with data set');
                } else if (node.hasClass('linked')) {
                    node.removeClass('linked');
                    alert('Variable disconnected');
                }
            }
        }
        close();
    }
    function close() {
        // Remove the modal and backdrop from the document
        document.body.removeChild(modal);
        document.body.removeChild(backdrop);
    }
},

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