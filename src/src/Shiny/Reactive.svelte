<script>
    import { modelOptions, visibility } from "../stores";
    import { tolavaan } from "../Shiny/toR.js";

    $: {
        tolavaan($modelOptions.mode);
    }
</script>
