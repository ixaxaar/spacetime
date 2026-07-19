import ComplexUniverse.Entropy

/-!
# Lemmas (statements only)

Per project policy (CLAUDE.md rule 1): the human writes the proofs;
all proofs here are `sorry` stubs with the attack surface noted.
-/

namespace ComplexUniverse

/-- **Lemma (monotonicity), count form.** `e ≤ e'` implies
`#Ext(J⁻(e)) ≤ #Ext(J⁻(e'))`.

Attack surface: the injection from extensions of a down-set into
extensions of the ambient poset (fix any valid order of the complement
and append). Check `subParents` reindexing preserves the count.
Owner: ixaxaar. -/
theorem extCount_monotone (u : Universe) (_wf : WellFormed u) {e e' : ℕ}
    (h : CausalLE u e e') : extCount u e ≤ extCount u e' := by
  sorry

/-- **Lemma (monotonicity), entropy form.** Follows from the count form
since `Real.log` is monotone; stated separately for paper use. -/
theorem entropy_monotone (u : Universe) (wf : WellFormed u) {e e' : ℕ}
    (h : CausalLE u e e') : entropyAt u e ≤ entropyAt u e' := by
  sorry

/-- **Lemma (foliation invariance).** The extension count depends only on
the isomorphism class of the presentation.

Attack surface: `relabel` is defined with a bijection on all of ℕ, while
the paper needs only a permutation of the events — check the statements
actually match the paper's claim. Owner: ixaxaar. -/
theorem foliation_invariant {P Q : Array (Finset ℕ)} (i : EventIso P Q) :
    countLinExt P = countLinExt Q := by
  sorry

/-- Well-formedness of the initial state and its preservation under the
moves — needed for the causal partial order to survive evolution. -/
theorem wellformed_initial : WellFormed Universe.initial := by
  sorry

theorem wellformed_sprout (u : Universe) (wf : WellFormed u) (v : ℕ) :
    WellFormed (sprout u v) := by
  sorry

theorem wellformed_fill (u : Universe) (wf : WellFormed u) (e₁ e₂ : ℕ) :
    WellFormed (fill u e₁ e₂) := by
  sorry

end ComplexUniverse
