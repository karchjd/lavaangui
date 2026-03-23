// Unicode substitution for common math notation in display labels.
// Supports Greek letters (\alpha, \Alpha, etc.), subscripts (_0 .. _9, _a .. _z),
// superscripts (^0 .. ^9), and a few common math symbols.

const greekLower = {
  "\\alpha": "α", "\\beta": "β", "\\gamma": "γ", "\\delta": "δ",
  "\\epsilon": "ε", "\\varepsilon": "ε", "\\zeta": "ζ", "\\eta": "η",
  "\\theta": "θ", "\\vartheta": "ϑ", "\\iota": "ι", "\\kappa": "κ",
  "\\lambda": "λ", "\\mu": "μ", "\\nu": "ν", "\\xi": "ξ",
  "\\omicron": "ο", "\\pi": "π", "\\rho": "ρ", "\\sigma": "σ",
  "\\tau": "τ", "\\upsilon": "υ", "\\phi": "φ", "\\varphi": "φ",
  "\\chi": "χ", "\\psi": "ψ", "\\omega": "ω",
};

const greekUpper = {
  "\\Gamma": "Γ", "\\Delta": "Δ", "\\Theta": "Θ", "\\Lambda": "Λ",
  "\\Xi": "Ξ", "\\Pi": "Π", "\\Sigma": "Σ", "\\Upsilon": "Υ",
  "\\Phi": "Φ", "\\Psi": "Ψ", "\\Omega": "Ω",
};

const symbols = {
  "\\infty": "∞", "\\pm": "±", "\\mp": "∓", "\\times": "×",
  "\\cdot": "·", "\\leq": "≤", "\\geq": "≥", "\\neq": "≠",
  "\\approx": "≈", "\\sim": "∼", "\\propto": "∝",
  "\\rightarrow": "→", "\\leftarrow": "←", "\\leftrightarrow": "↔",
  "\\Rightarrow": "⇒", "\\Leftarrow": "⇐",
  "\\partial": "∂", "\\nabla": "∇", "\\sum": "∑", "\\prod": "∏",
  "\\sqrt": "√", "\\forall": "∀", "\\exists": "∃",
};

const allReplacements = { ...greekLower, ...greekUpper, ...symbols };

// Sorted longest-first so e.g. \varepsilon matches before \epsilon
const sortedKeys = Object.keys(allReplacements).sort((a, b) => b.length - a.length);
const commandRegex = new RegExp(
  sortedKeys.map(k => k.replace(/\\/g, "\\\\")).join("|"),
  "g"
);

const subscriptDigits = { "0": "₀", "1": "₁", "2": "₂", "3": "₃", "4": "₄", "5": "₅", "6": "₆", "7": "₇", "8": "₈", "9": "₉" };
const subscriptLetters = {
  "a": "ₐ", "e": "ₑ", "h": "ₕ", "i": "ᵢ", "j": "ⱼ", "k": "ₖ",
  "l": "ₗ", "m": "ₘ", "n": "ₙ", "o": "ₒ", "p": "ₚ", "r": "ᵣ",
  "s": "ₛ", "t": "ₜ", "u": "ᵤ", "v": "ᵥ", "x": "ₓ",
};
const superscriptChars = {
  "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴", "5": "⁵",
  "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹", "n": "ⁿ", "i": "ⁱ",
};

function replaceSubscripts(str) {
  // _{...} form (braces)
  str = str.replace(/_\{([^}]+)\}/g, (_, content) => {
    return content.split("").map(c => subscriptDigits[c] || subscriptLetters[c] || c).join("");
  });
  // _X single character
  str = str.replace(/_([a-z0-9])/gi, (_, c) => {
    return subscriptDigits[c] || subscriptLetters[c] || "_" + c;
  });
  return str;
}

function replaceSuperscripts(str) {
  // ^{...} form (braces)
  str = str.replace(/\^\{([^}]+)\}/g, (_, content) => {
    return content.split("").map(c => superscriptChars[c] || c).join("");
  });
  // ^X single character
  str = str.replace(/\^([a-z0-9])/gi, (_, c) => {
    return superscriptChars[c] || "^" + c;
  });
  return str;
}

/**
 * Convert a display label string with LaTeX-style notation to Unicode.
 * E.g. "\\alpha_1" → "α₁", "\\beta_{12}" → "β₁₂", "x^2" → "x²"
 */
export function toUnicodeMath(str) {
  if (!str) return str;
  let result = str;
  // Replace LaTeX commands (Greek letters, symbols)
  result = result.replace(commandRegex, match => allReplacements[match]);
  // Replace sub/superscripts
  result = replaceSubscripts(result);
  result = replaceSuperscripts(result);
  return result;
}
