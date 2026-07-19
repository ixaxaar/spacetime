import ComplexUniverse.MaxEnt

/-!
# Executable checks

Deterministic `native_decide` tests of the model's mechanics and of the
entropy's structural properties (invariants only — the Lean RNG differs
from the Python RNG, so pointwise comparison with `entropy_results.json`
is not meaningful; per CLAUDE.md, no pointwise-ordering claims anyway).
-/

namespace ComplexUniverse

/-- A chain poset has exactly one linear extension: S = 0. -/
example : countLinExt #[∅, {0}, {1}, {2}] = 1 := by native_decide

/-- An antichain of 5 events has 5! = 120 extensions. -/
example : countLinExt #[∅, ∅, ∅, ∅, ∅] = 120 := by native_decide

/-- One cause, two independent effects: 2 extensions. -/
example : countLinExt #[∅, {0}, {0}] = 2 := by native_decide

/-- Two chained sprouts create exactly one unfilled horn. -/
example :
    (sprout (sprout Universe.initial 0) 1).unfilledHorns = [(0, 1)] := by
  native_decide

/-- Filling marks the horn and adds the composite edge `0 → 2`. -/
example :
    let u := fill (sprout (sprout Universe.initial 0) 1) 0 1
    u.filled = {(0, 1)} ∧ u.edges.toList.any (fun e => e.1 == 0 && e.2.1 == 2) := by
  native_decide

/-- Causal past of the tip of a two-event chain. -/
example : causalPast (sprout (sprout Universe.initial 0) 1) 2 = {0, 1, 2} := by
  native_decide

/-- A chain universe has one extension at its tip: S = log 1 = 0. -/
example : extCount (sprout (sprout Universe.initial 0) 1) 2 = 1 := by
  native_decide

/-- Two sprouts from the same vertex: siblings are causally independent,
so the whole history has 2 extensions. -/
example : countLinExt (sprout (sprout Universe.initial 0) 0).parents = 2 := by
  native_decide

/-- Extension counts grow along a run (deterministic prefix property). -/
example :
    countLinExt (runTicks 6 7).parents ≤ countLinExt (runTicks 12 7).parents := by
  native_decide

/-- Second seed, same check. -/
example :
    countLinExt (runTicks 5 13).parents ≤ countLinExt (runTicks 11 13).parents := by
  native_decide

end ComplexUniverse
