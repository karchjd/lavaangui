<script>
  import { onMount } from "svelte";
  import { alertStore } from "../stores.js";

  let alertTypes = {
    success: {
      class: "alert-success",
      label: "Success!",
    },
    info: {
      class: "alert-info",
      label: "Info!",
    },
    warning: {
      class: "alert-warning",
      label: "Warning!",
    },
    danger: {
      class: "alert-danger",
      label: "Danger!",
    },
  };

  let fade = false;
  let timer;

  $: if ($alertStore.message !== "") {
    fade = false; // Reset fade
    clearTimeout(timer); // Clear any existing timer
    timer = setTimeout(() => {
      fade = true;
    }, 10000);
  }
</script>

{#if $alertStore.message !== ""}
  <div class={alertTypes[$alertStore.type].class + (fade ? " fadeOut" : "")}>
    <strong>{alertTypes[$alertStore.type].label}</strong>
    {$alertStore.message}
  </div>
{/if}

<style>
  .fadeOut {
    animation: fadeOutAnimation 1s forwards;
    -webkit-animation: fadeOutAnimation 1s forwards;
  }

  @keyframes fadeOutAnimation {
    to {
      opacity: 0;
      visibility: hidden;
    }
  }

  @-webkit-keyframes fadeOutAnimation {
    to {
      opacity: 0;
      visibility: hidden;
    }
  }
</style>
