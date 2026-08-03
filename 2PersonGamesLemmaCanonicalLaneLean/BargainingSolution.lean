import HautevilleHouse.2PersonGamesLemmaCanonicalLaneLean.NashEquilibrium

/-!
# Bargaining Solution Package
-/

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

structure BargainingSolutionPackage {G : TwoPlayerGamePackage}
    {M : MinimaxTheoremPackage G} {N : NashExistencePackage M}
    {NE : NashEquilibriumPackage N} (B : BargainingProblemPackage NE) where
  feasibleSet : Prop
  disagreementPoint : Prop
  paretoEfficiency : Prop
  symmetry : Prop
  scaleInvariance : Prop
  independence : Prop
  nashSolutionUnique : Prop

structure BargainingSolutionEvidence {G : TwoPlayerGamePackage}
    {M : MinimaxTheoremPackage G} {N : NashExistencePackage M}
    {NE : NashEquilibriumPackage N} {B : BargainingProblemPackage NE}
    (BS : BargainingSolutionPackage B) where
  feasibleSetClosed : BS.feasibleSet
  disagreementPointClosed : BS.disagreementPoint
  paretoEfficiencyClosed : BS.paretoEfficiency
  symmetryClosed : BS.symmetry
  scaleInvarianceClosed : BS.scaleInvariance
  independenceClosed : BS.independence
  nashSolutionUniqueClosed : BS.nashSolutionUnique

def BargainingSolutionClosed {G : TwoPlayerGamePackage}
    {M : MinimaxTheoremPackage G} {N : NashExistencePackage M}
    {NE : NashEquilibriumPackage N} {B : BargainingProblemPackage NE}
    (BS : BargainingSolutionPackage B) : Prop :=
  BS.feasibleSet ∧ BS.disagreementPoint ∧ BS.paretoEfficiency ∧ BS.symmetry ∧
  BS.scaleInvariance ∧ BS.independence ∧ BS.nashSolutionUnique

theorem bargaining_solution_closed_from_evidence
    {G : TwoPlayerGamePackage} {M : MinimaxTheoremPackage G} {N : NashExistencePackage M}
    {NE : NashEquilibriumPackage N} {B : BargainingProblemPackage NE}
    (BS : BargainingSolutionPackage B) (E : BargainingSolutionEvidence BS) :
    BargainingSolutionClosed BS := by
  refine And.intro E.feasibleSetClosed (And.intro E.disagreementPointClosed
    (And.intro E.paretoEfficiencyClosed (And.intro E.symmetryClosed
      (And.intro E.scaleInvarianceClosed (And.intro E.independenceClosed
        E.nashSolutionUniqueClosed)))))

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse