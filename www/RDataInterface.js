
Shiny.addCustomMessageHandler('columnNames', function (columnNames) {
  applyLinkedClass(columnNames);
  appState.setColumnNamesGlobal(columnNames);
});

Shiny.addCustomMessageHandler('fname', function (fname) {
  appState.setLoadedFileName(fname);
});

function applyLinkedClass(columnNames) {
  const nodes = cy.nodes(function (node) {
    return node.hasClass("observed-variable")
  });
  if (nodes.length > 0) {
    let all_linked = true;
    for (var i = 0; i < nodes.length; i++) {
      const node = nodes[i];
      const label = node.data("label");
      node.removeClass("linked")
      if (columnNames.includes(label)) {
        node.addClass("linked");
      } else {
        all_linked = false;
      }
    }
    if (all_linked) {
      alert("All observed variables were linked with data")
    }
  }
}