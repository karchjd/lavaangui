import { cyStore } from "../stores";
import { get } from "svelte/store";


export function applyLinkedClass(columnNames, apply) {
  if(columnNames == null){
    throw new Error("Columnnames may not be null.");
  }
    cy = get(cyStore);
    const nodes = cy.nodes(function (node) {
      return node.hasClass("observed-variable");
    });
    if (nodes.length > 0) {
      let all_linked = true;
      for (var i = 0; i < nodes.length; i++) {
        const node = nodes[i];
        const label = node.data("label");
        if (apply) {
          node.removeClass("linked");
        }
        if (columnNames.includes(label)) {
          if (apply) {
            node.addClass("linked");
          }
        } else {
          all_linked = false;
        }
      }
      if (all_linked) {
        bootbox.alert("All observed variables were linked with data");
      }
    }
  }
  