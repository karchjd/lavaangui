/// <reference types="node" />

import type { BrowserContext, Page } from "@playwright/test";
import { test, expect } from "@playwright/test";
import { loadModelAndData } from "./fixtures";

async function edgeHasLabel(page: Page, expectedLabel: string) {
  return page.evaluate((expectedLabel: string) => {
    // @ts-expect-error
    const edge = window.cy.edges((edge) => {
      const sourceNode = edge.source();
      const targetNode = edge.target();
      return (
        sourceNode.data("label") === "visual" &&
        targetNode.data("label") === "x2"
      );
    });
    const actualLabel = edge.style("label");
    return actualLabel === expectedLabel ? true : actualLabel;
  }, expectedLabel);
}

// Use describe.serial to group tests and reuse one page set up once
test.describe.serial("Estimates View Group", () => {
  let context: BrowserContext;
  let sharedPage: Page;

  test.beforeAll(async ({ browser }) => {
    context = await browser.newContext();
    sharedPage = await context.newPage();
    await loadModelAndData(sharedPage);
    await sharedPage.getByRole("button", { name: "Estimates" }).click();
    await sharedPage.waitForTimeout(1500);
  });

  test.afterAll(async () => {
    await context?.close();
  });


  test("Default options View", async () => {
    const page = sharedPage;
    // Edges created by lavaan visible
    await page
      .evaluate(() => {
        // @ts-expect-error
        const edgesFromLav = window.cy.edges(".fromLav");
        return edgesFromLav.every((edge: any) => edge.visible());
      })
      .then((visible) => {
        expect(visible).toBe(true);
      });

    // Standard estimates shown
    await edgeHasLabel(page, "0.55").then((hasLabel) => {
      expect(hasLabel).toBe(true);
    });
  });

  test("Standardized Estimates", async () => {
    const page = sharedPage;
    await page.getByRole('button', { name: 'View' }).click();
    await page.getByText('Standardized Estimates').click();
    await edgeHasLabel(page, "0.42").then((hasLabel) => {
      expect(hasLabel).toBe(true);
    });
  });


  test("Confidence Interval", async () => {
    const page = sharedPage;
    await page.getByRole('button', { name: 'View' }).click();
    await page.getByText('Confidence Interval').first().click();
    await edgeHasLabel(page, "[0.31, 0.54]").then((hasLabel) => {
      expect(hasLabel).toBe(true);
    });
  });

  // Estimate + p value
  test("Estimate + p value", async () => {
    const page = sharedPage;
    await page.getByRole('button', { name: 'View' }).click();
    await page.getByText('Estimate + p-value (stars)').click();
    await edgeHasLabel(page, "0.42***").then((hasLabel) => {
      expect(hasLabel).toBe(true);
    });
  });

  test("Estimate + Std Error", async () => {
    const page = sharedPage;
    await page.getByRole('button', { name: 'View' }).click();
    await page.getByText('Estimate + Standard Error').click();
    await edgeHasLabel(page, "0.42 (0.06)").then((hasLabel) => {
      expect(hasLabel).toBe(true);
    });
  });

  test("Change Confidence Level", async () => {
    const page = sharedPage;
    await page.getByRole('button', { name: 'View' }).click();
    await page.getByText('Confidence Interval').first().click();
    await page.getByRole('button', { name: 'View' }).click();
    await page.getByRole('spinbutton').first().fill('0.80');
    await page.getByRole('spinbutton').first().press('Enter');
    await edgeHasLabel(page, "[0.31, 0.54]").then((hasLabel) => {
      expect(hasLabel).toBe(true);
    });
  });

  //TODO: fix this test
  // test("Change Digits", async () => {
  //   const page = sharedPage;
  //   // Change to estimates with 3 digits
  //   await page.getByRole('button', { name: 'View' }).click();
  //   await page.getByText('Estimate', { exact: true }).click();
  //   await page.getByRole('button', { name: 'View' }).click();
  //   await page.getByRole('spinbutton').nth(1).fill('3');
  //   await page.getByRole('spinbutton').nth(1).press('Enter');
  //   await edgeHasLabel(page, '0.424').then((hasLabel) => {
  //     expect(hasLabel).toBe(true);
  //   });
  // });
});


// TODO:
// Arrows created by lavaan
// Variance Errors
// Mean Arrows













