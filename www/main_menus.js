

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

document.getElementById("help-menu-item").addEventListener('click', function(event) {
    event.preventDefault(); // Prevent the default action of the link

    // Help content
    var helpContent = [
        "Hold command or ctrl: draw directed arrows",
        "Hold space: draw undirected arrows (currently disabled because of bug)",
        "Backspace: delete selected elements",
        "o: create observed variable at mouse location",
        "l: create latent variable at mouse location",
        "c: create constant variable at mouse location"
    ].join('\n'); // Join the array into a single string, separating each item with a newline character

    // Show the alert
    alert(helpContent);
});


document.getElementById("loadDataMenuItem").addEventListener("click", function() {
    document.getElementById("fileInput").click();
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



