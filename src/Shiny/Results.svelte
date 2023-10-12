<script>
  import { onMount } from "svelte";

  function handleResetContentEvent() {
    document.querySelector("#lavaan_syntax_R").textContent = help_text;
  }

  document.body.addEventListener("reset-content", handleResetContentEvent);

  const help_text = `
Command               Action
--------------------------------------------------
Right-Click           Right-Click Anywhere to get an Appropriate Menu 
o                     Create Observed Variable at Mouse Location
l                     Create Latent Variable at Mouse Location
c                     Create Constant Variable at Mouse Location
Hold Shift            Draw Undirected Arrows by Connecting Variables With Mouse
Hold CTRL             Draw Directed Arrows by Connect Variables With Mouse
Hold CTRL             Click on Multiple Elements to Select
Hold CTRL             Click on Canvas to Activate Select Box
Backspace             Remove Selected Elements
CTRL+Z                Undo
CTRL+Y                Redo

Mac Users Replace CTRL with CMD
    `;

  onMount(() => {
    document.body.addEventListener("reset-content", handleResetContentEvent);
    document.querySelector("#lavaan_syntax_R").textContent = help_text;
    // Cleanup event listener on component destruction
    return () => {
      document.body.removeEventListener(
        "reset-content",
        handleResetContentEvent
      );
    };
  });
</script>

<pre id="lavaan_syntax_R" class="shiny-html-output well" />

<style>
  pre {
    white-space: pre;
    text-align: left;
    min-height: 0;
    display: flex;
    flex-basis: 30%;
    flex-direction: column; /* Changed from row (default) to column */
    overflow-y: scroll;
    overflow-x: scroll;
    min-width: 0;
    min-height: 0;
    margin: 0;
  }
</style>
