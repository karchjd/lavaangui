<script>
    import CheckItem from "./helpers/CheckItem.svelte";
    import Dropdown from "./helpers/Dropdown.svelte";

    export let minimal = false;
    import { appState } from "../stores";

    const APP_STATE_COMPOSITE_KEY = "lavaangui.appState.composite";

    function persistCompositeSetting(value) {
        if (typeof localStorage === "undefined") {
            return;
        }
        try {
            localStorage.setItem(APP_STATE_COMPOSITE_KEY, String(value));
        } catch (error) {
            // ignore storage errors
        }
    }

    $: persistCompositeSetting($appState.composite);
</script>

<Dropdown name="Composites" {minimal}>
    <CheckItem
        name={"Shows Composites in Toolbar"}
        bind:checked={$appState.composite}
        disable={false}
    />
</Dropdown>
