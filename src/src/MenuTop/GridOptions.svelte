<script>
    export let full = true;
    import { modelOptions } from "../stores.js";
    import Dropdown from "./helpers/Dropdown.svelte";
    import CheckItem from "./helpers/CheckItem.svelte";
    import TextItem from "./helpers/TextItem.svelte";
</script>

<!-- todo color -->

<Dropdown minimal={!full} name={"Grid Options"}>
    <CheckItem name={"Show Grid"} bind:checked={$modelOptions.gridShow} />
    <CheckItem name={"Snap to Grid"} bind:checked={$modelOptions.gridSnap} />
    <CheckItem name={"Resize to Grid"} bind:checked={$modelOptions.gridAlign} />
    <CheckItem
        name={"Snap to Alignment on Release"}
        bind:checked={$modelOptions.gridAlign}
    />
    <CheckItem
        name={"Move Grid on Pan"}
        bind:checked={$modelOptions.gridMovePan}
    />
    <TextItem
        name={"Grid Spacing:"}
        bind:value={$modelOptions.gridSpace}
        min={5}
    />
    <TextItem
        name={"Line Width:"}
        bind:value={$modelOptions.gridWidth}
        min={0}
    />
</Dropdown>
