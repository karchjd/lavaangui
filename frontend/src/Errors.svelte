<script>
  import { appState } from "./stores";
  import { get } from "svelte/store";

  const EXT_RE = /^(chrome|moz|safari)-extension:\/\//i;

  function isFromOurApp(error, source) {
    // ignore browser extensions
    if (typeof source === "string" && EXT_RE.test(source)) return false;

    const stack = error && typeof error.stack === "string" ? error.stack : "";
    if (stack) {
      if (EXT_RE.test(stack)) return false;

      // show only if stack points to our origin or built bundles
      if (
        stack.includes(window.location.origin) ||
        /\/assets\/.*\.(js|mjs)/i.test(stack)
      ) {
        return true;
      }
      return false; // stack exists but isn't ours
    }

    // no stack: fall back to filename if we have one
    if (typeof source === "string" && source.length) {
      if (source.startsWith(window.location.origin)) return true;
      if (/\/assets\/.*\.(js|mjs)/i.test(source)) return true;
      return false;
    }

    // nothing to go on: assume it's ours
    return true;
  }

  window.onerror = function (message, source, lineno, colno, error) {
    if (!isFromOurApp(error, source)) return true; // ignore
    showError(message, "Javascript");
    return true;
  };

  window.addEventListener("unhandledrejection", function (event) {
    if (!isFromOurApp(event.reason, "")) return; // ignore
    showError(event.reason?.message ?? String(event.reason), "Javascript");
  });

  function showError(message, source) {
    // @ts-expect-error
    bootbox.alert({
      title: "<span style='color: red;'>Error</span>",
      message: `A ${source} error occurred:<br> <span style='color: red;'>${message}</span>.<br><br>Please consider reporting this issue by sending an email to <a href="mailto:j.d.karch@fsw.leidenuniv.nl">j.d.karch@fsw.leidenuniv.nl</a>`,
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
      if (get(appState).showServerErrors) {
        showError(message.msg, "Server");
      }
    });
  }
</script>
