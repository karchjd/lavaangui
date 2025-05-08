<script>
    import DropdownLinks from "./helpers/DropDownLinks.svelte";
    import { modelOptions } from "../stores.js";

    const menuItems = [
        {
            name: "Add/Modify Derived Parameters",
            action: showMenu,
        },
    ];

    function showMenu() {
        bootbox.dialog({
            size: "small",
            title: "Add/Modify Derived Parameters",
            message: `
           <p>
  You can define new parameters using the <code>:=</code> operator below, 
  which take on values that are an arbitrary function of the original model parameters. 
  The function must be specified in terms of parameter labels that are in the model.
  Examples:
  <br><br>
  &nbsp;&nbsp;&nbsp;&nbsp;<code>ab := a * b</code><br>
  &nbsp;&nbsp;&nbsp;&nbsp;<code>total := c + (a * b)</code>
</p>
                <textarea class="form-control" id="defined-vars" rows="5"></textarea>
            `,
            buttons: {
                cancel: {
                    label: "Cancel",
                    className: "btn-secondary",
                    callback: function () {
                        console.log("Action canceled");
                    },
                },
                submit: {
                    label: "Submit",
                    className: "btn-primary",
                    callback: function () {
                        const input =
                            document.getElementById("defined-vars").value;
                        $modelOptions.defined = input;
                        console.log($modelOptions.defined);
                    },
                },
            },
        });
    }
</script>

<DropdownLinks name={"Derived Parameters"} {menuItems} />
