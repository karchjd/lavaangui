import { test, expect } from "@playwright/test";
import path from "path";
import { fileURLToPath } from "url";
const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);

//File menu

test("new model", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
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
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  await page.getByRole("link", { name: "Load Data", exact: true }).click();

  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(path.join(__dirname, "cfa.csv"));
  await expect(page.getByTestId("data-info")).toContainText(
    "Dataset \"cfa.csv\" is loaded"
  );
});

test("Load Model and Data", async ({ page }) => {
  const fileChooserPromise = page.waitForEvent("filechooser");
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  await page
    .getByRole("link", { name: "Load Model and Data", exact: true })
    .click();
  await page.getByText("OK").click();

  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(path.join(__dirname, "cfa.zip"));
  await expect(page.getByTestId("data-info")).toContainText(
    "Dataset \"data.csv\" is loaded"
  );
});

test("Download Model", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  const downloadPromise = page.waitForEvent("download");
  await page.getByRole("link", { name: "Download Model", exact: true }).click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("diagram.json");
});

test("Remove Data", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  await page.getByRole("link", { name: "Remove Data" }).click();
  await expect(page.getByTestId("data-info")).toContainText("No Data loaded");
});

test("Download Model Data", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  const downloadPromise = page.waitForEvent("download");
  await page
    .getByRole("link", { name: "Download Model and Data", exact: true })
    .click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toMatch(/^lavaangui.*\.zip$/);
});

test("Export PNG", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  const downloadPromise = page.waitForEvent("download");
  await page.getByRole("link", { name: "PNG", exact: false }).click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.png");
});

test("Export JPG", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  const downloadPromise = page.waitForEvent("download");
  await page.getByRole("link", { name: "JPG", exact: false }).click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe("model.jpg");
});

//View Menu
test("Default options View", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "View" }).click();
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
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "Show User Model / Script" }).click();

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
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "Show Full Model" }).click();

  await expect(page.getByTestId("result-text")).toContainText("lhs");
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
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "Show User Model / Script" }).click();
  await page.getByRole("button", { name: "Fit Model" }).click();

  await page.waitForTimeout(5000);

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
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  await page.getByRole("link", { name: "Remove Data" }).click();
  const fitButton = await page.getByRole("button", { name: "Fit Model" });
  expect(await fitButton.isDisabled()).toBe(true);
});

test("Not Identified", async ({ page }) => {
  const fileChooserPromise = page.waitForEvent("filechooser");
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  await page.getByRole("link", { name: "Load Model", exact: true }).click();
  await page.getByText("OK").click();
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(path.join(__dirname, "not_identified.json"));
  await page.getByRole("button", { name: "Fit Model" }).click();
  await expect(page.getByTestId("result-text")).toContainText(
    "This may be a symptom that the model is not"
  );
});
