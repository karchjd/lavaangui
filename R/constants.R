help_text <- paste(
  "Command               Action",
  "--------------------------------------------------",
  "Right-Click           Right-Click Anywhere to get an Appropriate Menu",
  "o                     Create Observed Variable at Mouse Location",
  "l                     Create Latent Variable at Mouse Location",
  "c                     Create Constant Variable at Mouse Location",
  "Hold Shift            Draw Undirected Arrows by Connecting Variables With Mouse",
  "Hold CTRL             Draw Directed Arrows by Connect Variables With Mouse",
  "Hold CTRL             Click on Multiple Elements to Select",
  "Hold CTRL             Click on Canvas to Activate Select Box",
  "Backspace             Remove Selected Elements",
  "CTRL+Z                Undo Graph Appearance Changes",
  "CTRL+Y                Redo Graph Appearance Changes",
  "",
  "Mac Users Replace CTRL with CMD",
  sep = "\n"
)
class(help_text) <- "help_text"
print.help_text <- function(helpt_text) {
  cat(help_text)
}
