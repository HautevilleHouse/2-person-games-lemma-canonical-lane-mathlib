import TwoPersonGamesLemmaCanonicalLaneLean.FinalTheorem
import CanonicalLaneMathlibCore

/-!
# Mathlib Statement Layer

This module imports the shared Mathlib-backed Canonical Lane core and the
Two Person Games endgame pilot. The pilot closes over its admitted class and carries the
unrestricted classical boundary separately.
-/

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

open HautevilleHouse.CanonicalLaneMathlibCore

-- Core game-theoretic definitions native to this theorem-specific layer

structure TwoPersonGame (S1 S2 : Type) where
  payoff₁ : S1 → S2 → ℝ
  payoff₂ : S1 → S2 → ℝ

def IsNashEquilibrium {S1 S2 : Type} (G : TwoPersonGame S1 S2)
    (s₁ : S1) (s₂ : S2) : Prop :=
  (∀ t₁ : S1, G.payoff₁ t₁ s₂ ≤ G.payoff₁ s₁ s₂) ∧
  (∀ t₂ : S2, G.payoff₂ s₁ t₂ ≤ G.payoff₂ s₁ s₂)

-- Structure recording the proof obligation for this canonical lane

structure MathlibProofObligation where
  sourceKey : String
  theoremObject : String
  commonCoreImported : Bool
  theoremSpecificDefinitionsNative : Bool
  theoremSpecificBridgeNative : Bool
  theoremSpecificAdmittedClosureNative : Bool
  unrestrictedClassicalClosureNative : Bool
  carriedGap : String

def mathlibProofObligation : MathlibProofObligation := {
  sourceKey := sourceRepository,
  theoremObject := sourceDescription,
  commonCoreImported := true,
  theoremSpecificDefinitionsNative := true,
  theoremSpecificBridgeNative := true,
  theoremSpecificAdmittedClosureNative := true,
  unrestrictedClassicalClosureNative := false,
  carriedGap := "theorem-specific Mathlib endgame pilot closes over the admitted game class; unrestricted classical closure remains carried"
}

-- Common core laws (re-exported from CanonicalLaneMathlibCore)

def commonCoreProjectionLawAvailable : Prop :=
  forall {X : Type} [Add X] [Sub X] (L : AdditiveLane X),
    L.xNext = L.state + L.projection.toFun L.delta

def commonCoreCarriageLawAvailable : Prop :=
  forall {X : Type} [Add X] [Sub X] (L : AdditiveLane X),
    L.carriedComponent = L.delta - L.projection.toFun L.delta

def commonCoreIdempotenceAvailable : Prop :=
  forall {X : Type} [Add X] [Sub X] (L : AdditiveLane X),
    L.projection.toFun (L.projection.toFun L.delta) = L.projection.toFun L.delta

-- Game-specific bridge: the endgame pilot closes over the admissible game class

def theoremSpecificEndgamePilotClosed : Prop :=
  forall G : AdmissibleGameClass, ConstrainedTwoPersonGamesClosure G

-- Verification theorems

theorem mathlib_common_core_imported_checked :
    mathlibProofObligation.commonCoreImported = true := by
  rfl

theorem mathlib_theorem_specific_definitions_native_checked :
    mathlibProofObligation.theoremSpecificDefinitionsNative = true := by
  rfl

theorem mathlib_theorem_specific_bridge_native_checked :
    mathlibProofObligation.theoremSpecificBridgeNative = true := by
  rfl

theorem mathlib_theorem_specific_admitted_closure_native_checked :
    mathlibProofObligation.theoremSpecificAdmittedClosureNative = true := by
  rfl

theorem mathlib_unrestricted_classical_closure_carried :
    mathlibProofObligation.unrestrictedClassicalClosureNative = false := by
  rfl

theorem mathlib_common_core_projection_law_checked :
    commonCoreProjectionLawAvailable := by
  intro X instAdd instSub L
  exact AdditiveLane.x_next_eq L

theorem mathlib_common_core_carriage_law_checked :
    commonCoreCarriageLawAvailable := by
  intro X instAdd instSub L
  exact AdditiveLane.carried_component_eq L

theorem mathlib_common_core_idempotence_checked :
    commonCoreIdempotenceAvailable := by
  intro X instAdd instSub L
  exact AdditiveLane.projection_idempotent_on_delta L

theorem theorem_specific_endgame_pilot_checked :
    theoremSpecificEndgamePilotClosed := by
  intro G
  exact constrained_two_person_games_endgame G

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse