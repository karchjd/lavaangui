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

$("#help-menu-item").click(function (event) {
  $("#help").modal();
});

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

$(".checkbox-menu").on("change", "input[type='checkbox']", function () {
  $(this).closest("li").toggleClass("active", this.checked);
});

$(document).on("click", ".allow-focus", function (e) {
  e.stopPropagation();
});
