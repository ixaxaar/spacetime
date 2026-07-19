import ComplexUniverse.Universe

/-!
# Moves: sprout and fill

The two local, non-deleting rewrite rules (paper, Axiom: Dynamics),
plus the stochastic tick/run loop mirroring the Python sim.
-/

namespace ComplexUniverse

/-- Sprout at vertex `v`: new event, new vertex `w`, new edge `v → w`.
Parents of the new event: `{creator(v)}`. Mirrors `Universe.sprout`. -/
def sprout (u : Universe) (v : ℕ) : Universe :=
  let ev := u.nEvents
  let w  := u.nVertices
  { parents       := u.parents.push {u.vertexCreator.getD v 0}
    vertexCreator := u.vertexCreator.push ev
    edges         := u.edges.push (v, w, ev)
    filled        := u.filled }

/-- Fill horn `(e₁, e₂)`: new event, new composite edge `u → w`; mark the
horn filled. Parents: `{creator(e₁), creator(e₂)}`. No explicit 2-cell is
stored: in this toy the composite edge is the filling data (as in the sim). -/
def fill (u : Universe) (e₁ e₂ : ℕ) : Universe :=
  let ev := u.nEvents
  let (uSrc, _, c₁) := u.edges.getD e₁ (0, 0, 0)
  let (_, wDst, c₂) := u.edges.getD e₂ (0, 0, 0)
  { parents       := u.parents.push {c₁, c₂}
    vertexCreator := u.vertexCreator
    edges         := u.edges.push (uSrc, wDst, ev)
    filled        := insert (e₁, e₂) u.filled }

/-- The two move types. -/
inductive Move where
  | sprout (v : ℕ)
  | fill   (e₁ e₂ : ℕ)
deriving DecidableEq, Repr

/-- One stochastic tick, mirroring `Universe.tick`: if no horns are
available, sprout; otherwise sprout with probability `pSprout / 1000`
and fill a uniformly chosen horn otherwise. -/
def tick (u : Universe) (gen : StdGen) (pSprout : ℕ := 500) : Universe × StdGen :=
  let horns := u.unfilledHorns
  let (r, gen₁) := randNat gen 0 999
  if horns.isEmpty || r < pSprout then
    let (v, gen₂) := randNat gen₁ 0 (u.nVertices - 1)
    (sprout u v, gen₂)
  else
    let (i, gen₂) := randNat gen₁ 0 (horns.length - 1)
    let (e₁, e₂) := horns.getD i (0, 0)
    (fill u e₁ e₂, gen₂)

/-- Run `nTicks` ticks from the big bang. Deterministic given `seed`;
the state after `t` ticks has `t + 1` events (event 0 is the big bang). -/
def runTicks (nTicks : ℕ) (seed : ℕ) (pSprout : ℕ := 500) : Universe :=
  go nTicks Universe.initial (mkStdGen seed)
where
  go : ℕ → Universe → StdGen → Universe
    | 0, u, _ => u
    | fuel + 1, u, gen =>
        let (u', gen') := tick u gen pSprout
        go fuel u' gen'

end ComplexUniverse
