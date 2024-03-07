<script>
    export let full = true;
    import { gridViewOptions } from "../stores.js";
    import Dropdown from "./helpers/Dropdown.svelte";
    import CheckItem from "./helpers/CheckItem.svelte";
    import TextItem from "./helpers/TextItem.svelte";
</script>

<!-- todo color -->

<Dropdown minimal={!full} name={"Grid Options"}>
    <CheckItem name={"Show Grid"} bind:checked={$gridViewOptions.gridShow} />
    <CheckItem name={"Snap to Grid"} bind:checked={$gridViewOptions.gridSnap} />
    <CheckItem
        name={"Resize to Grid"}
        bind:checked={$gridViewOptions.gridAlign}
    />
    <CheckItem
        name={"Snap to Alignment on Release"}
        bind:checked={$gridViewOptions.gridAlign}
    />
    <CheckItem
        name={"Move Grid on Pan"}
        bind:checked={$gridViewOptions.gridMovePan}
    />
    <TextItem
        name={"Grid Spacing:"}
        bind:value={$gridViewOptions.gridSpace}
        min={5}
    />
    <TextItem
        name={"Line Width:"}
        bind:value={$gridViewOptions.gridWidth}
        min={0}
    />
</Dropdown>
