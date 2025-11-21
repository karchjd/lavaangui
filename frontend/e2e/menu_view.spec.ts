/// <reference types="node" />

import { test, expect } from "./fixtures";
import path from "path";
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);

// File menu


//View Menu
test("Default options View", async ({ page }) => {
  await page.getByRole("button", { name: "Estimates" }).click();
  await page.waitForTimeout(1500);


  //Edges created by lavaan visible
  await page
    .evaluate(() => {
      // @ts-expect-error
      const edgesFromLav = window.cy.edges(".fromLav");
      return edgesFromLav.every((edge: any) => edge.visible());
    })
    .then((visible) => {
      expect(visible).toBe(true);
    });
  //Standard estimates shown
  await page
    .evaluate(() => {
      // @ts-expect-error
      const edge = window.cy.edges((edge) => {
        const sourceNode = edge.source();
        const targetNode = edge.target();
        return (
          sourceNode.data("label") === "visual" &&
          targetNode.data("label") === "x2"
        );
      });
      return edge.style("label") === "0.55";
    })
    .then((hasLabel) => {
      expect(hasLabel).toBe(true);
    });
});

test("Show Script", async ({ page }) => {
  await page.waitForTimeout(500);
  await expect(page.getByTestId("result-text")).toContainText(
    "library(lavaan)"
  );
  const lavEdges = await page.evaluate(() =>
    // @ts-expect-error
    window.cy.edges(".fromLav").map((edge) => edge.visible())
  );
  const usrEdges = await page.evaluate(() =>
    // @ts-expect-error
    window.cy.edges(".fromUser").map((edge) => edge.visible())
  );

  // Expect all lavEdges to be invisible
  expect(lavEdges.every((isVisible: boolean) => !isVisible)).toBe(true);

  // Expect all usrEdges to be visible
  expect(usrEdges.every((isVisible: boolean) => isVisible)).toBe(true);
});

test("Show Full Model", async ({ page }) => {
  await page.waitForTimeout(500);
  await page.getByRole("button", { name: "Autocompleted Model" }).click();
  await page.waitForTimeout(500);
  await expect(page.getByTestId("result-text")).toContainText("library(lavaan)");
  const lavEdges = await page.evaluate(() =>
    // @ts-expect-error
    window.cy.edges(".fromLav").map((edge) => edge.visible())
  );
  const usrEdges = await page.evaluate(() =>
    // @ts-expect-error
    window.cy.edges(".fromUser").map((edge) => edge.visible())
  );

  // Expect all lavEdges to be visible
  expect(lavEdges.every((isVisible: boolean) => isVisible)).toBe(true);

  // Expect all usrEdges to be visible
  expect(usrEdges.every((isVisible: boolean) => isVisible)).toBe(true);
});

test("Fit Model", async ({ page }) => {
  await page.getByRole("button", { name: "Estimates" }).click();

  await page.waitForTimeout(2000);

  await page
    .evaluate(() => {
      // @ts-expect-error
      const edge = window.cy.edges((edge) => {
        const sourceNode = edge.source();
        const targetNode = edge.target();
        return (
          sourceNode.data("label") === "visual" &&
          targetNode.data("label") === "x2"
        );
      });
      return edge.style("label") === "0.55";
    })
    .then((hasLabel) => {
      expect(hasLabel).toBe(true);
    });

  await expect(page.getByTestId("result-text")).toContainText(
    "Model Test User Model:"
  );
});

// test("Abort", async ({ page }) => {
//   await page.goto("http://127.0.0.1:3245/");
//   await page.getByRole("button", { name: "Estimation" }).click();
//   await page.getByRole("link", { name: "Standard Error" }).hover();
//   await page.getByText("Bootstrap").click();
//   await page.getByText("OK").click();
//   await page.getByRole("button", { name: "Fit Model" }).click();
//   await page.getByRole("button", { name: "Cancel" }).click();
//   await expect(page.getByTestId("result-text")).toContainText(
//     "stopped by user"
//   );
//   await page.getByRole("button", { name: "Fit Model" }).click();
//   await page.getByRole("button", { name: "Cancel" }).click();
//   await expect(page.getByTestId("result-text")).toContainText(
//     "stopped by user"
//   );
// });

test("Remove data", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.getByRole("link", { name: "Remove Data" }).click();
  const fitButton = await page.getByRole("button", { name: "Estimates" });
  expect(await fitButton.isDisabled()).toBe(true);
});

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
