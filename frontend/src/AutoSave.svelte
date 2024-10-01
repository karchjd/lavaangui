<script>
    import Dexie from "dexie";
    import { appState } from "./stores";
    import { requestData, jsonModel } from "./MenuTop/IO";
    import { onMount } from "svelte";
    import { parseModel } from "./MenuTop/IO";

    const timeoutSeconds = 840;

    function idleTimer() {
        var t = setTimeout(logout, timeoutSeconds * 1000);

        window.onmousemove = resetTimer; // catches mouse movements
        window.onmousedown = resetTimer; // catches mouse movements
        window.onclick = resetTimer; // catches mouse clicks
        window.onscroll = resetTimer; // catches scrolling
        window.onkeypress = resetTimer; // catches keyboard actions
        function resetTimer() {
            clearTimeout(t);
            t = setTimeout(logout, timeoutSeconds * 1000); // time is in milliseconds (1000 is 1 second)
        }
    }

    async function logout() {
        console.log("Timeout");
        let model = null;
        let data = null;
        if ($appState.dataAvail) {
            requestData("saveData");
            data = await new Promise((resolve) => {
                Shiny.addCustomMessageHandler(
                    "dataForSave",
                    function (message) {
                        resolve(message); // Pass the message to resolve
                    },
                );
            });
        }
        if (!$appState.modelEmpty) {
            model = jsonModel();
        }
        if (model != null || data != null) {
            bootbox.alert(
                "Due to inactivity, you will be disconnected from the server shortly. Your work was saved for you. In case you have already been disconnected now, you can continue where you left off by refreshing the page.",
            );
            let sessionId = sessionStorage.getItem("sessionId");
            if (!sessionId) {
                sessionId = Date.now().toString();
                sessionStorage.setItem("sessionId", sessionId);
                console.log("Session ID save: ", sessionId);
            }
            var db = new Dexie("ModelDatabase");
            db.version(1).stores({
                cache: "sessionId, model, data",
            });
            await db.cache.clear();
            await db.cache.put({
                sessionId: sessionId,
                model: model,
                data: data,
            });
        }
    }

    onMount(async () => {
        let sessionId = sessionStorage.getItem("sessionId");
        console.log("Session ID load: ", sessionId);
        if (sessionId) {
            var db = new Dexie("ModelDatabase");
            db.version(1).stores({
                cache: "sessionId, model, data",
            });
            const cachedData = await db.cache.get(sessionId);
            if (cachedData.model) {
                console.log("Model loaded from cache");
                parseModel(cachedData.model);
            }
            if (cachedData.data) {
                console.log("Data loaded from cache");
                Shiny.setInputValue("dataUpload-fileInput", {
                    content: btoa(cachedData.data),
                });
                window.$("#upload-modal").modal();
            }
        }
    });

    idleTimer();
</script>
