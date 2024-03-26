<script>
    import { modelOptions, cyStore } from "../stores";
    import { tolavaan } from "../Shiny/toR.js";

    $: {
        tolavaan($modelOptions.mode);
    }
</script>
