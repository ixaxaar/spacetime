import ComplexUniverse.CausalOrder

/-!
# Entropy

The linear-extension count (exact DP over down-set masks) and the
causal-past entropy `S(e) = log #Ext(J⁻(e))` (paper, Def. entropy).
-/

namespace ComplexUniverse

/-- Exact linear-extension count of the poset given by direct parent sets.
DP over masks in increasing numeric order (valid since `mask \ {i} < mask`),
mirroring `count_linear_extensions` in the sim. Returns 0 above 62 events
(bitmask guard; the toy regime is ~20 events). -/
def countLinExt (parents : Array (Finset ℕ)) : ℕ := Id.run do
  let n := parents.size
  if n ≥ 63 then return 0
  let pmasks : Array ℕ := parents.map fun ps => (ps.sort (· ≤ ·)).foldl (fun m p => m ||| (1 <<< p)) 0
  let mut f : Array ℕ := Array.replicate (1 <<< n) 0
  f := f.set! 0 1
  for mask in [1 : 1 <<< n] do
    let mut c := 0
    for i in [0 : n] do
      let bit := 1 <<< i
      if mask &&& bit != 0 then
        let prev := mask - bit
        if prev &&& pmasks[i]! == pmasks[i]! then
          c := c + f[prev]!
    f := f.set! mask c
  return f[(1 <<< n) - 1]!

/-- Restriction of the parent presentation to a subset of events,
reindexed contiguously (the DP needs indices `0 .. n-1`). -/
def subParents (u : Universe) (S : Finset ℕ) : Array (Finset ℕ) :=
  let elts := S.sort (· ≤ ·)
  let idx (e : ℕ) : ℕ := elts.idxOf e
  elts.toArray.map fun e => (u.parents.getD e ∅ ∩ S).image idx

/-- Number of linear extensions of the causal past `J⁻(e)`.
This is the load-bearing quantity; entropy is its log. -/
def extCount (u : Universe) (e : ℕ) : ℕ :=
  countLinExt (subParents u (causalPast u e))

/-- Causal-past entropy `S(e) = log #Ext(J⁻(e))`. -/
noncomputable def entropyAt (u : Universe) (e : ℕ) : ℝ :=
  Real.log (extCount u e : ℝ)

/-- Whole-history entropy after the run, as plotted in the sim. -/
noncomputable def entropy (u : Universe) : ℝ :=
  Real.log (countLinExt u.parents : ℝ)

end ComplexUniverse
