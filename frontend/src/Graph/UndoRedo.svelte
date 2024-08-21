<script>
  import undoRedo from "cytoscape-undo-redo";
  import { onMount } from "svelte";
  import cytoscape from "cytoscape";

  import { cyStore, ur, modelOptions, appState } from "../stores.js";
  import { get } from "svelte/store";
  import { tolavaan } from "../Shiny/toR.js";
  let cy = get(cyStore);

  function arraysToObject(keys, values) {
    const obj = {};

    keys.forEach((key, index) => {
      obj[key] = values[index];
    });
    return obj;
  }

  function subsetObjectByKeys(obj, keysObj) {
    const keys = Object.keys(keysObj);
    let subset = {};

    keys.forEach((key) => {
      if (obj.hasOwnProperty(key)) {
        subset[key] = obj[key];
      }
    });

    return subset;
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
            styleValues.push(ele.data(key) || ele.style(key));
            ele.data(key, args.style[key]);
          });
          originalStyles[ele.id()] = arraysToObject(keys, styleValues);
        });
        return {
          eles: args.eles,
          style: originalStyles,
        };
      },
      function (args) {
        const newStyle = subsetObjectByKeys(
          args.eles[0].style(),
          args.style[Object.keys(args.style)[0]],
        );
        Object.keys(args.style).forEach(function (id) {
          var ele = cy.getElementById(id);
          for (var key in args.style[id]) {
            ele.data(key, args.style[id][key]);
          }
        });
        return {
          eles: args.eles,
          style: newStyle,
        };
      },
    );

    cy.on("afterUndo", function (e, name) {
      if (name !== "style" && name !== "move") {
        tolavaan($modelOptions.mode);
      }
    });

    cy.on("afterRedo", function (e, name) {
      if (name !== "style" && name !== "move") {
        tolavaan($modelOptions.mode);
      }
    });

    document.addEventListener("keydown", function (e) {
      if (
        (e.ctrlKey || e.metaKey) &&
        e.target.nodeName === "BODY" &&
        e.which === 90 &&
        !$appState.fitting
      ) {
        e.preventDefault();
        e.stopPropagation();
        if (e.shiftKey) $ur.redo();
        else $ur.undo();
      }
    });

    // needed for safari https://stackoverflow.com/questions/32957841/intercepting-cmdz-cmdshiftz-and-cmdy-in-safari
    document.addEventListener("keyup", function (e) {
      if (e.metaKey && e.target.nodeName === "BODY" && e.which === 90) {
        e.preventDefault();
        e.stopPropagation();
      }
    });
  });
</script>
