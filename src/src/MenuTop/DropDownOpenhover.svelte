<script>
    window.$(document).ready(function () {
        var isAnyDropdownOpen = false; // Track if any dropdown is open

        // Modify the behavior of the dropdowns based on hover events
        window.$(".navbar .dropdown").hover(
            function () {
                // Only open on hover if another dropdown is already open
                if (isAnyDropdownOpen) {
                    window.$(".navbar .dropdown").removeClass("open");
                    window.$(this).addClass("open");
                }
            },
            function () {
                // Optional: decide if you want to auto-close on mouseleave
            },
        );

        // Detect opening of any dropdown
        window.$(".navbar .dropdown").on("show.bs.dropdown", function () {
            isAnyDropdownOpen = true;
        });

        // Detect closing of dropdowns
        window.$(".navbar .dropdown").on("hide.bs.dropdown", function () {
            // Check if this is the last one open before marking as none open
            if (window.$(".navbar .dropdown.open").length <= 1) {
                isAnyDropdownOpen = false;
            }
        });
    });
</script>
