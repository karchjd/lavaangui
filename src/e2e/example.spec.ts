import { test, expect } from "@playwright/test";

test("new model", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  await page.getByRole("link", { name: "New Model" }).click();
  await page.getByText("OK").click();
  const numberOfNodes = await page.evaluate(() => window.cy.nodes().length);

  // Use Jest to make the assertion that the array has length 0
  expect(numberOfNodes).toBe(0);
});
