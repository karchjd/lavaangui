let columnNamesGlobal;
let loadedFileName;
Shiny.addCustomMessageHandler('columnNames', function (columnNames) {
    console.log(columnNamesGlobal)
    applyLinkedClass(columnNames);
    columnNamesGlobal = columnNames;
});

Shiny.addCustomMessageHandler('fname', function (fname) {
    loadedFileName = fname;
});

function applyLinkedClass(columnNames) {
    var nodes = cy.nodes(function(node){
        return node.hasClass("observed-variable")
    });
    all_linked = true;
    for (var i = 0; i < nodes.length; i++) {
      var node = nodes[i];
      var label = node.data("label");
      node.removeClass("linked")
      if (columnNames.includes(label)) {
        node.addClass("linked");
      }else{
        all_linked = false;
      }
    }
    if(all_linked){
        alert("All observed variables were linked with data")
    }
  }
  