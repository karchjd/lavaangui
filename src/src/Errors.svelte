<script>
  window.onerror = function (message, source, lineno, colno, error) {
    showError(message, "Javascript");
  };

  function showError(message, source) {
    bootbox.alert({
      title: "<span style='color: red;'>Error</span>",
      message: `A ${source} error occurred:<br> <span style='color: red;'>${message}</span>.<br><br>Please consider reporting this issue by sending an email to <a href="mailto:j.d.karch@fsw.leidenuniv.nl">j.d.karch@fsw.leidenuniv.nl</a>.`,
      centerVertical: true,
    });
    return true;
  }

  function triggerError() {
    throw new Error("This is a custom error message.");
  }

  function serverAvail() {
    return typeof Shiny === "object" && Shiny !== null;
  }

  if (serverAvail()) {
    Shiny.addCustomMessageHandler("serverError", function (message) {
      showError(message, "Server");
    });
  }
</script>
