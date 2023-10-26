<script>
  import { appState } from "../stores.js";

  import DropdownLinks from "./helpers/DropDownLinks.svelte";

  function showDataInfo() {
    // @ts-expect-error
    window.$("#data-modal").modal();
  }
  let menuItems;
  $: {
    menuItems = [
      {
        name: "Data Editor",
        action: showDataInfo,
        disable: !$appState.dataAvail,
      },
    ];
  }
</script>

<DropdownLinks name={"Data Editor"} {menuItems} />
