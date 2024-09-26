<script>
    import Dexie from "dexie";
    import { appState } from "./stores";
    import { requestData, jsonModel } from "./MenuTop/IO";
    import { onMount } from "svelte";
    import { parseModel } from "./MenuTop/IO";

    const timeoutSeconds = 5;
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
            let sessionId = sessionStorage.getItem("sessionId");
            if (!sessionId) {
                sessionId = Date.now().toString(); // Generate a unique session ID
                sessionStorage.setItem("sessionId", sessionId);
                console.log("Session ID save: ", sessionId);
            }
            var db = new Dexie("ModelDatabase");
            db.version(1).stores({
                cache: "sessionId, model, data",
            });
            await db.cache.clear(); // Corrected from delete() to clear()
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
