<script>
    import DropDownCheck from "./helpers/DropDownCheck.svelte";
    import { cyStore } from "../stores";
    import { get } from "svelte/store";

    let menuItems = [
      { name: "Edges Created by Lavaan", checked: true, class: "fromLav"},
      { name: "Variance Edges", checked: true, class: "loop"},
    ];

    $: {
      updateVisibility(menuItems);
    }

    function updateVisibility(menuItems){
        const cy = get(cyStore);
        console.log("update")
        if(menuItems[0].checked && menuItems[1].checked){
            cy.elements("."+ menuItems[0].class).show();
            cy.elements("."+ menuItems[1].class).show();
        }else if(menuItems[0].checked && !menuItems[1].checked){
            cy.elements("."+ menuItems[0].class).show();
            cy.elements("."+ menuItems[1].class).hide();
        }else if(!menuItems[0].checked && menuItems[1].checked){
            cy.elements("."+ menuItems[1].class).show();
            cy.elements("."+ menuItems[0].class).hide();
        }else{
            cy.elements("."+ menuItems[1].class).hide();
            cy.elements("."+ menuItems[0].class).hide();
        }
    }
  </script>
  
  <DropDownCheck name={"View"} bind:menuItems={menuItems} />
  