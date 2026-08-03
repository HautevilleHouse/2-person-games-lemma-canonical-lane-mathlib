import Mathlib.Data.Real.Basic

/-!
# Two Person Games Lemma Package
-/

namespace TwoPersonGamesLemmaCanonicalLaneLean

structure TwoPersonGame where
  A : Type
  B : Type
  payoff1 : A → B → ℝ
  payoff2 : A → B → ℝ

structure TwoPersonGamesLemmaPackage (G : TwoPersonGame) where
  nashEquilibriumExists : Prop
  minimaxEquality : Prop
  bargainingSolutionExists : Prop

structure TwoPersonGamesLemmaEvidence {G : TwoPersonGame}
    (N : TwoPersonGamesLemmaPackage G) where
  nashEquilibriumExistsClosed : N.nashEquilibriumExists
  minimaxEqualityClosed : N.minimaxEquality
  bargainingSolutionExistsClosed : N.bargainingSolutionExists

def TwoPersonGamesLemmaClosed {G : TwoPersonGame}
    (N : TwoPersonGamesLemmaPackage G) : Prop :=
  N.nashEquilibriumExists ∧ N.minimaxEquality ∧ N.bargainingSolutionExists

theorem two_person_games_lemma_closed_from_evidence
    {G : TwoPersonGame} (N : TwoPersonGamesLemmaPackage G)
    (E : TwoPersonGamesLemmaEvidence N) :
    TwoPersonGamesLemmaClosed N := by
  exact And.intro E.nashEquilibriumExistsClosed
    (And.intro E.minimaxEqualityClosed E.bargainingSolutionExistsClosed)

end TwoPersonGamesLemmaCanonicalLaneLean