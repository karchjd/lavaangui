/// <reference types="node" />

import { test as base } from "@playwright/test";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export async function loadModelAndData(page) {
    const fileChooserPromise = page.waitForEvent("filechooser");
    await page.goto("/");
    await page.getByRole("button", { name: "File" }).click();
    await page.waitForTimeout(500);
    await page
        .getByRole("link", { name: "Load Model and Data", exact: true })
        .click();
    const fileChooser = await fileChooserPromise;
    await fileChooser.setFiles(path.join(__dirname, "cfa.lvd"));
}

export const test = base.extend({
    page: async ({ page }, use) => {
        await loadModelAndData(page);
        await use(page);
    },
});

export const expect = test.expect;
