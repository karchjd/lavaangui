document.getElementById("saveDiagramMenuItem").addEventListener('click', function () {
    var json = cy.json();
    var str = JSON.stringify(json);
    var blob = new Blob([str], {type: "application/json;charset=utf-8"});
    var url = URL.createObjectURL(blob);

    var a = document.createElement('a');
    a.href = url;
    a.download = 'diagram.json';
    a.click();
});

document.getElementById("loadDiagramMenuItem").addEventListener('click', function () {
    var input = document.createElement('input');
    input.type = 'file';

    input.onchange = e => { 
        var file = e.target.files[0]; 

        var reader = new FileReader();
        reader.readAsText(file,'UTF-8');

        reader.onload = readerEvent => {
            var content = readerEvent.target.result; 
            var json = JSON.parse(content);
            cy.json(json);
            cy.style(myStyle);
        }
    }

    input.click();
});