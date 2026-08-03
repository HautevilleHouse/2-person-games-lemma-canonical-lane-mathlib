import HautevilleHouse.2PersonGamesLemmaCanonicalLaneLean.MinimaxTheorem

/-!
# Nash Equilibrium Package
-/

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

structure NashEquilibriumPackage {G : TwoPlayerGamePackage}
    {M : MinimaxTheoremPackage G} (N : NashExistencePackage M) where
  finiteStrategy : Prop
  mixedStrategiesAllowed : Prop
  bestResponseClosed : Prop
  fixedPointExists : Prop

structure NashEquilibriumEvidence {G : TwoPlayerGamePackage}
    {M : MinimaxTheoremPackage G} {N : NashExistencePackage M}
    (NE : NashEquilibriumPackage N) where
  finiteStrategyClosed : NE.finiteStrategy
  mixedStrategiesAllowedClosed : NE.mixedStrategiesAllowed
  bestResponseClosedClosed : NE.bestResponseClosed
  fixedPointExistsClosed : NE.fixedPointExists

def NashEquilibriumClosed {G : TwoPlayerGamePackage}
    {M : MinimaxTheoremPackage G} {N : NashExistencePackage M}
    (NE : NashEquilibriumPackage N) : Prop :=
  NE.finiteStrategy ∧ NE.mixedStrategiesAllowed ∧ NE.bestResponseClosed ∧ NE.fixedPointExists

theorem nash_equilibrium_closed_from_evidence
    {G : TwoPlayerGamePackage} {M : MinimaxTheoremPackage G} {N : NashExistencePackage M}
    (NE : NashEquilibriumPackage N) (E : NashEquilibriumEvidence NE) :
    NashEquilibriumClosed NE := by
  exact And.intro E.finiteStrategyClosed
    (And.intro E.mixedStrategiesAllowedClosed
      (And.intro E.bestResponseClosedClosed E.fixedPointExistsClosed))

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse