<script>
    import { modelOptions, visibility } from "../stores";
    import { tolavaan } from "../Shiny/toR.js";
    import { updateVisibility, edgeItems } from "../MenuTop/viewModule";

    $: {
        tolavaan($modelOptions.mode);
    }
</script>
