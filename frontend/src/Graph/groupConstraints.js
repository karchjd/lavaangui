export const GROUP_EQUAL_OPTIONS = Object.freeze([
  { value: "loadings", label: "Factor loadings" },
  { value: "intercepts", label: "Observed-variable intercepts" },
  { value: "means", label: "Latent-variable means" },
  { value: "residuals", label: "Observed-variable residual variances" },
  {
    value: "residual.covariances",
    label: "Observed-variable residual covariances",
  },
  { value: "lv.variances", label: "Latent-variable variances" },
  { value: "lv.covariances", label: "Latent-variable covariances" },
  { value: "regressions", label: "Regression coefficients" },
]);

const GROUP_EQUAL_VALUES = new Set(
  GROUP_EQUAL_OPTIONS.map((option) => option.value),
);

function asArray(value) {
  if (value == null) return [];
  return Array.isArray(value) ? value : [value];
}

function uniqueStrings(values) {
  const seen = new Set();
  return values.reduce((result, value) => {
    const normalized = String(value ?? "").trim();
    if (!normalized || seen.has(normalized)) return result;
    seen.add(normalized);
    result.push(normalized);
    return result;
  }, []);
}

export function normalizeGroupEqual(value) {
  const selected = new Set(
    uniqueStrings(asArray(value)).filter((item) => GROUP_EQUAL_VALUES.has(item)),
  );
  return GROUP_EQUAL_OPTIONS
    .map((option) => option.value)
    .filter((item) => selected.has(item));
}

export function normalizeGroupPartial(value) {
  return uniqueStrings(asArray(value).map((item) =>
    String(item ?? "").replace(/\s*(=~|~~|~)\s*/g, "$1")
  ));
}

function nodeLabel(node) {
  return String(node?.getLabel?.() ?? node?.data?.("label") ?? "").trim();
}

function hasNodeType(node, type) {
  if (type === "observed") return Boolean(node?.isObserved?.());
  if (type === "latent") return Boolean(node?.isLatent?.());
  return false;
}

function addOption(options, seen, category, syntax, from, to, arrow) {
  if (!syntax || !from || !to || seen.has(syntax)) return;
  seen.add(syntax);
  options.push({
    category,
    syntax,
    display: `${from} ${arrow} ${to}`,
  });
}

function hierarchicalFactorIds(cy) {
  const ids = new Set();
  cy.getLatentNodes().forEach((node) => {
    const outgoing = node.connectedEdges((edge) =>
      edge.isDirected() && edge.source().same(node)
    );
    if (
      outgoing.length > 0 &&
      outgoing.every((edge) =>
        edge.target().isLatent() || edge.target().isComposite()
      )
    ) {
      ids.add(node.id());
    }
  });
  return ids;
}

export function getGroupPartialOptions(cy, groupEqual) {
  const selected = new Set(normalizeGroupEqual(groupEqual));
  if (!cy || selected.size === 0) return [];

  const options = [];
  const seen = new Set();
  const observed = cy.getObservedNodes();
  const latent = cy.getLatentNodes();
  const hierarchical = hierarchicalFactorIds(cy);

  if (selected.has("loadings") || selected.has("regressions")) {
    cy.edges().forEach((edge) => {
      if (!edge.isDirected() || edge.source().isConstant()) return;

      const source = edge.source();
      const target = edge.target();
      const from = nodeLabel(source);
      const to = nodeLabel(target);
      const isLoading = source.isLatent() && (
        (target.isObserved() && edge.isFactLoad()) ||
        hierarchical.has(source.id())
      );

      if (selected.has("loadings") && isLoading) {
        addOption(
          options,
          seen,
          "loadings",
          `${from}=~${to}`,
          from,
          to,
          "→",
        );
      } else if (
        selected.has("regressions") &&
        !isLoading &&
        !edge.isCompLoad()
      ) {
        addOption(
          options,
          seen,
          "regressions",
          `${to}~${from}`,
          from,
          to,
          "→",
        );
      }
    });
  }

  if (selected.has("intercepts")) {
    observed.forEach((node) => {
      const label = nodeLabel(node);
      addOption(options, seen, "intercepts", `${label}~1`, "1", label, "→");
    });
  }

  if (selected.has("means")) {
    latent.forEach((node) => {
      const label = nodeLabel(node);
      addOption(options, seen, "means", `${label}~1`, "1", label, "→");
    });
  }

  if (selected.has("residuals")) {
    observed.forEach((node) => {
      const label = nodeLabel(node);
      addOption(
        options,
        seen,
        "residuals",
        `${label}~~${label}`,
        label,
        label,
        "↔",
      );
    });
  }

  if (selected.has("lv.variances")) {
    latent.forEach((node) => {
      const label = nodeLabel(node);
      addOption(
        options,
        seen,
        "lv.variances",
        `${label}~~${label}`,
        label,
        label,
        "↔",
      );
    });
  }

  if (
    selected.has("residual.covariances") ||
    selected.has("lv.covariances")
  ) {
    cy.edges().forEach((edge) => {
      if (!(edge.isUndirected() || edge.myIsLoop())) return;

      const source = edge.source();
      const target = edge.target();
      if (source.same(target)) return;

      const from = nodeLabel(source);
      const to = nodeLabel(target);
      let category = null;
      if (
        selected.has("residual.covariances") &&
        hasNodeType(source, "observed") &&
        hasNodeType(target, "observed")
      ) {
        category = "residual.covariances";
      } else if (
        selected.has("lv.covariances") &&
        hasNodeType(source, "latent") &&
        hasNodeType(target, "latent")
      ) {
        category = "lv.covariances";
      }
      if (category) {
        addOption(
          options,
          seen,
          category,
          `${from}~~${to}`,
          from,
          to,
          "↔",
        );
      }
    });
  }

  const categoryOrder = new Map(
    GROUP_EQUAL_OPTIONS.map((option, index) => [option.value, index]),
  );
  return options.sort((left, right) =>
    categoryOrder.get(left.category) - categoryOrder.get(right.category) ||
    left.display.localeCompare(right.display)
  );
}

export function pruneGroupPartial(value, options) {
  const eligible = new Set(options.map((option) => option.syntax));
  return normalizeGroupPartial(value).filter((syntax) => eligible.has(syntax));
}

function quoteRString(value) {
  const escaped = String(value)
    .replace(/\\/g, "\\\\")
    .replace(/"/g, '\\"')
    .replace(/\r/g, "\\r")
    .replace(/\n/g, "\\n");
  return `"${escaped}"`;
}

export function toRCharacterVector(value) {
  return `c(${normalizeGroupPartial(value).map(quoteRString).join(", ")})`;
}
