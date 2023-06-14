let loadedFileName = '';


document.querySelectorAll('.menu > ul > li').forEach(item => {
    item.addEventListener('mouseenter', event => {
        const submenu = item.querySelector('.submenu');
        if (submenu) {
            submenu.style.display = 'block';
            
            // Additionally set display block to submenu's li and a elements
            const submenuItems = submenu.querySelectorAll('li, a');
            submenuItems.forEach(submenuItem => {
                submenuItem.style.display = 'block';
            });
        }
    });

    item.addEventListener('mouseleave', event => {
        const submenu = item.querySelector('.submenu');
        if (submenu) {
            submenu.style.display = 'none';

            // Additionally set display none to submenu's li and a elements
            const submenuItems = submenu.querySelectorAll('li, a');
            submenuItems.forEach(submenuItem => {
                submenuItem.style.display = 'none';
            });
        }
    });
});


document.getElementById("btnAdd").addEventListener("click", () => moveOption("availableVariables", "selectedVariables"));
document.getElementById("btnRemove").addEventListener("click", () => moveOption("selectedVariables", "availableVariables"));
document.getElementById("btnDone").addEventListener("click", () => document.getElementById("modal").style.display = "none");
document.getElementById("closeModal").addEventListener("click", () => document.getElementById("modal").style.display = "none");

document.getElementById("loadDataMenuItem").addEventListener("click", handleLoadDataMenuClick);

function handleLoadDataMenuClick() {
    const fileInput = document.getElementById("fileInput");
    fileInput.click();
    fileInput.onchange = handleFileSelect;
}

function handleFileSelect(event) {
    const file = event.target.files[0];
    if (file) {
        // Set the global variable to the name of the loaded file
        loadedFileName = file.name;

        const reader = new FileReader();
        reader.onload = function(e) {
            const csv = e.target.result;
            const lines = csv.split("\n");
            const headers = lines[0].split(",").map(header => header.replace(/^"|"$/g, ''));
            displayVariableSelection(headers);
        };
        reader.readAsText(file);
    }
}

function displayVariableSelection(variables) {
    $("#cy").css("pointer-events", "none");
    const availableVariables = document.getElementById("availableVariables");
    availableVariables.innerHTML = ""; // Clear any existing options
    variables.forEach(variable => {
        const option = document.createElement("option");
        option.textContent = variable;
        option.value = variable;
        availableVariables.appendChild(option);
    });
    document.getElementById("modal").style.display = "block";
}

function moveOption(fromSelectId, toSelectId) {
    const fromSelect = document.getElementById(fromSelectId);
    const toSelect = document.getElementById(toSelectId);
    
    // Loop through all options in the select element
    for (let i = fromSelect.options.length - 1; i >= 0; i--) {
        const option = fromSelect.options[i];
        if (option.selected) {
            // Remove option from current select and add to the other select
            fromSelect.remove(i);
            toSelect.add(option);
        }
    }
}


document.getElementById("btnDone").addEventListener("click", () => {
    document.getElementById("modal").style.display = "none";
    updateChosenVariablesBox("test");
    $("#cy").css("pointer-events", "all");
});

let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
document.getElementById("chosenVariablesHeader").onmousedown = dragMouseDown;

function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    document.onmousemove = elementDrag;
}

function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    const box = document.getElementById("chosenVariablesBox");
    box.style.top = (box.offsetTop - pos2) + "px";
    box.style.left = (box.offsetLeft - pos1) + "px";
}

function closeDragElement() {
    document.onmouseup = null;
    document.onmousemove = null;
}

function updateChosenVariablesBox(datasetName) {
    const chosenVariables = document.getElementById("selectedVariables").options;
    const chosenVariablesList = document.getElementById("chosenVariablesList");
    chosenVariablesList.innerHTML = "";
    for (let i = 0; i < chosenVariables.length; i++) {
        const li = document.createElement("li");
        li.textContent = chosenVariables[i].value;
        chosenVariablesList.appendChild(li);
    }
    document.getElementById("chosenVariablesHeader").textContent = datasetName;
    document.getElementById("chosenVariablesBox").style.display = "block";
}

document.querySelectorAll('.checkmark-container').forEach(item => {
    item.addEventListener('click', event => {
        let isSelected = item.getAttribute('data-selected') === 'true';
        item.setAttribute('data-selected', !isSelected);

        let checkmark = item.querySelector('.checkmark');
        if (!isSelected) {
            checkmark.textContent = '✔';
        } else {
            checkmark.textContent = '';
        }
    });
    handleItemChange(item)
});

function handleItemChange(item) {
    // Build the string based on selected items
    let outputString = 'Hallo';

    const wordMapping = {
        'Show Estimate': 'world',
        'Show pvalue': 'suckers,',
        'Show standard error': 'Each',
        'Show confidence interval': 'item'
    };

    document.querySelectorAll('.checkmark-container').forEach(item => {
        let label = item.querySelector('label').textContent;
        let isSelected = item.getAttribute('data-selected') === 'true';

        if (isSelected) {
            outputString += ' ' + wordMapping[label];
        }
    });

    // Set the content of the output element to the generated string
    console.log(outputString)
}



