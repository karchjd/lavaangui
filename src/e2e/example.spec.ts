import { test, expect } from "@playwright/test";

// test("new model", async ({ page }) => {
//   await page.goto("http://127.0.0.1:3245/");
//   await page.getByRole("button", { name: "File" }).click();
//   await page.getByRole("link", { name: "New Model" }).click();
//   await page.getByText("OK").click();
//   const numberOfNodes = await page.evaluate(() => window.cy.nodes().length);

//   // Use Jest to make the assertion that the array has length 0
//   expect(numberOfNodes).toBe(0);
//   await expect(page.getByTestId("result-text")).toContainText("Command");
// });

// test("new model", async ({ page }) => {
//   await page.goto("http://127.0.0.1:3245/");
//   await page.getByRole("button", { name: "File" }).click();
//   await page.getByRole("link", { name: "New Model" }).click();
//   await page.getByText("OK").click();
//   const numberOfNodes = await page.evaluate(() => window.cy.nodes().length);

//   // Use Jest to make the assertion that the array has length 0
//   expect(numberOfNodes).toBe(0);
//   await expect(page.getByTestId("result-text")).toContainText("Command");
// });

test("has title", async ({ page }) => {
  await page.goto("https://playwright.dev/");

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Playwright/);
});
