import TwoPersonGamesLemmaCanonicalLaneLean.AdmissibleClass

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

/-- The bridge condition: the admitted object contains a Nash equilibrium. -/
def bridgeClosed (A : AdmissibleClass) : Prop :=
  HasNashEquilibrium A.object.game

/-- Every admissible class supplies the bridge. -/
theorem bridge_from_admissible_class (A : AdmissibleClass) :
    bridgeClosed A := by
  exact A.object.conclusion

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse