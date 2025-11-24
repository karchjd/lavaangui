/// <reference types="node" />

import { test, expect } from "./fixtures";
import path from "path";
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);

test("Not Identified", async ({ page }) => {
  const fileChooserPromise = page.waitForEvent("filechooser");
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "Load Model", exact: true }).click();
  await page.getByText("OK").click();
  await page.waitForTimeout(500);
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(path.join(__dirname, "not_identified.lvm"));
  await page.locator('div.center-screen').waitFor({ state: 'hidden' });
  await expect(page.getByTestId("result-text")).toContainText(
    "This may be a symptom that the model is not"
  );
});
