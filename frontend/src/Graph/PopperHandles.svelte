<script>
    import { get } from "svelte/store";
    import { ehStore, cyStore } from "../stores.js";
    import cytoscape from "cytoscape";
    import cytoscapePopper from "cytoscape-popper";
    import { computePosition, flip, shift, limitShift } from "@floating-ui/dom";
    import { onMount } from "svelte";
    let cy = get(cyStore);
    let eh = get(ehStore);

    function popperFactory(ref, content, opts) {
        // see https://floating-ui.com/docs/computePosition#options
        const popperOptions = {
            // matching the default behaviour from Popper@2
            // https://floating-ui.com/docs/migration#configure-middleware
            middleware: [flip(), shift({ limiter: limitShift() })],
            ...opts,
        };

        function update() {
            computePosition(ref, content, popperOptions).then(({ x, y }) => {
                Object.assign(content.style, {
                    left: `${x}px`,
                    top: `${y}px`,
                });
            });
        }
        update();
        return { update };
    }

    cytoscape.use(cytoscapePopper(popperFactory));

    let popperNode;
    let popperDiv;
    let popper;

    function start() {
        eh.start(popperNode);
    }

    function removeHandle() {
        // Remove all popperDiv elements from the DOM
        popperDivs.forEach((popperDiv) => {
            if (popperDiv) {
                document.body.removeChild(popperDiv);
            }
        });
        popperDivs = []; // Clear the popperDivs array

        popperNode = null;
    }

    let poppers = [];
    let popperDivs = [];

    function setHandleOn(node) {
        popperNode = node;
        const handleSize = 10 * cy.zoom() + "px";

        const placements = ["top", "bottom", "left", "right"];
        const offsets = {
            top: [0, -10],
            bottom: [0, 10],
            left: [-10, 0],
            right: [10, 0],
        };

        placements.forEach((placement) => {
            let popperDiv = document.createElement("div");
            popperDiv.classList.add("popper-handle", placement);
            popperDiv.addEventListener("mousedown", start);
            document.body.appendChild(popperDiv);
            popperDiv.style.width = handleSize;
            popperDiv.style.height = handleSize;

            const popperInstance = node.popper({
                content: popperDiv,
                popper: {
                    placement: placement,
                    modifiers: [
                        {
                            name: "offset",
                            options: {
                                offset: offsets[placement],
                            },
                        },
                    ],
                },
            });

            popperDivs.push(popperDiv); // Store each popperDiv
            poppers.push(popperInstance); // Store each popper instance
        });
    }

    onMount(() => {
        // create a basic popper on the first node
        cy.on("mouseover", "node", function (e) {
            console.log(e.target);
            setHandleOn(e.target);
        });

        cy.on("grab", "node", function () {
            removeHandle();
        });

        cy.on("tap", function (e) {
            if (e.target === cy) {
                removeHandle();
            }
        });

        cy.on("mouseout", "node", function (e) {
            removeHandle();
        });

        cy.on("zoom pan", function () {
            removeHandle();
        });
    });
</script>
