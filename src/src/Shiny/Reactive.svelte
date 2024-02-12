<script>
    import { cyStore } from "../stores";
    import { modelOptions, appState } from "../stores";
    import { tolavaan } from "../Shiny/toR.js";
    $: {
        console.log("modelOptions changed", $modelOptions);
        tolavaan($modelOptions.mode);
    }
</script>
