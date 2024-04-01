<script>
    export let name;
    export let value;
    export let min;
</script>

<li style="padding-left: 28px;">
    {name}
    <input style="width: 4em" type="number" bind:value {min} />
</li>
