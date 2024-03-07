<script>
    import cytoscape from "cytoscape";
    import * as Constants from "./classNames.js";

    //Edges

    cytoscape("collection", "init", function () {
        this.addClass("free").addClass("notlabel").addClass("fromUser");
        return this;
    });

    cytoscape("collection", "free", function () {
        return this.hasClass("free");
    });

    cytoscape("collection", "addLabel", function (label) {
        this.addLabelImport(label).removeClass("byLav");
        return this;
    });

    cytoscape("collection", "addLabelImport", function (label) {
        this.data("label", label).addClass("label").removeClass("nolabel");
        return this;
    });

    cytoscape("collection", "removeLabel", function () {
        this.removeClass("label").addClass("nolabel").data("label", undefined);
        return this;
    });

    cytoscape("collection", "setLabel", function (label) {
        this.data("label", label);
        return this;
    });

    cytoscape("collection", "getLabel", function () {
        return this.data("label");
    });

    cytoscape("collection", "fixPara", function (value) {
        this.data("value", value)
            .removeClass("free")
            .removeClass("forcefree")
            .removeClass("hasEst")
            .addClass("fixed");
        return this;
    });

    cytoscape("collection", "freePara", function () {
        this.removeClass("fixed")
            .removeClass("forcefree")
            .removeClass("byLav")
            .addClass("free");
        return this;
    });

    cytoscape("collection", "setFree", function () {
        this.removeClass("fixed").removeClass("forcefree").addClass("free");
        return this;
    });

    cytoscape("collection", "forceFreePara", function () {
        this.removeClass("free")
            .removeClass("fixed")
            .removeClass("byLav")
            .addClass("forcefree");
        return this;
    });

    cytoscape("collection", "revert", function () {
        const sourceId = this.source().id();
        const targetId = this.target().id();
        this.move({
            source: targetId,
            target: sourceId,
        });
        return this;
    });

    cytoscape("collection", "setUndirected", function () {
        this.removeClass("directed").addClass("undirected");
        return this;
    });

    cytoscape("collection", "setDirected", function () {
        this.removeClass("undirected").addClass("directed");
        return this;
    });

    cytoscape("collection", "isUndirected", function () {
        return this.hasClass("undirected");
    });

    cytoscape("collection", "isDirected", function () {
        return this.hasClass("directed");
    });

    cytoscape("collection", "makeLoop", function () {
        this.addClass("loop");
        return this;
    });

    cytoscape("collection", "myIsLoop", function () {
        return this.hasClass("loop");
    });

    cytoscape("collection", "isFixed", function () {
        return this.hasClass("fixed");
    });

    cytoscape("collection", "isForceFree", function (label) {
        return this.hasClass("forcefree");
    });

    cytoscape("collection", "hasLabel", function (label) {
        return this.hasClass("label");
    });

    cytoscape("collection", "isModifiedLavaan", function () {
        return this.hasClass("byLav");
    });

    cytoscape("collection", "markModifiedLavaan", function () {
        this.addClass("byLav");
        return this;
    });

    cytoscape("collection", "markAddedLavaan", function () {
        this.addClass("fromLav").removeClass("fromUser");
        return this;
    });

    cytoscape("collection", "markAddedUser", function () {
        this.removeClass("fromLav").addClass("fromUser");
        return this;
    });

    cytoscape("collection", "isUserAdded", function () {
        return this.hasClass("fromUser");
    });

    cytoscape("collection", "getValue", function () {
        return this.data("value");
    });

    cytoscape("collection", "invalidate", function () {
        this.removeClass("validated");
        return this;
    });

    cytoscape("collection", "validate", function () {
        this.addClass("validated");
        return this;
    });

    cytoscape("collection", "isValid", function () {
        return this.hasClass("validated");
    });

    cytoscape("collection", "revertLavaanFix", function () {
        this.freePara().removeClass("byLav");
    });

    cytoscape("collection", "removeEstimates", function () {
        this.removeData("est").removeClass("hasEst");
        return this;
    });

    // Nodes
    cytoscape("collection", "link", function () {
        this.addClass("linked");
        return this;
    });

    cytoscape("collection", "unlink", function () {
        this.removeClass("linked");
        return this;
    });

    cytoscape("collection", "isLinked", function () {
        return this.hasClass("linked");
    });

    cytoscape("collection", "isLatent", function () {
        return this.hasClass("latent-variable");
    });

    cytoscape("collection", "makeLatent", function () {
        this.removeClass("observed-variable")
            .addClass("latent-variable")
            .removeClass("linked");
        return this;
    });

    cytoscape("collection", "makeObserved", function () {
        this.addClass("observed-variable").removeClass("latent-variable");
        return this;
    });

    cytoscape("collection", "makeOrdered", function () {
        this.removeClass("continous").addClass("ordered");
        return this;
    });

    cytoscape("collection", "isOrdered", function () {
        return this.hasClass("ordered");
    });

    cytoscape("collection", "makeContinous", function () {
        this.addClass("continous").removeClass("ordered");
        return this;
    });

    cytoscape("collection", "isConstant", function () {
        return this.hasClass("constant");
    });

    cytoscape("collection", "isObserved", function () {
        return this.hasClass("observed-variable");
    });

    // core functions
    cytoscape("core", "getLavaanNodes", function () {
        return this.nodes(".fromLav");
    });

    cytoscape("core", "getUserEdges", function () {
        return this.edges(".fromUser");
    });

    cytoscape("core", "getLavaanModifiedEdges", function () {
        return this.edges(".byLav");
    });

    cytoscape("core", "getLatentNodes", function () {
        return this.nodes(function (node) {
            return node.hasClass("latent-variable");
        });
    });
</script>
