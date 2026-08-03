import TwoPersonGamesLemmaCanonicalLaneLean.GateLemmas

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

/-- The constrained closure for the 2-person games lemma lane. -/
def ConstrainedGameTheoreticClosure (A : AdmissibleClass) : Prop :=
  bridgeClosed A ∧ gateClosed A

/-- The admissible class endgame: bridge and gate close together. -/
theorem constrained_game_theoretic_endgame (A : AdmissibleClass) :
    ConstrainedGameTheoreticClosure A := by
  exact And.intro (bridge_from_admissible_class A) (gate_from_admissible_class A)

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse