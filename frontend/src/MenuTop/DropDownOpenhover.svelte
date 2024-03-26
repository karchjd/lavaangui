<script>
    // @ts-ignore
    window.$(document).ready(function () {
        var isAnyDropdownOpen = false; // Track if any dropdown is open

        // Modify the behavior of the dropdowns based on hover events
        // @ts-ignore
        window.$(".navbar .dropdown").hover(
            function () {
                // Only open on hover if another dropdown is already open
                if (isAnyDropdownOpen) {
                    // @ts-ignore
                    window.$(".navbar .dropdown").removeClass("open");
                    // @ts-ignore
                    window.$(this).addClass("open");
                }
            },
            function () {
                // Optional: decide if you want to auto-close on mouseleave
            },
        );

        // Detect opening of any dropdown
        // @ts-ignore
        window.$(".navbar .dropdown").on("show.bs.dropdown", function () {
            isAnyDropdownOpen = true;
        });

        // Detect closing of dropdowns
        // @ts-ignore
        window.$(".navbar .dropdown").on("hide.bs.dropdown", function () {
            // Check if this is the last one open before marking as none open
            // @ts-ignore
            if (window.$(".navbar .dropdown.open").length <= 1) {
                isAnyDropdownOpen = false;
            }
        });
    });
</script>
