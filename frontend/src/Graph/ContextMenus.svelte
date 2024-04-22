<script>
  import { cyStore, appState, setAlert, modelOptions, ur } from "../stores.js";
  import { get } from "svelte/store";
  let cy = get(cyStore);
  import cytoscape from "cytoscape";
  import contextMenus from "cytoscape-context-menus";
  import "cytoscape-context-menus/cytoscape-context-menus.css";
  import { onMount } from "svelte";
  import { addNode } from "./graphmanipulation.js";
  import { checkNodeLoop } from "./checkNodeLoop.js";
  import { tolavaan } from "../Shiny/toR.js";
  import * as Constants from "./classNames.js";
  import iro from "@jaames/iro";

  // register extension
  cytoscape.use(contextMenus);

  // @ts-ignore
  var colorPicker = new iro.ColorPicker("#picker", {
    width: 200,
    color: "rgb(255, 0, 0)",
    borderWidth: 1,
    borderColor: "#fff",
  });

  function isValidName(str) {
    const rVarNameRegex = /^[a-zA-Z\._][a-zA-Z0-9\._]*(?<!\.)$/;
    return rVarNameRegex.test(str);
  }

  function validLabel(str) {
    if (str == "") {
      // @ts-expect-error
      bootbox.alert("Provide a label");
      return false;
    }

    if (!isValidName(str)) {
      // @ts-expect-error
      bootbox.alert("Provide a valid label");
      return false;
    }
    return true;
  }

  function getChange(target, check) {
    var toChange;
    const selectedElements = cy.$(":selected");
    if (selectedElements.length > 1) {
      if (check === "nodes" && !selectedElements.every((ele) => ele.isNode())) {
        // @ts-ignore
        bootbox.alert("Not all selected elements are nodes. Aborting");
        return null;
      } else if (
        check === "edges" &&
        !selectedElements.every((ele) => ele.isEdge())
      ) {
        // @ts-ignore
        bootbox.alert("Not all selected elements are edges. Aborting");
        return null;
      } else if (
        check === "nodes.edges" &&
        !selectedElements.every((ele) => ele.isEdge() || ele.isNode())
      ) {
        // @ts-ignore
        bootbox.alert("Not all selected elements are nodes or edges. Aborting");
        return null;
      }
      toChange = selectedElements;
    } else {
      toChange = target;
    }
    return toChange;
  }

  const menu = [
    {
      id: "add-observed",
      content: "Add Observed Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.renderedPosition;
        addNode(Constants.OBSERVED, position);
      },
      show: "full",
    },
    {
      id: "add-latent",
      content: "Add Latent Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.renderedPosition;
        addNode(Constants.LATENT, position);
      },
      show: "full",
    },
    {
      id: "add-constant",
      content: "Add Constant Variable",
      coreAsWell: true,
      onClickFunction: function (event) {
        const position = event.renderedPosition;
        addNode(Constants.CONSTANT, position);
      },
      show: "full",
    },

    //edge menus

    {
      id: "label-para",
      content: "Add/Change Label",
      selector: `edge.${Constants.FROM_USER}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        // @ts-expect-error
        bootbox.prompt({
          title: "Enter a Label",
          callback: function (result) {
            if (!validLabel(result)) {
              return false;
            }

            if (result !== null) {
              edge.addLabel(result);
              tolavaan($modelOptions.mode);
            }
          },
        });
      },
      show: "full",
      hasTrailingDivider: false,
    },
    {
      id: "label-remove",
      content: "Remove Label",
      selector: `edge.${Constants.LABEL}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeLabel();
        tolavaan($modelOptions.mode);
      },
      show: "both",
      hasTrailingDivider: false,
    },

    {
      id: "remove-edge",
      content: "Delete Edge",
      selector: `edge.${Constants.FROM_USER}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.remove();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: true,
    },
    {
      id: "fix-para",
      content: "Fix Parameter",
      selector: `edge.${Constants.FREE}.${Constants.FROM_USER}, edge.${Constants.FORCE_FREE}.${Constants.FROM_USER}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        // @ts-expect-error
        bootbox.prompt({
          title: "Enter a Value",
          inputType: "number",
          callback: function (value) {
            if (value == "") {
              // @ts-expect-error
              bootbox.alert("Provide a value");
              return false;
            }
            if (value !== null) {
              edge.fixPara(value);
              tolavaan($modelOptions.mode);
            }
          },
        });
      },
      show: "full",
      hasTrailingDivider: false,
    },
    {
      id: "free-para",
      content: "Free Parameter",
      selector: `edge.${Constants.FIXED}.${Constants.FROM_USER}, edge.${Constants.FORCE_FREE}.${Constants.FROM_USER}`,
      onClickFunction: function (event) {
        var edge = event.target || event.cyTarget;
        edge.freePara();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: false,
    },
    {
      id: "free-force-para",
      content: "Force Parameter Free",
      selector: `edge.${Constants.FREE}.${Constants.FROM_USER}, edge.${Constants.FIXED}.${Constants.FROM_USER}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.forceFreePara();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: true,
    },

    {
      id: "revert-arrow",
      content: "Revert Direction",
      selector: `edge[isMean="0"].${Constants.DIRECTED}.${Constants.FROM_USER}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.revert();

        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: false,
    },
    {
      id: "set-undirected",
      content: "Set Undirected",
      selector: `edge[isMean="0"].${Constants.DIRECTED}.${Constants.FROM_USER}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.setUndirected();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: true,
    },

    {
      id: "set-arrow",
      content: "Set Directed",
      selector: `edge.${Constants.UNDIRECTED}.${Constants.FROM_USER}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.setDirected();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: true,
    },
    {
      id: "free-orientation",
      content: "Free Loop Orientation",
      selector: `edge.${Constants.LOOP}.fixDeg`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.removeClass("fixDeg");
        checkNodeLoop(edge.source().id());
      },
      show: "both",
      hasTrailingDivider: true,
    },
    {
      id: "change-fromUser",
      content: "Explicitly Include in Model",
      selector: `edge.${Constants.FROM_LAV}`,
      onClickFunction: function (event) {
        const edge = event.target || event.cyTarget;
        edge.markAddedUser();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: true,
    },
    {
      id: "color-edge",
      content: "Change Edge Color",
      selector: "edge",
      show: "both",
      onClickFunction: function (event) {
        var target = event.target || event.cyTarget;
        const toChange = getChange(target, "edges");
        if (toChange === null) {
          return null;
        }
        openColorPicker(target, toChange, "edge");
      },
    },
    {
      id: "change-line-width",
      content: "Change Line Width",
      show: "both", // Apply to both edges and nodes
      selector: "edge",
      onClickFunction: function (event) {
        var target = event.target || event.cyTarget;
        const toChange = getChange(target, "edges");
        if (null === toChange) {
          return null;
        }
        // @ts-ignore
        bootbox.prompt({
          title: "Enter New Line Width:",
          value: target.style("width"),
          callback: function (newWidth) {
            if (newWidth !== null) {
              $ur.do("style", {
                eles: toChange,
                style: { width: newWidth },
              });
            }
          },
        });
      },
    },

    //node menus
    {
      id: "rename-node",
      show: "full",
      content: "Rename Variable",
      selector: `node.${Constants.LATENT}, node.${Constants.OBSERVED}`,
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        const columnNames = $appState.columnNames;

        let dropdownOptions;
        if ($appState.dataAvail) {
          // Prepare options for the dropdown
          dropdownOptions = columnNames
            .map((name) => `<option value="${name}">${name}</option>`)
            .join("");
        }

        const dropdownHTML =
          $appState.dataAvail && node.isObserved()
            ? `
      <label>Or Select From Variables in Your Data:</label>
      <select class="form-control" id="label-dropdown">
        <option value="">--Select--</option>
        ${dropdownOptions}
      </select>
    `
            : "";
        // @ts-expect-error
        bootbox.dialog({
          title: "Rename Variable",
          message: `
      <div>
        <label>Enter a label:</label>
        <input type="text" class="form-control" id="new-label">
        ${dropdownHTML}
      </div>
    `,
          buttons: {
            cancel: {
              label: "Cancel",
              className: "btn-default",
            },
            confirm: {
              label: "Rename",
              className: "btn-primary",
              callback: function () {
                const inputLabel = document.getElementById("new-label").value;
                const selectedLabel =
                  $appState.dataAvail && node.isObserved()
                    ? document.getElementById("label-dropdown").value
                    : "";

                const result = inputLabel || selectedLabel;

                if (!validLabel(result)) {
                  return false;
                }

                if (result) {
                  node.setLabel(result);
                  if (columnNames && columnNames.includes(node.getLabel())) {
                    node.link();
                    setAlert(
                      "success",
                      `Variable ${node.data("label")} linked to data`,
                    );
                  } else if (node.isLinked()) {
                    node.unlink();
                    setAlert("info", `Variable ${node.getLabel()} unlinked`);
                  }
                  tolavaan($modelOptions.mode);
                }
              },
            },
          },
          onShown: function (e) {
            document
              .getElementById("new-label")
              .addEventListener("keypress", function (event) {
                if (event.key === "Enter") {
                  event.preventDefault(); // Prevent form submission if any
                  const confirmButton = e.target.querySelector(".btn-primary");
                  confirmButton.click();
                }
              });
          },
        });
      },
    },
    {
      id: "remove-node",
      content: "Delete Variable",
      selector: `node.${Constants.LATENT}, node.${Constants.OBSERVED}, node.${Constants.CONSTANT}`,
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        node.remove();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: true,
    },
    {
      id: "change-latent",
      content: "Change to Latent",
      selector: `node.${Constants.OBSERVED}`,
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        node.makeLatent();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: false,
    },

    {
      id: "change-ordered",
      content: "Change to Ordered",
      selector: `node.${Constants.OBSERVED}.${Constants.CONTINOUS}`,
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        node.makeOrdered();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: true,
    },

    {
      id: "change-continous",
      content: "Change to Continous",
      selector: `node.${Constants.OBSERVED}.${Constants.ORDERED}`,

      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        node.makeContinous();
        tolavaan($modelOptions.mode);
      },
      show: "full",
      hasTrailingDivider: true,
    },

    {
      id: "change-observed",
      show: "full",
      content: "Change to Observed",
      selector: `node.${Constants.LATENT}`,
      hasTrailingDivider: true,
      onClickFunction: function (event) {
        const node = event.target || event.cyTarget;
        node.makeObserved();
        let columnNames = $appState.columnNames;
        if (columnNames && columnNames.includes(node.getLabel())) {
          node.link();
          bootbox.alert("Variable linked with data set");
        }
        tolavaan($modelOptions.mode);
      },
    },
    {
      id: "color-node",
      content: "Change Background Color",
      selector: "node",
      show: "both",
      onClickFunction: function (event) {
        var target = event.target || event.cyTarget;
        const toChange = getChange(target, "nodes");
        if (toChange === null) {
          return null;
        }
        openColorPicker(target, toChange, "nodes");
      },
    },
    {
      id: "change-border-width",
      content: "Change Border Width",
      show: "both",
      selector: `node.${Constants.LATENT}, node.${Constants.OBSERVED}, node.${Constants.CONSTANT}`,
      onClickFunction: function (event) {
        var target = event.target || event.cyTarget;
        const toChange = getChange(target, "nodes");
        if (toChange === null) {
          return null;
        }
        // @ts-ignore
        bootbox.prompt({
          title: "Enter New Border Width:",
          value: target.style("border-width"),
          callback: function (newWidth) {
            if (newWidth !== null) {
              $ur.do("style", {
                eles: toChange,
                style: { "border-width": newWidth },
              });
            }
          },
        });
      },
    },
    {
      id: "change-font-size",
      content: "Change Font Size",
      show: "both",
      hasTrailingDivider: true,
      selector: `node.${Constants.LATENT}, node.${Constants.OBSERVED}, node.${Constants.CONSTANT}, edge`,
      onClickFunction: function (event) {
        var target = event.target || event.cyTarget;
        const toChange = getChange(target, "nodes.edges");
        if (toChange === null) {
          return null;
        }
        // @ts-ignore
        bootbox.prompt({
          title: "Enter New Font Size:",
          value: target.style("font-size"),
          callback: function (newFontSize) {
            if (newFontSize !== null) {
              $ur.do("style", {
                eles: toChange,
                style: { "font-size": newFontSize },
              });
            }
          },
        });
      },
    },
  ];

  function selectMenu(menu, isFull) {
    const valueToMatch = isFull ? "full" : "minimal";
    return menu.filter(
      (obj) => obj.show === valueToMatch || obj.show === "both",
    );
  }
  let toChangeGlobal;
  function openColorPicker(target, toChange, type) {
    var pickerElement = document.getElementById("picker");
    pickerElement.style.display = "block";
    pickerElement.style.left = event.pageX + "px";
    pickerElement.style.top = event.pageY + "px";

    let hexColor;
    toChangeGlobal = toChange;
    // Define the function to change the color so it can be removed later
    const changeColor = function (color) {
      hexColor = color.hexString;
    };

    // Listen to color change events
    colorPicker.on("color:change", changeColor);

    // Function to hide the picker and remove the color change listener
    const closePicker = function (event) {
      if (!pickerElement.contains(event.target)) {
        if (type == "edge") {
          $ur.do("style", {
            eles: toChangeGlobal,
            style: {
              "line-color": hexColor,
              "target-arrow-color": hexColor,
              "source-arrow-color": hexColor,
            },
          });
        } else {
          $ur.do("style", {
            eles: toChangeGlobal,
            style: { "background-color": hexColor },
          });
        }
        pickerElement.style.display = "none";
        // Remove the color change event listener
        colorPicker.off("color:change", changeColor);
        // Remove this click event listener to clean up
        document.removeEventListener("click", closePicker);
        document.removeEventListener("keydown", closePickerEnter);
      }
    };

    // Use setTimeout to temporarily ignore the immediate click event that opens the picker
    setTimeout(() => document.addEventListener("click", closePicker), 0);

    const closePickerEnter = function (event) {
      if (event.key === "Enter") {
        closePicker(event);
      }
    };
    document.addEventListener("keydown", closePickerEnter);
  }
  const menuSel = selectMenu(menu, $appState.full);
  onMount(() => {
    // Initialize the Cytoscape instance
    cy.contextMenus({ menuItems: menuSel });
  });
</script>
