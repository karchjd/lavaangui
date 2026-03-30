export function showMathNotation() {
  bootbox.alert({
    title: "Math Notation for Display Labels",
    className: "dialogWide",
    message: `
        <p>Display labels (set via right-click) support LaTeX-style notation that is
        converted to Unicode. This is cosmetic only and does not affect lavaan syntax.</p>

        <h5>Greek Letters</h5>
        <table class="table table-sm table-bordered" style="width: auto;">
          <tr>
            <td><code>\\alpha</code> → α</td>
            <td><code>\\beta</code> → β</td>
            <td><code>\\gamma</code> → γ</td>
            <td><code>\\delta</code> → δ</td>
            <td><code>\\epsilon</code> → ε</td>
          </tr>
          <tr>
            <td><code>\\zeta</code> → ζ</td>
            <td><code>\\eta</code> → η</td>
            <td><code>\\theta</code> → θ</td>
            <td><code>\\iota</code> → ι</td>
            <td><code>\\kappa</code> → κ</td>
          </tr>
          <tr>
            <td><code>\\lambda</code> → λ</td>
            <td><code>\\mu</code> → μ</td>
            <td><code>\\nu</code> → ν</td>
            <td><code>\\xi</code> → ξ</td>
            <td><code>\\pi</code> → π</td>
          </tr>
          <tr>
            <td><code>\\rho</code> → ρ</td>
            <td><code>\\sigma</code> → σ</td>
            <td><code>\\tau</code> → τ</td>
            <td><code>\\phi</code> → φ</td>
            <td><code>\\chi</code> → χ</td>
          </tr>
          <tr>
            <td><code>\\psi</code> → ψ</td>
            <td><code>\\omega</code> → ω</td>
            <td colspan="3"></td>
          </tr>
        </table>

        <p>Uppercase variants are also available: <code>\\Gamma</code> → Γ, <code>\\Delta</code> → Δ,
        <code>\\Theta</code> → Θ, <code>\\Lambda</code> → Λ, <code>\\Xi</code> → Ξ, <code>\\Pi</code> → Π,
        <code>\\Sigma</code> → Σ, <code>\\Phi</code> → Φ, <code>\\Psi</code> → Ψ, <code>\\Omega</code> → Ω</p>

        <h5>Subscripts &amp; Superscripts</h5>
        <table class="table table-sm table-bordered" style="width: auto;">
          <tr><th>Input</th><th>Result</th><th>Notes</th></tr>
          <tr><td><code>x_1</code></td><td>x₁</td><td>Single digit or letter after <code>_</code></td></tr>
          <tr><td><code>x_{12}</code></td><td>x₁₂</td><td>Use braces for multiple characters</td></tr>
          <tr><td><code>x^2</code></td><td>x²</td><td>Single digit or letter after <code>^</code></td></tr>
          <tr><td><code>x^{23}</code></td><td>x²³</td><td>Use braces for multiple characters</td></tr>
        </table>
        <p>Subscript digits: 0–9. Subscript letters: a, e, h, i, j, k, l, m, n, o, p, r, s, t, u, v, x.<br>
        Superscript digits: 0–9. Superscript letters: n, i.</p>

        <h5>Math Symbols</h5>
        <table class="table table-sm table-bordered" style="width: auto;">
          <tr>
            <td><code>\\infty</code> → ∞</td>
            <td><code>\\pm</code> → ±</td>
            <td><code>\\times</code> → ×</td>
            <td><code>\\cdot</code> → ·</td>
          </tr>
          <tr>
            <td><code>\\leq</code> → ≤</td>
            <td><code>\\geq</code> → ≥</td>
            <td><code>\\neq</code> → ≠</td>
            <td><code>\\approx</code> → ≈</td>
          </tr>
          <tr>
            <td><code>\\sim</code> → ∼</td>
            <td><code>\\propto</code> → ∝</td>
            <td><code>\\partial</code> → ∂</td>
            <td><code>\\nabla</code> → ∇</td>
          </tr>
          <tr>
            <td><code>\\sum</code> → ∑</td>
            <td><code>\\prod</code> → ∏</td>
            <td><code>\\sqrt</code> → √</td>
            <td><code>\\forall</code> → ∀</td>
          </tr>
          <tr>
            <td><code>\\exists</code> → ∃</td>
            <td><code>\\rightarrow</code> → →</td>
            <td><code>\\leftarrow</code> → ←</td>
            <td><code>\\leftrightarrow</code> → ↔</td>
          </tr>
        </table>

        <h5>Line Breaks</h5>
        <p>Use <code>\\n</code> to insert a line break in a display label. For example, <code>Factor\\n\\alpha</code> displays as:<br>
        Factor<br>α</p>

        <h5>Examples</h5>
        <table class="table table-sm table-bordered" style="width: auto;">
          <tr><th>You type</th><th>Displayed as</th></tr>
          <tr><td><code>\\lambda_1</code></td><td>λ₁</td></tr>
          <tr><td><code>\\beta_{12}</code></td><td>β₁₂</td></tr>
          <tr><td><code>\\sigma^2</code></td><td>σ²</td></tr>
          <tr><td><code>\\Sigma_{xx}</code></td><td>Σₓₓ</td></tr>
          <tr><td><code>Factor \\alpha</code></td><td>Factor α</td></tr>
        </table>
      `,
  });
}
