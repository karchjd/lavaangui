/// <reference types="node" />

import { test, expect } from "./fixtures";
import path from "path";
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);

// File menu

test("new model", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "New Model" }).click();
  await page.getByText("OK").click();
  // @ts-expect-error
  const numberOfNodes = await page.evaluate(() => window.cy.nodes().length);

  // Assertions
  expect(numberOfNodes).toBe(0);
  await expect(page.getByTestId("result-text")).toContainText("Command");
});

test("Reset", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "Reset", exact: true }).click();
  await page.getByText("OK").click();
  // @ts-expect-error
  const numberOfNodes = await page.evaluate(() => window.cy.nodes().length);

  expect(numberOfNodes).toBe(0);
  const showDataButton = page.getByRole("button", { name: "Show Data" });
  expect(await showDataButton.isDisabled()).toBe(true);
  await expect(page.getByTestId("result-text")).toContainText("Command");
});


test("Load Data", async ({ page }) => {
  const fileChooserPromise = page.waitForEvent("filechooser");
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "Load Data", exact: true }).click();

  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(path.join(__dirname, "cfa.csv"));
  const heading = page.getByRole('heading', { name: 'Data Viewer (Double click on column name to change)' });
  await expect(heading).toBeVisible();
});

//Load Model and Data is tested in fixtures.ts

test("Save Model", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  const downloadPromise = page.waitForEvent("download");
  await page.getByRole("link", { name: "Save Model", exact: true }).click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toMatch(/^model.*\.lvm$/);
});

test("Save Model Data", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  const downloadPromise = page.waitForEvent("download");
  await page
    .getByRole("link", { name: "Save Model and Data", exact: true })
    .click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toMatch(/^model.*\.lvd$/);
});


test("Remove Data", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "Remove Data" }).click();
  const button = await page.getByRole('button', { name: 'Show Data' });
  expect(await button.isDisabled()).toBe(true);
});


test("Export PNG", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole('link', { name: 'Export Diagram to PNG' }).click();
  const downloadPromise = page.waitForEvent('download');
  await page.getByText('OK').click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.png");
});
test("Export JPG", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole('link', { name: 'Export Diagram to JPG' }).click();
  const downloadPromise = page.waitForEvent('download');
  await page.getByText('OK').click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.jpg");
});


test("Export SVG", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole('link', { name: 'Export Diagram to SVG' }).click();
  const downloadPromise = page.waitForEvent('download');
  await page.getByText('OK').click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.svg");
});


test("Export PDF", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole('link', { name: 'Export Diagram to PDF' }).click();
  const downloadPromise = page.waitForEvent('download');
  await page.getByText('OK').click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.pdf");
});