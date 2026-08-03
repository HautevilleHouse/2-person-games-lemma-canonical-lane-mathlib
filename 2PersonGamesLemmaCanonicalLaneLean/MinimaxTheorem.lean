import HautevilleHouse.2PersonGamesLemmaCanonicalLaneLean.TwoPlayerGame

/-!
# Minimax Theorem Package
-/

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

structure MinimaxTheoremPackage (G : TwoPlayerGamePackage) where
  zeroSumCondition : Prop
  mixedStrategies : Prop
  valueOfGame : Prop
  saddlePoint : Prop

structure MinimaxTheoremEvidence {G : TwoPlayerGamePackage}
    (M : MinimaxTheoremPackage G) where
  zeroSumConditionClosed : M.zeroSumCondition
  mixedStrategiesClosed : M.mixedStrategies
  valueOfGameClosed : M.valueOfGame
  saddlePointClosed : M.saddlePoint

def MinimaxTheoremClosed {G : TwoPlayerGamePackage}
    (M : MinimaxTheoremPackage G) : Prop :=
  M.zeroSumCondition ∧ M.mixedStrategies ∧ M.valueOfGame ∧ M.saddlePoint

theorem minimax_theorem_closed_from_evidence
    {G : TwoPlayerGamePackage} (M : MinimaxTheoremPackage G)
    (E : MinimaxTheoremEvidence M) : MinimaxTheoremClosed M := by
  exact And.intro E.zeroSumConditionClosed
    (And.intro E.mixedStrategiesClosed
      (And.intro E.valueOfGameClosed E.saddlePointClosed))

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse