<script>
    import CheckItem from "./helpers/CheckItem.svelte";
    import Dropdown from "./helpers/Dropdown.svelte";

    export let minimal = false;
    import { appState } from "../stores";
    import { onMount } from "svelte";

    const APP_STATE_COMPOSITE_KEY = "lavaangui.appState.component";

    function loadComponentSetting() {
        if (typeof localStorage === "undefined") {
            return null;
        }
        try {
            const raw = localStorage.getItem(APP_STATE_COMPOSITE_KEY);
            if (raw === null) {
                return null;
            }
            return raw === "true";
        } catch (error) {
            return null;
        }
    }

    function persistComponentSetting(value) {
        if (typeof localStorage === "undefined") {
            return;
        }
        try {
            localStorage.setItem(APP_STATE_COMPOSITE_KEY, String(value));
        } catch (error) {
            // ignore storage errors
        }
    }

    onMount(() => {
        const stored = loadComponentSetting();
        if (stored !== null) {
            appState.update((current) => ({
                ...current,
                composite: stored,
            }));
        }
    });

    $: persistComponentSetting($appState.composite);
</script>

<Dropdown name="Settings" {minimal}>
    <CheckItem
        name={"Show More Composite Modeling Tools"}
        bind:checked={$appState.composite}
        disable={false}
    />
</Dropdown>
