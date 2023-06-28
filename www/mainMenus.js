document.querySelectorAll(".menu > ul > li").forEach((item) => {
  item.addEventListener("mouseenter", (event) => {
    const submenu = item.querySelector(".submenu");
    if (submenu) {
      submenu.style.display = "block";

      // Additionally set display block to submenu's li and a elements
      const submenuItems = submenu.querySelectorAll("li, a");
      submenuItems.forEach((submenuItem) => {
        submenuItem.style.display = "block";
      });
    }
  });

  item.addEventListener("mouseleave", (event) => {
    const submenu = item.querySelector(".submenu");
    if (submenu) {
      submenu.style.display = "none";

      // Additionally set display none to submenu's li and a elements
      const submenuItems = submenu.querySelectorAll("li, a");
      submenuItems.forEach((submenuItem) => {
        submenuItem.style.display = "none";
      });
    }
  });
});

// Add an event listener to the help menu item
$("#help-menu-item").click(function (event) {
  event.preventDefault(); // Prevent the default action of the link

  // Help content
  var helpContent = [
    { command: "Hold command/ctrl:", description: "Draw directed arrows" },
    {
      command: "Hold space:",
      description: "Draw undirected arrows (currently disabled because of bug)",
    },
    { command: "Backspace:", description: "Delete selected elements" },
    {
      command: "o:",
      description: "Create observed variable at mouse location",
    },
    { command: "l:", description: "Create latent variable at mouse location" },
    {
      command: "c:",
      description: "Create constant variable at mouse location",
    },
  ];

  // Display the modal dialog
  var modal = $("#help-modal");
  var helpContentElement = $("#help-content");
  helpContentElement.html(generateHelpList(helpContent));

  // Show the modal dialog
  modal.css("display", "flex");
  modal.show();

  // Set focus on the modal content
  $(".modal-content").focus();
});

$(document).on("keydown", function (event) {
  if (event.key === "Escape") {
    $("#help-modal").hide();
  }
});

// Close the modal dialog when the close button is clicked
$(document).on("click", ".close", function () {
  $("#help-modal").hide();
});

// Close the modal dialog when the user clicks outside of it
$(document).on("click", function (event) {
  if ($(event.target).is("#help-modal")) {
    $("#help-modal").hide();
  }
});

// Prevent focus from going outside of the modal content
$(document).on("focusin", function (event) {
  if (
    $("#help-modal").is(":visible") &&
    !$(event.target).closest(".modal-content").length
  ) {
    event.preventDefault();
    $(".modal-content").focus();
  }
});

function generateHelpList(contentArray) {
  var helpList = "";
  for (var i = 0; i < contentArray.length; i++) {
    var item = contentArray[i];
    helpList +=
      '<div class="help-item"><strong>' +
      item.command +
      "</strong><span>" +
      item.description +
      "</span></div>";
  }
  return helpList;
}

function handleItemChange(item) {
  // Build the string based on selected items
  let outputString = "Hallo";

  const wordMapping = {
    "Show Estimate": "world",
    "Show pvalue": "suckers,",
    "Show standard error": "Each",
    "Show confidence interval": "item",
  };

  document.querySelectorAll(".checkmark-container").forEach((item) => {
    let label = item.querySelector("label").textContent;
    let isSelected = item.getAttribute("data-selected") === "true";

    if (isSelected) {
      outputString += " " + wordMapping[label];
    }
  });

  // Set the content of the output element to the generated string
  console.log(outputString);
}
