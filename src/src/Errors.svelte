<script>
  window.onerror = function (message, source, lineno, colno, error) {
    showError(message, "Javascript");
  };

  window.addEventListener("unhandledrejection", function (event) {
    showError(event.reason, "Javascript");
  });

  function showError(message, source) {
    // @ts-expect-error
    bootbox.alert({
      title: "<span style='color: red;'>Error</span>",
      message: `A ${source} error occurred:<br> <span style='color: red;'>${message}</span>.<br><br>Please consider reporting this issue by sending an email to <a href="mailto:j.d.karch@fsw.leidenuniv.nl">j.d.karch@fsw.leidenuniv.nl</a>.`,
      centerVertical: true,
    });
    return true;
  }

  function serverAvail() {
    // @ts-expect-error
    return typeof Shiny === "object" && Shiny !== null;
  }

  if (serverAvail()) {
    // @ts-expect-error
    Shiny.addCustomMessageHandler("serverError", function (message) {
      showError(message.msg, "Server");
    });
  }
</script>
