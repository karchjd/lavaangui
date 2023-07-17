<script>
    import DropDownCheck from "./helpers/DropDownCheck.svelte";
    let menuItems = [
      { name: "Edges Created by Lavaan", checked: true},
      { name: "Variance Edges", checked: true},
    ];
  </script>
  
  <DropDownCheck name={"View"} {menuItems} />
  