<script>
    import { modelOptions } from "../stores";
    import { tolavaan } from "../Shiny/toR.js";

    $: {
        tolavaan($modelOptions.mode);
    }
</script>
