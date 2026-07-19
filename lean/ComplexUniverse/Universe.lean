import Mathlib

/-!
# State of the toy universe

A finite directed graph under construction, together with its construction
history (every event's parent set). Mirrors `sim/toy_universe.py`.
History is primary; spatial state is derived (paper, Axiom: Ontology).
-/

namespace ComplexUniverse

/-- State of the toy universe.

- `parents`: event id → the events it directly depends on
- `vertexCreator`: vertex → event that created it
- `edges`: (source, target, creating event)
- `filled`: horn pairs (by edge id) already filled -/
structure Universe where
  parents       : Array (Finset ℕ)
  vertexCreator : Array ℕ
  edges         : Array (ℕ × ℕ × ℕ)
  filled        : Finset (ℕ × ℕ)

/-- The big bang: event 0 creates vertex 0. -/
def Universe.initial : Universe where
  parents       := #[∅]
  vertexCreator := #[0]
  edges         := #[]
  filled        := ∅

/-- Number of events so far. -/
def Universe.nEvents (u : Universe) : ℕ := u.parents.size

/-- Number of vertices so far. -/
def Universe.nVertices (u : Universe) : ℕ := u.vertexCreator.size

/-- Unfilled inner horns: composable edge-id pairs `(e₁, e₂)` with
`dst(e₁) = src(e₂)` not yet filled. Each horn may be filled at most once
(the at-most-once convention is a flagged gap in the paper and here). -/
def Universe.unfilledHorns (u : Universe) : List (ℕ × ℕ) :=
  (List.range u.edges.size).flatMap fun e₁ =>
    (List.range u.edges.size).filterMap fun e₂ =>
      let (_, v₁, _) := u.edges[e₁]!
      let (u₂, _, _) := u.edges[e₂]!
      if v₁ = u₂ ∧ (e₁, e₂) ∉ u.filled then some (e₁, e₂) else none

end ComplexUniverse
