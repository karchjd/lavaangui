
cy.contextMenus({
    //core menus

    menuItems: [
        {
            id: 'add-observed',
            content: 'Add Observed Variable',
            coreAsWell: true,
            onClickFunction: function (event) {
                const position = event.position || event.cyPosition;
                addNode('observed-variable', position);
            }
        },
        {
            id: 'add-latent',
            content: 'Add Latent Variable',
            coreAsWell: true,
            onClickFunction: function (event) {
                const position = event.position || event.cyPosition;
                addNode('latent-variable', position);
            }
        },
        {
            id: 'add-constant',
            content: 'Add Constant Variable',
            coreAsWell: true,
            onClickFunction: function (event) {
                const position = event.position || event.cyPosition;
                addNode('constant', position);
            }
        },
        

        //edge menus

        {
            id: 'label-para',
            content: 'Set Label',
            selector: 'edge',
            onClickFunction: function (event) {
                const edge = event.target || event.cyTarget;
                // Check for strings that start with a letter
                // and contain only alphanumeric characters (a-z, A-Z, 0-9)
                const regex = /^[a-zA-Z][a-zA-Z0-9]*$/;

                // Ask the user for a value
                let value = prompt("Please enter a label:");

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
            hasTrailingDivider: false
        },
        {
            id: 'label-remove',
            content: 'Remove Label',
            selector: 'edge.label',
            onClickFunction: function (event) {
                const edge = event.target || event.cyTarget;
                edge.removeClass('label')
                edge.addClass('nolabel')
                edge.data('label', undefined);
            },
            hasTrailingDivider: false
        },

        {
            id: 'remove-edge',
            content: 'Delete edge',
            selector: 'edge',
            onClickFunction: function (event) {
                const edge = event.target || event.cyTarget;
                edge.remove()
            },
            hasTrailingDivider: true
        },
        {
            id: 'fix-para',
            content: 'Fix Parameter',
            selector: 'edge.free, edge.forcefree',
            onClickFunction: function (event) {
                const edge = event.target || event.cyTarget;

                // Ask the user for a value
                const value = prompt("Please enter a value:");

                // Store the value in the edge's data
                if (value !== null) { // submit was pressed
                    if(!isNaN(Number(value))){ //provided value is a number
                        edge.data('value', value);
                        edge.removeClass('free');
                        edge.removeClass('forcefree')
                        edge.addClass('fixed');
                    }else{
                        alert("Provided value: " + value + " is not a number. Please provide a number")
                    }
                }
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
            id: 'free-force-para',
            content: 'Force Parameter Free',
            selector: 'edge.free, edge.fixed',
            onClickFunction: function (event) {
                const edge = event.target || event.cyTarget;
                edge.removeClass('free');
                edge.removeClass('fixed');
                edge.addClass('forcefree');
            },
            hasTrailingDivider: true
        },
        

        {
            id: 'revert-arrow',
            content: 'Revert Direction',
            selector: 'edge[isMean="0"].directed',
            onClickFunction: function (event) {
                const edge = event.target || event.cyTarget;
                const sourceId = edge.source().id();
                const targetId = edge.target().id();
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
            id: 'set-undirected',
            content: 'Set Undirected',
            selector: 'edge[isMean="0"].directed',
            onClickFunction: function (event) {
                const edge = event.target || event.cyTarget;
                edge.removeClass("directed")
                edge.addClass("undirected")
            },
            hasTrailingDivider: true
        },

        {
            id: 'set-arrow',
            content: 'Set Directed',
            selector: 'edge.undirected',
            onClickFunction: function (event) {
                const edge = event.target || event.cyTarget;
                edge.removeClass("undirected")
                edge.addClass("directed")
            },
            hasTrailingDivider: true
        },
        

        //node menus
        {
            id: 'rename-node',
            content: 'Rename Variable',
            selector: 'node.latent-variable, node.observed-variable',
            onClickFunction: function (event) {
                const node = event.target || event.cyTarget;
                const currentLabel = node.data('label');

                // Create a backdrop
                let backdrop = document.createElement('div');
                backdrop.style.position = 'fixed';
                backdrop.style.top = 0;
                backdrop.style.left = 0;
                backdrop.style.width = '100vw';
                backdrop.style.height = '100vh';
                backdrop.style.backgroundColor = 'rgba(0, 0, 0, 0.5)'; // semi-transparent
                backdrop.style.zIndex = 1000; // ensure it's on top

                // Create a modal
                let modal = document.createElement('div');
                modal.style.position = 'fixed';
                modal.style.top = '50%';
                modal.style.left = '50%';
                modal.style.transform = 'translate(-50%, -50%)';
                modal.style.backgroundColor = 'white';
                modal.style.padding = '20px';
                modal.style.border = '1px solid #ccc';
                modal.style.zIndex = 1001; // ensure it's above the backdrop

                let select = false;
                // Add select box if columnNamesGlobal is defined
                if (typeof columnNamesGlobal !== 'undefined' && node.hasClass('observed-variable')) {
                    select = true;
                    // Add label for the select box
                    let selectLabel = document.createElement('label');
                    selectLabel.textContent = "Available Variables";
                    selectLabel.setAttribute('for', 'variables-select');
                    selectLabel.style.marginRight = '10px'; // Add margin to the right side of the label
                    modal.appendChild(selectLabel);

                    let selectBox = document.createElement('select');
                    selectBox.id = 'variables-select';
                    // Get all current node labels
                    const currentLabels = cy.nodes().map(node => node.data('label'));

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
                    const lineBreak = document.createElement('br');
                    modal.appendChild(lineBreak);
                }

                let inputLabel = document.createElement('label');
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

                const lineBreak = document.createElement('br');
                modal.appendChild(lineBreak);

                // Create a submit button
                let submitButton = document.createElement('button');
                submitButton.textContent = 'Submit';
                modal.appendChild(submitButton);

                // Create a cancel button
                let cancelButton = document.createElement('button');
                cancelButton.textContent = 'Cancel';
                cancelButton.style.marginLeft = '10px';
                modal.appendChild(cancelButton);

                // Add the backdrop and modal to the document
                document.body.appendChild(backdrop);
                document.body.appendChild(modal);

                //focus input field
                let field = document.getElementById("rename-input");
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
                        let newLabel;
                        if (inputField.value !== '') {
                            newLabel = inputField.value;
                        } else {
                            newLabel = selectBox.value;
                        }
                        node.data('label', newLabel);

                        if (node.hasClass('observed-variable')) {
                            const columnNames = appState.getColumnNamesGlobal()
                            if (columnNames && columnNames.includes(newLabel)) {
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
                const node = event.target || event.cyTarget;
                node.remove();
            },
            hasTrailingDivider: true
        },
        {
            id: 'change-latent',
            content: 'Change to Latent',
            selector: 'node.observed-variable',
            onClickFunction: function (event) {
                const node = event.target || event.cyTarget;
                node.removeClass('observed-variable');
                node.addClass('latent-variable')
            },
            hasTrailingDivider: false
        },
        
        {
            id: 'change-observed',
            content: 'Change to Observed',
            selector: 'node.latent-variable',
            onClickFunction: function (event) {
                const node = event.target || event.cyTarget;
                node.removeClass('latent-variable');
                node.addClass('observed-variable')
            }
        },
    ]
});