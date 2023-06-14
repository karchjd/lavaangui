var options = {
    isDebug: false, // Debug mode for console messages
    actions: {},// actions to be added
    undoableDrag: true, // Whether dragging nodes are undoable can be a function as well
    stackSizeLimit: undefined, // Size limit of undo stack, note that the size of redo stack cannot exceed size of undo stack
    ready: function () { // callback when undo-redo is ready

    }
}

var ur = cy.undoRedo(options); // Can also be set whenever wanted.

// document.addEventListener("keydown", function (e) {
// if ((e.ctrlKey || e.metaKey) && e.target.nodeName === 'BODY')
//         if (e.which === 90)
//             ur.undo();
//         else if (e.which === 89)
//             ur.redo();

// });