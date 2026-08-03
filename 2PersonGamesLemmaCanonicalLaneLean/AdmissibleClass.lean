import Mathlib.Data.Real.Basic

/-!
# Admissible Class for 2-Person Games Lemma

The admissible class records a two-player game object and its bridge/gate:
either the endpoint is satisfied or the remainder is recorded.
-/

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

/-- A two-player normal-form game. -/
structure TwoPersonGame where
  playerOneActions : Type
  playerTwoActions : Type
  payoffOne : playerOneActions → playerTwoActions → ℝ
  payoffTwo : playerOneActions → playerTwoActions → ℝ

/-- A strategy profile in a two-player game. -/
structure StrategyProfile (G : TwoPersonGame) where
  s1 : G.playerOneActions
  s2 : G.playerTwoActions

/-- The Nash equilibrium no-profitable-deviation condition. -/
def IsNashEquilibrium (G : TwoPersonGame) (σ : StrategyProfile G) : Prop :=
  (∀ s1', G.payoffOne σ.s1 σ.s2 ≥ G.payoffOne s1' σ.s2) ∧
  (∀ s2', G.payoffTwo σ.s1 σ.s2 ≥ G.payoffTwo σ.s1 s2')

/-- Existence of a Nash equilibrium. -/
def HasNashEquilibrium (G : TwoPersonGame) : Prop :=
  ∃ σ : StrategyProfile G, IsNashEquilibrium G σ

/-- The admitted game-theoretic object. -/
structure GameAdmittedObject where
  game : TwoPersonGame
  nashEquilibrium : HasNashEquilibrium game
  conclusion : nashEquilibrium

/-- The admissible class for the 2-person games lemma lane. -/
structure AdmissibleClass where
  object : GameAdmittedObject
  endpointSatisfied : Prop
  remainderRecorded : Prop
  gateWitness : endpointSatisfied ∨ remainderRecorded

/-- Closure of the admitted object: bridge and gate are both witnessed. -/
def admittedClosure (A : AdmissibleClass) : Prop :=
  HasNashEquilibrium A.object.game ∧ (A.endpointSatisfied ∨ A.remainderRecorded)

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse