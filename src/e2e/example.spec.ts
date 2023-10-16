import { test, expect } from "@playwright/test";

test("cfa_test", async ({ page }) => {
  await page.goto("http://127.0.0.1:3245/");
  await page.getByRole("button", { name: "File" }).click();
  await page
    .getByRole("link", { name: "Load Model and Data", exact: true })
    .waitFor();
  await page
    .getByRole("link", { name: "Load Model and Data", exact: true })
    .click();

  // await page.getByRole("button", { name: "Show User Model / Script" }).click();
  // const elementText = await page.locator("#lavaan_syntax_R").textContent();
  // expect(elementText).toBe(
  //   `library(lavaan)data <- read.csv(undefined)model <-'# measurement model visual =~ x1 + x2 + x3 textual =~ x4 + x5 + x6 speed =~ x7 + x8 + x9 'result <- lavaan(model, data, meanstructure = "default",\t\t int.ov.free = TRUE, int.lv.free = FALSE,\t\t estimator = "ML", se = "standard",\t\t missing = "listwise", auto.fix.first = TRUE ,\t\t auto.fix.single = TRUE, auto.var = TRUE,\t\t auto.cov.lv.x = TRUE, auto.cov.y = TRUE,  \t\t fixed.x = TRUE)`
  // );
});
