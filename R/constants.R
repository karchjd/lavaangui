help_text <- paste(
  "Command               Action",
  "--------------------------------------------------",
  "Right-Click           Right-Click Anywhere",
  "                      to get an Appropriate Menu",
  "o                     Create Observed Variable",
  "                      at Mouse Location",                    
  "l                     Create Latent Variable",
  "                      at Mouse Location",
  "c                     Create Constant Variable",
  "                      at Mouse Location",
  "Hold Space/X          Draw Directed Arrows",
  "                      by Connecting Variables With Mouse",
  "Hold ALT              Draw Undirected Arrows",
  "                      by Connecting Variables With Mouse",
  "Hold CTRL             Click on Multiple Elements to Select",
  "Hold CTRL             Click on Canvas to Activate Select Box",
  "Backspace             Remove Selected Elements",
  "CTRL+Z                Undo Graph Appearance Changes",
  "CTRL+Y                Redo Graph Appearance Changes",
  "",
  "Mac Users Replace CTRL with CMD, and ALT with OPTION",
  "",
  "",
  "Standard Workflow",
  "--------------------------------------------------",
  "1. Load your data (File --> Load Data)",
  "2. Draw your Model",
  "3. Check lavaan's autocomplete is correct (\"Lavaan model\")",
  "4. Fit Model (\"Estimates\")",
  sep = "\n"
)
class(help_text) <- "help_text"
print.help_text <- function(helpt_text) {
  cat(help_text)
}
