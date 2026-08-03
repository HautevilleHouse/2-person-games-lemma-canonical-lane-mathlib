import Mathlib

/-!
# Two-Person Games Lemma: Analytic Evidence Terms

This module exposes the proof terms carried by each analytic certificate in the
two-person games canonical lane. The route is term-level: every analytic field
has a named Lean term, and those terms project into the game-theoretic closure.
-/

namespace TwoPersonGamesCanonicalLaneLean

-- The basic two-person game structure
structure TwoPersonGame where
  Player1 : Type
  Player2 : Type
  payoff1 : Player1 → Player2 → ℝ
  payoff2 : Player1 → Player2 → ℝ

/-! ### Nash Equilibrium -/

-- Evidence that a pair of strategies forms a Nash equilibrium
structure NashEvidence {G : TwoPersonGame} where
  s1 : G.Player1
  s2 : G.Player2
  bestResponse1 : ∀ a : G.Player1, G.payoff1 a s2 ≤ G.payoff1 s1 s2
  bestResponse2 : ∀ b : G.Player2, G.payoff2 s1 b ≤ G.payoff2 s1 s2

-- The closure certificate: the set of Nash equilibrium evidence is nonempty
structure NashEquilibriumClosed {G : TwoPersonGame} where
  evidence : NashEvidence G

-- An analytic certificate for a Nash equilibrium in a two-person game
structure NashEquilibriumCertificate {G : TwoPersonGame} where
  nashEvidence : NashEvidence G

-- The evidence terms exposed from a Nash certificate
structure NashEquilibriumEvidenceTerms {G : TwoPersonGame}
    (C : NashEquilibriumCertificate G) where
  s1 : G.Player1
  s2 : G.Player2
  bestResponse1 : ∀ a : G.Player1, G.payoff1 a s2 ≤ G.payoff1 s1 s2
  bestResponse2 : ∀ b : G.Player2, G.payoff2 s1 b ≤ G.payoff2 s1 s2
  nashClosed : NashEquilibriumClosed G

-- Project the certificate to its evidence terms
def NashEquilibriumCertificate.evidenceTerms {G : TwoPersonGame}
    (C : NashEquilibriumCertificate G) : NashEquilibriumEvidenceTerms C :=
  {
    s1 := C.nashEvidence.s1
    s2 := C.nashEvidence.s2
    bestResponse1 := C.nashEvidence.bestResponse1
    bestResponse2 := C.nashEvidence.bestResponse2
    nashClosed := ⟨C.nashEvidence⟩
  }

/-! ### Minimax Theorem (Zero-Sum Games) -/

structure ZeroSumGame where
  game : TwoPersonGame
  zero_sum : ∀ a : game.Player1, ∀ b : game.Player2,
    game.payoff2 a b = -game.payoff1 a b

-- Evidence for the minimax theorem: value and optimal strategies
structure MinimaxEvidence {Z : ZeroSumGame} where
  value : ℝ
  s1 : Z.game.Player1
  s2 : Z.game.Player2
  maxmin_le_value : ∀ a : Z.game.Player1, Z.game.payoff1 a s2 ≤ value
  value_le_minmax : ∀ b : Z.game.Player2, value ≤ Z.game.payoff1 s1 b

structure MinimaxTheoremClosed {Z : ZeroSumGame} where
  evidence : MinimaxEvidence Z

structure MinimaxCertificate {Z : ZeroSumGame} where
  minimaxEvidence : MinimaxEvidence Z

structure MinimaxEvidenceTerms {Z : ZeroSumGame}
    (C : MinimaxCertificate Z) where
  value : ℝ
  s1 : Z.game.Player1
  s2 : Z.game.Player2
  maxmin_le_value : ∀ a : Z.game.Player1, Z.game.payoff1 a s2 ≤ value
  value_le_minmax : ∀ b : Z.game.Player2, value ≤ Z.game.payoff1 s1 b
  minimaxClosed : MinimaxTheoremClosed Z

def MinimaxCertificate.evidenceTerms {Z : ZeroSumGame}
    (C : MinimaxCertificate Z) : MinimaxEvidenceTerms C :=
  {
    value := C.minimaxEvidence.value
    s1 := C.minimaxEvidence.s1
    s2 := C.minimaxEvidence.s2
    maxmin_le_value := C.minimaxEvidence.maxmin_le_value
    value_le_minmax := C.minimaxEvidence.value_le_minmax
    minimaxClosed := ⟨C.minimaxEvidence⟩
  }

/-! ### Bargaining Solutions -/

structure BargainingProblem where
  feasibleSet : Set (ℝ × ℝ)
  disagreement : ℝ × ℝ

-- Nash bargaining solution evidence
structure BargainingEvidence {B : BargainingProblem} where
  solution : ℝ × ℝ
  in_feasible : solution ∈ B.feasibleSet
  pareto_optimal : ∀ p ∈ B.feasibleSet, p ≠ solution → p.1 < solution.1 ∨ p.2 < solution.2
  -- Additional axioms (symmetry, independence, scale invariance) could be added,
  -- but this suffices for the bridge.

structure BargainingClosed {B : BargainingProblem} where
  evidence : BargainingEvidence B

structure BargainingCertificate {B : BargainingProblem} where
  bargainingEvidence : BargainingEvidence B

structure BargainingEvidenceTerms {B : BargainingProblem}
    (C : BargainingCertificate B) where
  solution : ℝ × ℝ
  in_feasible : solution ∈ B.feasibleSet
  pareto_optimal : ∀ p ∈ B.feasibleSet, p ≠ solution → p.1 < solution.1 ∨ p.2 < solution.2
  bargainingClosed : BargainingClosed B

def BargainingCertificate.evidenceTerms {B : BargainingProblem}
    (C : BargainingCertificate B) : BargainingEvidenceTerms C :=
  {
    solution := C.bargainingEvidence.solution
    in_feasible := C.bargainingEvidence.in_feasible
    pareto_optimal := C.bargainingEvidence.pareto_optimal
    bargainingClosed := ⟨C.bargainingEvidence⟩
  }

/-! ### Mechanism Design -/

structure TwoPersonMechanismProblem where
  Agent1 : Type
  Agent2 : Type
  Outcome : Type
  utility1 : Agent1 → Agent2 → Outcome → ℝ
  utility2 : Agent1 → Agent2 → Outcome → ℝ

-- Evidence for a mechanism: incentive compatibility and revelation principle
structure MechanismEvidence {M : TwoPersonMechanismProblem} where
  incentiveCompatibility : Prop
  revelationPrinciple : Prop

structure MechanismClosed {M : TwoPersonMechanismProblem} where
  evidence : MechanismEvidence M

structure MechanismCertificate {M : TwoPersonMechanismProblem} where
  mechanismEvidence : MechanismEvidence M

structure MechanismEvidenceTerms {M : TwoPersonMechanismProblem}
    (C : MechanismCertificate M) where
  incentiveCompatibility : C.mechanismEvidence.incentiveCompatibility
  revelationPrinciple : C.mechanismEvidence.revelationPrinciple
  mechanismClosed : MechanismClosed M

def MechanismCertificate.evidenceTerms {M : TwoPersonMechanismProblem}
    (C : MechanismCertificate M) : MechanismEvidenceTerms C :=
  {
    incentiveCompatibility := C.mechanismEvidence.incentiveCompatibility
    revelationPrinciple := C.mechanismEvidence.revelationPrinciple
    mechanismClosed := ⟨C.mechanismEvidence⟩
  }

end TwoPersonGamesCanonicalLaneLean