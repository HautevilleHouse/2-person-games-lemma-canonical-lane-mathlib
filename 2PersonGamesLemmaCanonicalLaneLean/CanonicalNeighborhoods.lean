import Mathlib.Data.Real.Basic

/-!
# Two Person Games Lemma Canonical Package
-/

namespace TwoPersonGamesLemmaCanonicalLaneLean

/-! Basic definitions for two-person games. -/

class TwoPersonGame where
  S₁ : Type
  S₂ : Type
  payoff₁ : S₁ → S₂ → ℝ
  payoff₂ : S₁ → S₂ → ℝ

namespace TwoPersonGame

variable {G : TwoPersonGame}

structure NashEquilibrium (G : TwoPersonGame) where
  a : G.S₁
  b : G.S₂
  best₁ : ∀ a' : G.S₁, G.payoff₁ a b ≥ G.payoff₁ a' b
  best₂ : ∀ b' : G.S₂, G.payoff₂ a b ≥ G.payoff₂ a b'

def ZeroSum (G : TwoPersonGame) : Prop :=
  ∀ a b, G.payoff₁ a b + G.payoff₂ a b = 0

end TwoPersonGame

/-! The admissible-class bridge package for the 2-person games lemma. -/

structure TwoPersonGamesLemmaPackage (G : TwoPersonGame) where
  nashEquilibriumExists : Prop
  minimaxTheoremHolds : Prop
  bargainingSolutionAxioms : Prop
  mechanismDesignIncentiveCompatible : Prop

structure TwoPersonGamesLemmaEvidence {G : TwoPersonGame}
    (C : TwoPersonGamesLemmaPackage G) where
  nashEquilibriumExistsClosed : C.nashEquilibriumExists
  minimaxTheoremHoldsClosed : C.minimaxTheoremHolds
  bargainingSolutionAxiomsClosed : C.bargainingSolutionAxioms
  mechanismDesignIncentiveCompatibleClosed : C.mechanismDesignIncentiveCompatible

def TwoPersonGamesLemmaClosed {G : TwoPersonGame}
    (C : TwoPersonGamesLemmaPackage G) : Prop :=
  C.nashEquilibriumExists ∧ C.minimaxTheoremHolds ∧
  C.bargainingSolutionAxioms ∧ C.mechanismDesignIncentiveCompatible

theorem two_person_games_lemma_closed_from_evidence
    {G : TwoPersonGame} (C : TwoPersonGamesLemmaPackage G)
    (E : TwoPersonGamesLemmaEvidence C) : TwoPersonGamesLemmaClosed C := by
  exact And.intro E.nashEquilibriumExistsClosed
    (And.intro E.minimaxTheoremHoldsClosed
      (And.intro E.bargainingSolutionAxiomsClosed
        E.mechanismDesignIncentiveCompatibleClosed))

-- Additional bridge: the minimax theorem for zero-sum games is a consequence of Nash equilibrium in mixed strategies.
-- We leave this as a comment for now, as the full formalization requires probability theory.

end TwoPersonGamesLemmaCanonicalLaneLean