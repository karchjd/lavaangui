export const GROUP_PARAMETERS_CLASS = "groupParameters";

export const PARAMETER_STATUS = Object.freeze({
  DEFAULT: "default",
  FIXED: "fixed",
  FORCE_FREE: "forceFree",
});

const DEFAULT_PARAMETER = Object.freeze({
  status: PARAMETER_STATUS.DEFAULT,
  value: null,
  constraintLabel: null,
});

function copyParameter(parameter = DEFAULT_PARAMETER) {
  return {
    status: Object.values(PARAMETER_STATUS).includes(parameter.status)
      ? parameter.status
      : PARAMETER_STATUS.DEFAULT,
    value: parameter.value ?? null,
    constraintLabel: parameter.constraintLabel || null,
  };
}

export function normalizeGroupList(rawGroups) {
  if (rawGroups == null) return [];

  let groups;
  if (Array.isArray(rawGroups)) {
    groups = rawGroups;
  } else if (
    typeof rawGroups === "object" &&
    ("id" in rawGroups || "label" in rawGroups)
  ) {
    groups = [rawGroups];
  } else if (typeof rawGroups === "object") {
    groups = Object.values(rawGroups);
  } else {
    groups = [rawGroups];
  }

  return groups
    .filter((group) => group != null)
    .map((group, index) => {
      if (typeof group === "object") {
        return {
          id: group.id ?? index + 1,
          label: String(group.label ?? group.id ?? index + 1),
        };
      }
      return { id: index + 1, label: String(group) };
    });
}

export function createGroupParameterState(
  existing,
  groupVariable,
  groups,
  fallback = DEFAULT_PARAMETER,
) {
  const normalizedGroups = normalizeGroupList(groups);
  const canReuse = existing?.groupVariable === groupVariable
    && Array.isArray(existing.groups);
  const previousByLabel = new Map(
    canReuse
      ? existing.groups.map((group) => [String(group.label), group])
      : [],
  );

  return {
    version: 1,
    groupVariable,
    groups: normalizedGroups.map((group) => ({
      ...group,
      ...copyParameter(previousByLabel.get(group.label) ?? fallback),
    })),
  };
}

export function alignGroupParameterState(existing, groupVariable, groups) {
  if (!existing || existing.groupVariable !== groupVariable) return null;
  return createGroupParameterState(
    existing,
    groupVariable,
    groups,
    DEFAULT_PARAMETER,
  );
}

export function applyGroupParameterOperation(state, selectedGroupIds, operation) {
  const selected = new Set(selectedGroupIds.map(String));
  return {
    ...state,
    groups: state.groups.map((group) => {
      if (!selected.has(String(group.id))) return { ...group };

      if (operation.type === "fix") {
        return {
          ...group,
          status: PARAMETER_STATUS.FIXED,
          value: operation.value,
        };
      }
      if (operation.type === "free") {
        return {
          ...group,
          status: PARAMETER_STATUS.DEFAULT,
          value: null,
        };
      }
      if (operation.type === "forceFree") {
        return {
          ...group,
          status: PARAMETER_STATUS.FORCE_FREE,
          value: null,
        };
      }
      if (operation.type === "setLabel") {
        return { ...group, constraintLabel: operation.label };
      }
      if (operation.type === "removeLabel") {
        return { ...group, constraintLabel: null };
      }
      throw new Error(`Unknown group parameter operation: ${operation.type}`);
    }),
  };
}

function vector(values) {
  return `c(${values.join(", ")})`;
}

function independentLabel(edgeId, groupId) {
  const edgePart = String(edgeId ?? "edge").replace(/[^a-zA-Z0-9._]/g, "_");
  const groupPart = String(groupId).replace(/[^a-zA-Z0-9._]/g, "_");
  return `lg_${edgePart}_${groupPart}`;
}

export function buildGroupModifierParts(state, edgeId) {
  if (!state?.groups?.length) return [];

  const modifiers = [];
  const hasStatusModifier = state.groups.some(
    (group) => group.status !== PARAMETER_STATUS.DEFAULT,
  );
  if (hasStatusModifier) {
    modifiers.push(vector(state.groups.map((group) =>
      group.status === PARAMETER_STATUS.FIXED
        ? String(group.value)
        : "NA"
    )));
  }

  const hasLabels = state.groups.some((group) => group.constraintLabel);
  if (hasLabels) {
    // Unique generated labels keep unchecked groups unconstrained. This also
    // works on lavaan releases that reject NA inside a label vector.
    modifiers.push(vector(state.groups.map((group) =>
      group.constraintLabel
        || independentLabel(edgeId, group.id)
    )));
  }

  return modifiers;
}

export function describeGroupParameter(group) {
  let description = "free";
  if (group.status === PARAMETER_STATUS.FIXED) {
    description = `fixed at ${group.value}`;
  } else if (group.status === PARAMETER_STATUS.FORCE_FREE) {
    description = "force free";
  }
  return group.constraintLabel
    ? `${description}; label ${group.constraintLabel}`
    : description;
}
