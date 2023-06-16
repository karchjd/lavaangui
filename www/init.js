myStyle = [
    {
        selector: 'node',
        style: {
            'width': '80', // Set the width of the nodes to 80
            'height': '80', // Set the height of the nodes to 80
            'background-color': 'white',
            'border-color': 'grey',
            'border-width': '2px', // Set border width of nodes to 2 pixels
            'label': 'data(label)', // Use the 'label' property from the data for the node's label
            'text-valign': 'center',
            'text-halign': 'center'
        }
    },
    {
        selector: 'node.observed-variable',
        style: {
            'shape': 'rectangle',
        }
    },
    {
        selector: 'node.latent-variable',
        style: {
            'shape': 'ellipse',
            'border-color': 'black',
        }
    },
    {
        selector: 'node.constant',
        style: {
            'shape': 'triangle',
            'label': '1',
            'text-valign': 'center',
            'text-margin-y': '10px',
            'border-color': 'black',
        }
    },
    {
        selector: 'node.linked',
        style: {
            'border-color': 'black'
        }
    },
    {
        selector: 'edge',
        style: {
            'width': 3,
            'line-color': '#000',
            'target-arrow-color': '#000', // Set target arrow color to black
            'source-arrow-color': '#000', // Set target arrow color to black
            'target-arrow-shape': 'triangle',
            'curve-style': 'bezier',
            'text-valign': 'center',
            'text-halign': 'center',
            'text-wrap': 'wrap',
            'text-max-width': 80,
            'font-size': '14px',
            'z-index': 10,
            'color': '#000',
            'text-outline-color': '#fff',
            'text-outline-width': '2px',
            'text-background-color': '#fff',
            'text-background-opacity': 1,
            'text-background-padding': '4px'
        }
    },
    {
        selector: 'edge.loop',
        style: {
            'curve-style': 'unbundled-bezier',
            'control-point-distances': [50],
            'control-point-weights': [0.5],
            'loop-direction': '0', // -Math.PI / 2 in radians to position at top
            'loop-sweep': '0.8', // rounding of the loop, in radians
            'target-arrow-shape': 'triangle',
            'source-arrow-shape': 'triangle',
            'target-arrow-fill': 'filled',
            'source-arrow-fill': 'filled',
            'target-arrow-color': '#000',
            'source-arrow-color': '#000'
        }
    },
    {
        selector: 'edge.undirected',
        style: {
            'curve-style': 'unbundled-bezier',
            'control-point-distances': [100],
            'control-point-weights': [0.5],
            'target-arrow-shape': 'triangle',
            'source-arrow-shape': 'triangle'
        }
    },
    {
        selector: 'edge.free.label, edge.forcefree.label',
        style: {
            'label': function(edge) {
                return edge.data('label');
            }
        }
    },
    {
        selector: 'edge.fixed.label',
        style: {
            'label': function(edge) {
                return edge.data('label') + '@' + edge.data('value');
            }
        }
    },
    {
        selector: 'edge.fixed.nolabel',
        style: {
            'label': function(edge) {
                return '@' + edge.data('value');
            }
        }
    },
    {
        selector: 'edge.hasEst.free.nolabel, edge.hasEst.forcefree.nolabel',
        style: {
            'label': function(edge) {
                return edge.data('est');
            }
        }
    },
    {
        selector: 'edge.hasEst.free.label, edge.hasEst.forcefree.label',
        style: {
            'label': function(edge) {
                return edge.data('label') + '=' + edge.data('est');
            }
        }
    },
    {
        selector: 'edge.forcefree',
        style: {
            'line-color': 'blue'
        }
    }
]

// Initialize the Cytoscape instance
var cy = cytoscape({
    container: $('#cy'), 
    elements: [],
    autoungrabify: false,
    autolock: false,
    style: myStyle
});

cy.nodeEditing({
    resizeToContentCueImage: 'resizeCue.svg',
    autoRemoveResizeToContentCue: true,
});

// Set cursor style to initial when resizing ends
cy.on("nodeediting.resizeend", function (e, type) {
    $('body').css('cursor', 'initial'); 
});

var layout = cy.layout({ name: 'grid' });

// Initialize edgehandles extension
var eh = cy.edgehandles({
    preview: false, // disables the ghost edge preview
    hoverDelay: 150, // time spend over a target node before it's considered a hover
    handleNodes: 'node', // selector/filter for whether edges can be made from a given node
    snap: true, // when enabled, the edge can be drawn by just moving close to a target node (can be confusing on compound graphs because you don't need to actually start on the node itself to start drawing)
    handleColor: '#ff0000', // bright red
    handleSize: 10, // increase the size
    canConnect: function (sourceNode, targetNode) {
        // Allow connection if it doesn't create a parallel edge
        return !cy.elements('edge[source = "' + sourceNode.id() + '"][target = "' + targetNode.id() + '"]').length;
    }
});

const appState = {
    columnNamesGlobal: null,
    loadedFileName: null,
    loadingMode: false,
    runCounter: 0,
    setColumnNamesGlobal: function(value) {
      this.columnNamesGlobal = value;
    },
    getColumnNamesGlobal: function() {
      return this.columnNamesGlobal;
    },
    setLoadedFileName: function(value) {
      this.loadedFileName = value;
    },
    getLoadedFileName: function() {
      return this.loadedFileName;
    },
    setLoadingMode: function(value) {
      this.loadingMode = value;
    },
    isLoadingMode: function() {
      return this.loadingMode;
    },
    increaseRun: function() {
        return this.runCounter++;;
    }
  };
  