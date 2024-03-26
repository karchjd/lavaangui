<script>
    import { modelOptions, cyStore } from "../stores";
    import { tolavaan } from "../Shiny/toR.js";

    $: {
        console.log($modelOptions);
        console.log($cyStore.nodes().length);
        tolavaan($modelOptions.mode);
    }
</script>
