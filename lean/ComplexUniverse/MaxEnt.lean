import ComplexUniverse.Entropy

/-!
# The maximum-entropy inference problem

The move ensemble, constraints (C1)–(C3), and the Gibbs-form conjecture
(paper, Sec. max-ent). Statements only; the derivation session is pending.
-/

namespace ComplexUniverse

open scoped BigOperators

/-- Moves available at a state: every vertex may sprout; every unfilled
inner horn may be filled (paper, Def. move ensemble). -/
def legalMoves (u : Universe) : Finset Move :=
  (Finset.range u.nVertices).image Move.sprout ∪
    u.unfilledHorns.toFinset.image (fun (e₁, e₂) => Move.fill e₁ e₂)

/-- A max-ent problem instance: a cost function `k` on moves (depending
only on tower level, per the paper) and the budget `R` (Axiom: Budget). -/
structure MaxEntProblem (u : Universe) where
  cost : Move → ℝ
  budget : ℝ

/-- Shannon entropy of a distribution over the available moves. -/
noncomputable def shannon (u : Universe) (q : Move → ℝ) : ℝ :=
  - ∑ m ∈ legalMoves u, q m * Real.log (q m)

/-- (C1) normalization. -/
def normalized (u : Universe) (q : Move → ℝ) : Prop :=
  ∑ m ∈ legalMoves u, q m = 1

/-- (C2) budget: expected cost equals `R`. -/
def budgeted (u : Universe) (P : MaxEntProblem u) (q : Move → ℝ) : Prop :=
  ∑ m ∈ legalMoves u, q m * P.cost m = P.budget

/-- (C3) locality/homogeneity: `q` is constant on local-neighborhood
isomorphism classes, given here via an explicit equivalence on moves.
The precise neighborhood relation is a design choice — flagged in the
paper: it must not smuggle in a preferred scale. -/
def locallyHomogeneous (q : Move → ℝ) (rel : Move → Move → Prop) : Prop :=
  ∀ m m', rel m m' → q m = q m'

/-- Gibbs form: `q(m) = Z⁻¹ exp(-λ k(m))` for a single multiplier `λ`. -/
def GibbsForm (u : Universe) (P : MaxEntProblem u) (q : Move → ℝ) : Prop :=
  ∃ lam Z : ℝ, Z ≠ 0 ∧ ∀ m ∈ legalMoves u,
    q m = (1 / Z) * Real.exp (-lam * P.cost m)

/-- **Conjecture (Gibbs rule).** Among nonneg, normalized, budgeted,
local distributions there is a unique entropy maximizer, and it has
Gibbs form. Danger flagged in the paper: whether (C3) can be formulated
without smuggling in a preferred scale. Derivation session pending. -/
theorem gibbs_rule (u : Universe) (P : MaxEntProblem u) (rel : Move → Move → Prop) :
    ∃! q : Move → ℝ,
      (∀ m ∈ legalMoves u, 0 ≤ q m) ∧
      normalized u q ∧ budgeted u P q ∧ locallyHomogeneous q rel ∧
      (∀ q', (∀ m ∈ legalMoves u, 0 ≤ q' m) →
        normalized u q' → budgeted u P q' → locallyHomogeneous q' rel →
        shannon u q ≤ shannon u q') ∧
      GibbsForm u P q := by
  sorry

end ComplexUniverse
