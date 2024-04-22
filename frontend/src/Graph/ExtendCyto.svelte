<script>
    import cytoscape from "cytoscape";
    import * as Constants from "./classNames.js";
    import { ur } from "../stores.js";

    // Edges

    cytoscape("collection", "init", function () {
        this.addClass(Constants.FREE)
            .addClass(Constants.NOT_LABEL)
            .addClass(Constants.FROM_USER);
        return this;
    });

    cytoscape("collection", "free", function () {
        return this.hasClass(Constants.FREE);
    });

    cytoscape("collection", "addLabel", function (label) {
        this.addLabelImport(label).removeClass(Constants.BY_LAV);
        return this;
    });

    cytoscape("collection", "addLabelImport", function (label) {
        this.data("label", label)
            .addClass(Constants.LABEL)
            .removeClass(Constants.NOT_LABEL);
        return this;
    });

    cytoscape("collection", "removeLabel", function () {
        this.removeClass(Constants.LABEL)
            .addClass(Constants.NOT_LABEL)
            .data("label", undefined);
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
            .removeClass(Constants.FREE)
            .removeClass(Constants.FORCE_FREE)
            .removeClass(Constants.HAS_EST)
            .addClass(Constants.FIXED);
        return this;
    });

    cytoscape("collection", "freePara", function () {
        this.removeClass(Constants.FIXED)
            .removeClass(Constants.FORCE_FREE)
            .removeClass(Constants.BY_LAV)
            .addClass(Constants.FREE);
        return this;
    });

    cytoscape("collection", "setFree", function () {
        this.removeClass(Constants.FIXED)
            .removeClass(Constants.FORCE_FREE)
            .addClass(Constants.FREE);
        return this;
    });

    cytoscape("collection", "forceFreePara", function () {
        this.removeClass(Constants.FREE)
            .removeClass(Constants.FIXED)
            .removeClass(Constants.BY_LAV)
            .addClass(Constants.FORCE_FREE);
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
        this.removeClass(Constants.DIRECTED).addClass(Constants.UNDIRECTED);
        return this;
    });

    cytoscape("collection", "setDirected", function () {
        this.removeClass(Constants.UNDIRECTED).addClass(Constants.DIRECTED);
        return this;
    });

    cytoscape("collection", "isUndirected", function () {
        return this.hasClass(Constants.UNDIRECTED);
    });

    cytoscape("collection", "isDirected", function () {
        return this.hasClass(Constants.DIRECTED);
    });

    cytoscape("collection", "makeLoop", function () {
        this.addClass(Constants.LOOP);
        return this;
    });

    cytoscape("collection", "myIsLoop", function () {
        return this.hasClass(Constants.LOOP);
    });

    cytoscape("collection", "makeMeanEdge", function () {
        this.data("isMean", "1");
        return this;
    });

    cytoscape("collection", "isMean", function () {
        return this.data("isMean") === "1" || this.isConstant();
    });

    cytoscape("collection", "makeOtherEdge", function () {
        this.data("isMean", "0");
        return this;
    });

    cytoscape("collection", "isFixed", function () {
        return this.hasClass(Constants.FIXED);
    });

    cytoscape("collection", "isFree", function () {
        return (
            this.hasClass(Constants.FREE) || this.hasClass(Constants.FORCE_FREE)
        );
    });

    cytoscape("collection", "isForceFree", function () {
        return this.hasClass(Constants.FORCE_FREE);
    });

    cytoscape("collection", "hasLabel", function () {
        return this.hasClass(Constants.LABEL);
    });

    cytoscape("collection", "isModifiedLavaan", function () {
        return this.hasClass(Constants.BY_LAV);
    });

    cytoscape("collection", "markModifiedLavaan", function () {
        this.addClass(Constants.BY_LAV);
        return this;
    });

    cytoscape("collection", "markAddedLavaan", function () {
        this.addClass(Constants.FROM_LAV).removeClass(Constants.FROM_USER);
        return this;
    });

    cytoscape("collection", "markAddedUser", function () {
        this.removeClass(Constants.FROM_LAV).addClass(Constants.FROM_USER);
        return this;
    });

    cytoscape("collection", "isUserAdded", function () {
        return this.hasClass(Constants.FROM_USER);
    });

    cytoscape("collection", "isLavaanAdded", function () {
        return this.hasClass(Constants.FROM_LAV);
    });

    cytoscape("collection", "getValue", function () {
        return this.data("value");
    });

    cytoscape("collection", "setValue", function (value) {
        this.data("value", value);
    });

    cytoscape("collection", "invalidate", function () {
        this.removeClass(Constants.VALIDATED);
        return this;
    });

    cytoscape("collection", "validate", function () {
        this.addClass(Constants.VALIDATED);
        return this;
    });

    cytoscape("collection", "isValid", function () {
        return this.hasClass(Constants.VALIDATED);
    });

    cytoscape("collection", "revertLavaanFix", function () {
        this.freePara().removeClass(Constants.BY_LAV);
    });

    cytoscape("collection", "removeEstimates", function () {
        this.removeData("estimates")
            .removeClass(Constants.HAS_EST)
            .removeClass(Constants.HAS_EST_FIXED);
        return this;
    });

    // Nodes
    cytoscape("collection", "link", function () {
        this.addClass(Constants.LINKED);
        return this;
    });

    cytoscape("collection", "unlink", function () {
        this.removeClass(Constants.LINKED);
        return this;
    });

    cytoscape("collection", "isLinked", function () {
        return this.hasClass(Constants.LINKED);
    });

    cytoscape("collection", "isLatent", function () {
        return this.hasClass(Constants.LATENT);
    });

    cytoscape("collection", "makeLatent", function () {
        this.removeClass(Constants.OBSERVED)
            .addClass(Constants.LATENT)
            .removeClass(Constants.LINKED);
        return this;
    });

    cytoscape("collection", "makeObserved", function () {
        this.addClass(Constants.OBSERVED).removeClass(Constants.LATENT);
        return this;
    });

    cytoscape("collection", "makeOrdered", function () {
        this.removeClass(Constants.CONTINOUS).addClass(Constants.ORDERED);
        return this;
    });

    cytoscape("collection", "isOrdered", function () {
        return this.hasClass(Constants.ORDERED);
    });

    cytoscape("collection", "makeContinous", function () {
        this.addClass(Constants.CONTINOUS).removeClass(Constants.ORDERED);
        return this;
    });

    cytoscape("collection", "isConstant", function () {
        return this.hasClass(Constants.CONSTANT);
    });

    cytoscape("collection", "isObserved", function () {
        return this.hasClass(Constants.OBSERVED);
    });

    // Core functions
    cytoscape("core", "getLavaanNodes", function () {
        return this.nodes(`.${Constants.FROM_LAV}`);
    });

    cytoscape("core", "getLavaanEdges", function () {
        return this.edges(`.${Constants.FROM_LAV}`);
    });

    cytoscape("core", "getObservedNodes", function () {
        return this.nodes(`.${Constants.OBSERVED}`);
    });

    cytoscape("core", "getUserEdges", function () {
        return this.edges(`.${Constants.FROM_USER}`);
    });

    cytoscape("core", "getLavaanModifiedEdges", function () {
        return this.edges(`.${Constants.BY_LAV}`);
    });

    cytoscape("core", "getLatentNodes", function () {
        return this.nodes(function (node) {
            return node.hasClass(Constants.LATENT);
        });
    });
</script>
