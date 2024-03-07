<script>
    import { modelOptions, appState } from "../stores";
    import { tolavaan } from "../Shiny/toR.js";
    import { updateVisibility, edgeItems } from "../MenuTop/viewModule";

    $: {
        tolavaan($modelOptions.mode);
        updateVisibility(
            $modelOptions.showVar,
            $modelOptions.showLav,
            edgeItems,
        );
    }
</script>
