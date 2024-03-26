<script>
    let name;
    let action;
    let disable = false;
</script>

<li class:disabled={disable}>
    <a href={"#"} on:click={action}>{name}</a>
</li>
