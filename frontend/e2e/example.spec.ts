import { test, expect } from "@playwright/test";
import path from "path";
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);
console.log(__dirname);

//File menu

test.beforeEach(async ({ page }) => {
  const fileChooserPromise = page.waitForEvent("filechooser");
  await page.goto("/");
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "Load Model and Data", exact: true }).click();
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(path.join(__dirname, "cfa.lvd"));
});


test("new model", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "New Model" }).click();
  await page.getByText("OK").click();
  // @ts-expect-error
  const numberOfNodes = await page.evaluate(() => window.cy.nodes().length);

  // Asserttions
  expect(numberOfNodes).toBe(0);
  await expect(page.getByTestId("result-text")).toContainText("Command");
});


test("Load Data", async ({ page }) => {
  const fileChooserPromise = page.waitForEvent("filechooser");
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "Load Data", exact: true }).click();

  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(path.join(__dirname, "cfa.csv"));
  const heading = page.getByRole('heading', { name: 'Data Information (Double click on column name to change)' });
  await expect(heading).toBeVisible();
});

test("Download Model", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  const downloadPromise = page.waitForEvent("download");
  await page.getByRole("link", { name: "Download Model", exact: true }).click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.lvm");
});

test("Remove Data", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  await page.getByRole("link", { name: "Remove Data" }).click();
  const button = await page.getByRole('button', { name: 'Show Data' });
  expect(await button.isDisabled()).toBe(true);
});

test("Download Model Data", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  const downloadPromise = page.waitForEvent("download");
  await page
    .getByRole("link", { name: "Download Model and Data", exact: true })
    .click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toMatch(/^lavaangui.*\.lvd$/);
});

test("Export PNG", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  const downloadPromise = page.waitForEvent("download");
  await page.getByRole("link", { name: "PNG", exact: false }).click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.png");
});

test("Export JPG", async ({ page }) => {
  await page.getByRole("button", { name: "File" }).click();
  await page.waitForTimeout(500);
  const downloadPromise = page.waitForEvent("download");
  await page.getByRole("link", { name: "JPG", exact: false }).click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.jpg");
});

//View Menu
test("Default options View", async ({ page }) => {
  await page.getByRole("button", { name: "Estimates" }).click();
  await page.waitForTimeout(1500);


  //Edges created by lavaan visible
  await page
    .evaluate(() => {
      // @ts-expect-error
      const edgesFromLav = window.cy.edges(".fromLav");
      return edgesFromLav.every((edge) => edge.visible());
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
  expect(lavEdges.every((isVisible) => !isVisible)).toBe(true);

  // Expect all usrEdges to be visible
  expect(usrEdges.every((isVisible) => isVisible)).toBe(true);
});

test("Show Full Model", async ({ page }) => {
  await page.waitForTimeout(500);
  await page.getByRole("button", { name: "Lavaan Model" }).click();
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
  const x = 3;
  // Expect all lavEdges to be visible
  expect(lavEdges.every((isVisible) => isVisible)).toBe(true);

  // Expect all usrEdges to be visible
  expect(usrEdges.every((isVisible) => isVisible)).toBe(true);
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
  const fitButton = await page.getByRole("button", { name: "Estimates" });
  fitButton.click();
  await page.waitForTimeout(500);
  await expect(page.getByTestId("result-text")).toContainText(
    "This may be a symptom that the model is not"
  );
});
