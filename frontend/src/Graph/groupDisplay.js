import { PARAMETER_STATUS } from "./groupParameters.js";

const GROUP_SEPARATOR = " | ";

function normalizeNumber(value) {
  if (value == null || value === "") return null;
  const number = Number(value);
  if (!Number.isFinite(number)) return String(value);
  return Object.is(number, -0) ? 0 : number;
}

function semanticValue(value) {
  const normalized = normalizeNumber(value);
  return normalized == null ? ["missing"] : [typeof normalized, normalized];
}

function fixedValueText(value) {
  const normalized = normalizeNumber(value);
  return normalized == null ? "NA" : String(normalized);
}

function numberText(value, digits) {
  const normalized = normalizeNumber(value);
  return typeof normalized === "number"
    ? normalized.toFixed(digits)
    : "NA";
}

function serializedKey(value) {
  return JSON.stringify(value);
}

export function collapseOrderedGroupTokens(tokens) {
  if (!Array.isArray(tokens) || tokens.length === 0) {
    return { text: "", collapsed: false, tokens: [] };
  }

  const collapsed = tokens.length > 1 && tokens.every(
    (token) => token.key === tokens[0].key && !token.preventCollapse,
  );
  return {
    text: collapsed
      ? tokens[0].text
      : tokens.map((token) => token.text).join(GROUP_SEPARATOR),
    collapsed,
    tokens: tokens.map((token) => token.text),
  };
}

export function groupLegendEntries(groups) {
  if (!Array.isArray(groups)) return [];
  return groups.map((group, index) => ({
    id: group?.id ?? index + 1,
    label: String(group?.label ?? group?.id ?? index + 1),
    position: index + 1,
    text: `${index + 1} ${String(
      group?.label ?? group?.id ?? index + 1,
    )}`,
  }));
}

export function graphDisplayGroups(groups, graphGroupView = "all") {
  if (!Array.isArray(groups)) return [];
  if (graphGroupView == null || graphGroupView === "all") return groups;
  const selected = groups.find(
    (group) => String(group?.id) === String(graphGroupView),
  );
  return selected ? [selected] : groups;
}

function findStateGroup(state, group) {
  if (!Array.isArray(state?.groups)) return null;
  const byLabel = state.groups.find(
    (candidate) => String(candidate.label) === String(group.label),
  );
  return byLabel ?? state.groups.find(
    (candidate) => String(candidate.id) === String(group.id),
  ) ?? null;
}

export function formatGroupParameterToken(parameter, groupId = "missing") {
  if (!parameter) {
    return {
      text: "NA",
      key: `missing:${String(groupId)}`,
      preventCollapse: true,
    };
  }

  const label = parameter.constraintLabel || null;
  let statusText;
  let statusKey;
  if (parameter.status === PARAMETER_STATUS.FIXED) {
    statusText = `@${fixedValueText(parameter.value)}`;
    statusKey = [PARAMETER_STATUS.FIXED, semanticValue(parameter.value)];
  } else if (parameter.status === PARAMETER_STATUS.FORCE_FREE) {
    statusText = "*!";
    statusKey = [PARAMETER_STATUS.FORCE_FREE];
  } else {
    statusText = "*";
    statusKey = [PARAMETER_STATUS.DEFAULT];
  }

  return {
    text: label
      ? `=${label}${statusText === "*" ? "" : ` ${statusText}`}`
      : statusText,
    key: serializedKey([statusKey, label]),
    preventCollapse: false,
  };
}

export function formatGroupParameterDisplay(state, orderedGroups) {
  const groups = Array.isArray(orderedGroups) && orderedGroups.length > 0
    ? orderedGroups
    : state?.groups ?? [];
  const display = collapseOrderedGroupTokens(groups.map((group) =>
    formatGroupParameterToken(findStateGroup(state, group), group.id)
  ));
  const allGroupsAreImplicitlyFree = Array.isArray(state?.groups)
    && state.groups.length > 0
    && state.groups.every((group) =>
      group.status === PARAMETER_STATUS.DEFAULT && !group.constraintLabel
    );
  return allGroupsAreImplicitlyFree
    ? { ...display, text: "", collapsed: true }
    : display;
}

function pValueStars(value) {
  const pValue = normalizeNumber(value);
  if (typeof pValue !== "number") return "";
  if (pValue < 0.001) return "***";
  if (pValue < 0.01) return "**";
  if (pValue < 0.05) return "*";
  return "";
}

function estimateKind(estimates, standardized) {
  if (!estimates) return "missing";
  if (standardized && estimates.fixedUnderStd) return "fixedUnderStd";
  if (estimates.displayClass === "hasEstStd") {
    return standardized ? "free" : "fixed";
  }
  if (estimates.displayClass === "hasEstFixed") {
    return "fixed";
  }
  return "free";
}

function estimateField(estimates, field, standardized) {
  return estimates?.[`${field}${standardized ? "_std" : ""}`];
}

export function formatEstimateToken(
  estimates,
  { viewOption = "est", standardized = false, digits = 2 } = {},
  groupId = "missing",
) {
  const kind = estimateKind(estimates, standardized);
  if (kind === "missing") {
    return {
      text: "NA",
      key: `missing:${String(groupId)}`,
      preventCollapse: true,
    };
  }

  if (kind === "fixed" || kind === "fixedUnderStd") {
    const field = kind === "fixedUnderStd"
      ? "est"
      : "estFixed";
    const value = estimateField(estimates, field, standardized);
    return {
      text: `@${numberText(value, digits)}`,
      key: serializedKey([kind, semanticValue(value)]),
      preventCollapse: value == null,
    };
  }

  const estimate = estimateField(estimates, "est", standardized);
  let text;
  let visibleValues;
  if (viewOption === "ci") {
    const low = estimateField(estimates, "ciLow", standardized);
    const high = estimateField(estimates, "ciHigh", standardized);
    text = `[${numberText(low, digits)}, ${numberText(high, digits)}]`;
    visibleValues = [semanticValue(low), semanticValue(high)];
  } else if (viewOption === "estPVal") {
    const pValue = estimateField(estimates, "p_value", standardized);
    text = `${numberText(estimate, digits)}${pValueStars(pValue)}`;
    visibleValues = [semanticValue(estimate), semanticValue(pValue)];
  } else if (viewOption === "estSE") {
    const standardError = estimateField(estimates, "se", standardized);
    text = `${numberText(estimate, digits)} (${numberText(
      standardError,
      digits,
    )})`;
    visibleValues = [semanticValue(estimate), semanticValue(standardError)];
  } else {
    text = numberText(estimate, digits);
    visibleValues = [semanticValue(estimate)];
  }

  return {
    text,
    key: serializedKey([kind, viewOption, visibleValues]),
    preventCollapse: visibleValues.some(
      (value) => value.length === 1 && value[0] === "missing",
    ),
  };
}

export function formatGroupEstimateDisplay(
  orderedGroups,
  estimatesByGroup,
  options = {},
  parameterState = null,
) {
  if (!Array.isArray(orderedGroups) || orderedGroups.length === 0) {
    return { text: "", collapsed: false, tokens: [] };
  }

  return collapseOrderedGroupTokens(orderedGroups.map((group) => {
    const estimateToken = formatEstimateToken(
      estimatesByGroup?.[String(group.id)],
      options,
      group.id,
    );
    const constraintLabel = findStateGroup(
      parameterState,
      group,
    )?.constraintLabel;
    return constraintLabel
      ? {
        ...estimateToken,
        text: `=${constraintLabel} ${estimateToken.text}`,
        key: serializedKey([constraintLabel, estimateToken.key]),
      }
      : estimateToken;
  }));
}

export function commonGroupConstraintLabel(state, orderedGroups) {
  if (!state || !Array.isArray(orderedGroups) || orderedGroups.length === 0) {
    return null;
  }
  const labels = orderedGroups.map(
    (group) => findStateGroup(state, group)?.constraintLabel || null,
  );
  return labels[0] && labels.every((label) => label === labels[0])
    ? labels[0]
    : null;
}
