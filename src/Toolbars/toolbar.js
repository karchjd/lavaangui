$("#add-latent-variable").click(function () {
  addNode("latent-variable");
});

// Button click event for "Create Observed Variable"
$("#add-manifest-variable").click(function () {
  addNode("observed-variable");
});

// Button click event for "Create Constant Variable"
$("#add-constant-variable").click(function () {
  addNode("constant");
});

$("#ctrScript").click(function () {
  tolavaan(false);
});

$("#run").click(function () {
  tolavaan(true);
});
