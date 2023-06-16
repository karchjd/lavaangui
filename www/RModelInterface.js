function containsObject(list, obj) {
    for (let i = 0; i < list.length; i++) {
        if (list[i] === obj) {
            return true;
        }
    }
    return false;
}

function addTerms(node, edge) {
    let node_label;
    if (node == undefined) {
        node_label = "1";
    } else {
        node_label = node.data('label');
    }
    let premultiplier = false;
    let formula;
    if (edge.hasClass("fixed")) {
        formula = edge.data('value') + "*" + node_label;
        premultiplier = true;
    } else if (edge.hasClass("forcefree")) {
        formula = "NA*" + node_label;
        premultiplier = true;
    }

    if (edge.hasClass("label")) {
        label = edge.data('label');
        if (!premultiplier) {
            formula = label + "*" + node_label;
        } else {
            formula += " + " + label + "*" + node_label;
        }
    } else {
        if (!premultiplier) {
            formula = node_label;
        } else {
            formula += " + " + node_label;
        }
    }
    return formula
}

function createSyntax(run) {
    let syntax = "";
    let R_script = "";
    if (!run) {
        if (appState.getLoadedFileName() == null) {
            loadedFileName = "YOUR_DATA.csv"
        }
        R_script += "library(lavaan)" + "\n";
        R_script += "data <- read.csv(" + appState.getLoadedFileName() + ")" + "\n";
    }

    // measurement model
    const latentNodes = cy.nodes(function (node) { return node.hasClass('latent-variable') });
    let shown = false;
    for (let i = 0; i < latentNodes.length; i++) {
        const latentNode = latentNodes[i];
        let nodeNames = "";
        const connectedEdges = latentNode.connectedEdges(function (edge) {
            return edge.hasClass('directed') && (edge.source().id() == latentNode.id() && edge.target().hasClass('observed-variable'))
        });
        if (connectedEdges.length > 0) {
            if (!shown) {
                syntax += "# measurement model" + '\n '
                shown = true;
            }
            for (let j = 0; j < connectedEdges.length; j++) {
                const node = connectedEdges[j].target();
                if (j > 0) {
                    nodeNames += " + ";
                }

                nodeNames += addTerms(node, connectedEdges[j]);
            }
            syntax += latentNode.data('label') + ' =~ ' + nodeNames + '\n ';
        }
    }

    // regression
    reg_edges = cy.edges(function (edge) {
        res = edge.hasClass("directed") &&
            !edge.source().hasClass("constant") &&
            !(edge.source().hasClass("latent-variable") && edge.target().hasClass("observed-variable"));
        return res;
    })
    reg_nodes = [];
    for (let i = 0; i < reg_edges.length; i++) {
        if (!containsObject(reg_nodes, reg_edges[i].target())) {
            reg_nodes.push(reg_edges[i].target())
        }
    };

    if (reg_nodes.length > 0) {
        syntax += '\n' + "# regressions" + '\n'
        for (let i = 0; i < reg_nodes.length; i++) {
            const targetNode = reg_nodes[i];
            const connectedEdges = targetNode.connectedEdges(function (edge) {
                return edge.hasClass('directed') && edge.target().id() == targetNode.id()
            });
            if (connectedEdges.length > 0) {
                let nodeNames = "";
                for (var j = 0; j < connectedEdges.length; j++) {
                    var node = connectedEdges[j].source();
                    if (j > 0) {
                        nodeNames += " + ";
                    }
                    nodeNames += addTerms(node, connectedEdges[j]);
                }
                syntax += targetNode.data('label') + ' ~ ' + nodeNames + '\n ';
            }
        }
    }


    // covariances
    cov_edges = cy.edges(function (edge) { return edge.hasClass("undirected") || edge.hasClass("loop") })
    if (cov_edges.length > 0) {
        let nodeNames = "";
        syntax += '\n' + "# residual (co)variances" + '\n'
        for (let i = 0; i < cov_edges.length; i++) {
            node1 = cov_edges[i].source().data('label');
            node2 = cov_edges[i].target().data('label');
            syntax += node1 + ' ~~ ' + addTerms(cov_edges[i].target(), cov_edges[i]) + '\n ';
        }
    }

    // mean structure
    constant_nodes = cy.nodes(function (node) { return node.hasClass('constant') });
    for (let i = 0; i < constant_nodes.length; i++) {
        c_node = constant_nodes[i];
        const connectedEdges = c_node.connectedEdges();
        if (connectedEdges.length > 0) {
            syntax += "# intercepts" + '\n '
            for (var j = 0; j < connectedEdges.length; j++) {
                var node = connectedEdges[j].target();
                syntax += node.data('label') + ' ~ ' + addTerms(undefined, connectedEdges[j]) + '\n';
            }
        }
    }
    R_script += "model = '\n" + syntax + "'" + "\n "
    R_script += "result <- sem(model, data)" + "\n "
    return R_script
};

function tolavaan(run) {
    if (run) {
         const nodes = cy.nodes(function (node) {
            return node.hasClass("observed-variable")
        });
        for (var i = 0; i < nodes.length; i++) {
            const node = nodes[i];
            if (!node.hasClass("linked")) {
                alert("Observed variable " + node.data('label') + " is not linked to data. Cannot run.")
                return
            }
        }
        const edges = cy.edges()
        for (var i = 0; i < edges.length; i++) {
            edges[i].removeData('est');
            edges[i].removeClass('hasEst');
        }
    }
    R_script = createSyntax(run)
    Shiny.setInputValue("run", run);
    Shiny.setInputValue("R_script", R_script);
    Shiny.setInputValue("runCounter", appState.increaseRun())
}

function findEdge(lhs, op, rhs) {
    let directed;
    let source;
    let target;

    if (op === "=~") {
        directed = "directed";
        source = lhs;
        target = rhs;
    } else {
        target = lhs;
        source = rhs;
        if (op === "~~") {
            if (lhs === rhs) {
                directed = "loop";
            } else {
                directed = "undirected";
            }
        } else if (op === "~") {
            directed = "directed";
        }
    }

    const correct_edge = cy.edges(function (edge) {
        let res = edge.source().data('label') == source && edge.target().data('label') == target
        if (directed == "undirected") {
            res = res || (edge.source().data('label') == target && edge.target().data('label') == source)
        }
        return res;
    })
    return correct_edge
}

//save all results in data attributes of the correct edges
Shiny.addCustomMessageHandler('lav_results', function (lav_result) {
    for (let i = 0; i < lav_result.lhs.length; i++) {
        edge = findEdge(lav_result.lhs[i], lav_result.op[i], lav_result.rhs[i]);
        //lavaan estimated the edge
        if(lav_result.se[i] !== 0){
            edge.data('est', lav_result.est[i].toFixed(2))
            edge.addClass('hasEst')
            edge.data('p-value', lav_result.pvalue[i].toFixed(2))
             edge.data('se', lav_result.se[i].toFixed(2))
        //lavaan did fix the edge
        }else if((Math.abs(lav_result.est[i] - 1) < 1e-9)){
            edge.addClass('fixed')
            edge.removeClass('free')
            edge.data('value', 1)
        }else{
            console.error("should never happen")
        }
    }        
});

cy.edges(function(edge) {return edge.source().data('label') == 'dem60'})