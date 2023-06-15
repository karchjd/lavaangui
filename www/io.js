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

let loadingmode = false;
document.getElementById("loadDiagramMenuItem").addEventListener('click', function () {
    var input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json'

    input.onchange = e => { 
        var file = e.target.files[0]; 

        var reader = new FileReader();
        reader.readAsText(file,'UTF-8');

        reader.onload = readerEvent => {
            var content = readerEvent.target.result; 
            var json = JSON.parse(content);
            loadingmode = true;
            cy.json(json);
            cy.style(myStyle);
            nodes = cy.nodes()
            for (i = 0; i < nodes.length; i++) {
                console.log(nodes[i].data('label'))
                checkNodeLoop(nodes[i].id())
            }
            loadingmode = false;
        }
    }
    input.click();
});

document.getElementById("loadDataMenuItem").addEventListener("click", function() {
    document.getElementById("fileInput").click();
});