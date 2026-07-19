import ComplexUniverse.Moves

/-!
# Causal order

Events, dependency, causal pasts J⁻(e), and the partial-order structure
(paper, Def. causal order and Prop. well-definedness).
-/

namespace ComplexUniverse

/-- Well-formedness: every event's parents are strictly earlier events.
Holds by construction (event ids increase over time); the preservation
proofs are deferred to `Lemmas.lean` per project policy. -/
def WellFormed (u : Universe) : Prop :=
  ∀ i p, (h : i < u.parents.size) → p ∈ u.parents[i] → p < i

/-- Ancestors of `e` (the strict causal past): least fixed point of
"add parents". `n` iterations suffice since chains have length ≤ n. -/
def ancestors (u : Universe) (e : ℕ) : Finset ℕ :=
  let n := u.parents.size
  let step (s : Finset ℕ) : Finset ℕ :=
    s ∪ s.biUnion (fun i => if h : i < n then u.parents[i] else ∅)
  (Nat.iterate step n {e}) \ {e}

/-- The causal past `J⁻(e)`: `e` and all its ancestors. -/
def causalPast (u : Universe) (e : ℕ) : Finset ℕ :=
  ancestors u e ∪ {e}

/-- Causal order: `e` precedes `e'` iff `e ∈ J⁻(e')`. -/
def CausalLE (u : Universe) (e e' : ℕ) : Prop := e ∈ causalPast u e'

instance (u : Universe) (e e' : ℕ) : Decidable (CausalLE u e e') :=
  inferInstanceAs (Decidable (e ∈ causalPast u e'))

/-- The causal order is a partial order on the events
(paper, Prop. well-definedness). Reflexivity: `e ∈ J⁻(e)`.
Transitivity: causal pasts are down-sets. Antisymmetry: acyclicity from
`WellFormed` (creation-before-use). Proofs are the human's job. -/
@[reducible]
def causalPartialOrder (u : Universe) (_wf : WellFormed u) :
    PartialOrder (Fin u.nEvents) where
  le := fun e e' => CausalLE u e e'
  lt := fun e e' => CausalLE u e e' ∧ ¬ CausalLE u e' e
  le_refl := by sorry
  le_trans := by sorry
  le_antisymm := by sorry
  lt_iff_le_not_ge := by sorry

/-- Relabeling of event ids by a map on indices. -/
def relabel (σ : ℕ → ℕ) (P : Array (Finset ℕ)) : Array (Finset ℕ) :=
  P.map fun ps => ps.image σ

/-- Poset isomorphism of presentations: a bijection making parent sets
coincide. Note: bijectivity on all of ℕ is stronger than needed — a
permutation of the `n` events suffices; flagged for the human's proof. -/
structure EventIso (P Q : Array (Finset ℕ)) where
  σ : ℕ → ℕ
  bij : Function.Bijective σ
  relabeled : relabel σ P = Q

end ComplexUniverse
