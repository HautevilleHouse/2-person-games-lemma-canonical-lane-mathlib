import TwoPersonGamesLemmaCanonicalLaneLean.BridgeLemmas

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

/-- The gate condition: the endpoint is satisfied or the remainder is recorded. -/
def gateClosed (A : AdmissibleClass) : Prop :=
  A.endpointSatisfied ∨ A.remainderRecorded

theorem gate_from_admissible_class (A : AdmissibleClass) :
    gateClosed A := by
  exact A.gateWitness

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse