<script>
  import undoRedo from "cytoscape-undo-redo";
  import { onMount } from "svelte";
  import cytoscape from "cytoscape";

  import { cyStore, ur } from "../stores.js";
  import { get } from "svelte/store";
  let cy = get(cyStore);

  function arraysToObject(keys, values) {
    const obj = {};

    keys.forEach((key, index) => {
      obj[key] = values[index];
    });
    return obj;
  }

  onMount(() => {
    cytoscape.use(undoRedo);
    const options = { isDebug: true };
    let urLocal = cy.undoRedo(options);
    ur.set(urLocal);

    urLocal.action(
      "style",
      function (args) {
        // Store the original width before changing
        let originalStyles = {};
        const keys = Object.keys(args.style);
        args.eles.forEach(function (ele) {
          // For each element, save its style properties
          let styleValues = [];
          keys.forEach((key) => {
            styleValues.push(ele.style(key));
          });
          originalStyles[ele.id()] = arraysToObject(keys, styleValues);
          ele.style(args.style);
        });
        // Return the original width for the undo action
        return {
          eles: args.eles,
          style: originalStyles,
        };
      },
      function (args) {
        // Use the original width to undo the resizing
        const newStyle = args.eles[0].style();
        Object.keys(args.style).forEach(function (id) {
          var ele = cy.getElementById(id);
          ele.style(args.style[id]);
        });
        return {
          eles: args.eles,
          style: newStyle,
        };
      },
    );

    document.addEventListener("keydown", function (e) {
      if ((e.ctrlKey || e.metaKey) && e.target.nodeName === "BODY") {
        e.preventDefault();
        e.stopPropagation();
        if (e.which === 90) $ur.undo();
        else if (e.which === 89) $ur.redo();
      }
    });

    // needed for safari https://stackoverflow.com/questions/32957841/intercepting-cmdz-cmdshiftz-and-cmdy-in-safari
    document.addEventListener("keyup", function (e) {
      if (e.metaKey && e.target.nodeName === "BODY")
        if (e.which === 90 || e.which === 89) {
          e.preventDefault();
          e.stopPropagation();
        }
    });
  });
</script>
