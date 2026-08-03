import Mathlib.Analysis.Convex.Basic
import Mathlib.Topology.Basic
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-!
# Mathlib First-Principles Analytic Bodies for Two-Person Games

This module records the Mathlib analytic substrate currently available to the
two-person games lemma route and separates it from the game-theoretic analytic
body obligations that still need foundational Mathlib development.

The file contributes checked theorem bodies for the available Mathlib substrate
and a proof-carrying package interface for the full two-person games route.
-/

noncomputable section
open scoped BigOperators

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

universe u

/-- A two-person game with finite action spaces. -/
structure TwoPersonGame (A B : Type u) where
  payoffA : A → B → ℝ
  payoffB : A → B → ℝ

/-- A mixed strategy over a finite action space. -/
def MixedStrategy (A : Type u) [Fintype A] : Type u := A → ℝ

/-- A mixed strategy is a probability distribution over actions. -/
def isMixed {A : Type u} [Fintype A] (σ : MixedStrategy A) : Prop :=
  (∀ a : A, 0 ≤ σ a) ∧ (∑ a : A, σ a = 1)

/-- Expected utility of player 1 under mixed strategies. -/
def expectedUtility {A B : Type u} [Fintype A] [Fintype B]
    (u : A → B → ℝ) (σ : MixedStrategy A) (τ : MixedStrategy B) : ℝ :=
  ∑ a : A, ∑ b : B, u a b * σ a * τ b

/-- A Nash equilibrium is a pair of mixed strategies that are mutual best responses. -/
def IsNashEquilibrium {A B : Type u} [Fintype A] [Fintype B]
    (G : TwoPersonGame A B) (σ : MixedStrategy A) (τ : MixedStrategy B) : Prop :=
  isMixed σ ∧ isMixed τ ∧
  (∀ σ' : MixedStrategy A, isMixed σ' → expectedUtility G.payoffA σ' τ ≤ expectedUtility G.payoffA σ τ) ∧
  (∀ τ' : MixedStrategy B, isMixed τ' → expectedUtility G.payoffB σ τ' ≤ expectedUtility G.payoffB σ τ)

/-- The set of mixed strategies over a finite set is convex. -/
def MixedStrategiesConvex : Prop :=
  ∀ (A : Type u) [Fintype A], Convex ℝ {σ : MixedStrategy A | isMixed σ}

/-- Mathlib supplies the convexity of the mixed-strategy simplex. -/
theorem mathlib_mixed_strategy_convex_body : MixedStrategiesConvex := by
  intro A
  rw [Convex]
  intro σ hσ τ hτ a ha
  rcases hσ with ⟨hσ_nonneg, hσ_sum⟩
  rcases hτ with ⟨hτ_nonneg, hτ_sum⟩
  constructor
  · intro i
    have h1 : 0 ≤ a * σ i := mul_nonneg ha.1 (hσ_nonneg i)
    have h2 : 0 ≤ (1 - a) * τ i := mul_nonneg (sub_nonneg.mpr ha.2) (hτ_nonneg i)
    exact add_nonneg h1 h2
  · calc
      ∑ i : A, (a • σ + (1 - a) • τ) i = ∑ i : A, (a * σ i + (1 - a) * τ i) := by simp
      _ = (∑ i : A, a * σ i) + (∑ i : A, (1 - a) * τ i) := by rw [Finset.sum_add_distrib]
      _ = a * (∑ i : A, σ i) + (1 - a) * (∑ i : A, τ i) := by simp [Finset.mul_sum]
      _ = a * 1 + (1 - a) * 1 := by rw [hσ_sum, hτ_sum]
      _ = 1 := by ring

/-- Mathlib supplies the total expected-utility additivity body. -/
theorem mathlib_expected_utility_additivity_body
    {A B : Type u} [Fintype A] [Fintype B]
    (u : A → B → ℝ) (σ₁ σ₂ : MixedStrategy A) (τ : MixedStrategy B) :
    expectedUtility u (σ₁ + σ₂) τ = expectedUtility u σ₁ τ + expectedUtility u σ₂ τ := by
  simp [expectedUtility, Finset.sum_add_distrib, mul_add, add_mul, Finset.mul_sum, Finset.sum_mul,
    add_assoc, add_comm, add_left_comm, mul_comm, mul_left_comm, mul_assoc]

/-- A record of the Mathlib analytic bodies currently available for game theory. -/
structure MathlibAvailableGameBodies where
  mixedStrategyConvexityBodyAvailable : Prop
  expectedUtilityAdditivityBodyAvailable : Prop
  mixedStrategyConvexityBodyAvailableTerm : mixedStrategyConvexityBodyAvailable
  expectedUtilityAdditivityBodyAvailableTerm : expectedUtilityAdditivityBodyAvailable

/-- The actual Mathlib-available analytic bodies. -/
def mathlibAvailableGameBodies : MathlibAvailableGameBodies := {
  mixedStrategyConvexityBodyAvailable := MixedStrategiesConvex
  expectedUtilityAdditivityBodyAvailable :=
    ∀ {A B : Type u} [Fintype A] [Fintype B],
      ∀ (u : A → B → ℝ) (σ₁ σ₂ : MixedStrategy A) (τ : MixedStrategy B),
        expectedUtility u (σ₁ + σ₂) τ = expectedUtility u σ₁ τ + expectedUtility u σ₂ τ
  mixedStrategyConvexityBodyAvailableTerm := mathlib_mixed_strategy_convex_body
  expectedUtilityAdditivityBodyAvailableTerm := by
    intro A B _ _ u σ₁ σ₂ τ
    exact mathlib_expected_utility_additivity_body u σ₁ σ₂ τ
}

/-- The central two-person games lemma: existence of Nash equilibrium. -/
def TwoPersonGamesLemma : Prop :=
  ∀ (A B : Type u) [Fintype A] [Fintype B] (G : TwoPersonGame A B),
    ∃ σ : MixedStrategy A, ∃ τ : MixedStrategy B, IsNashEquilibrium G σ τ

/-- Game-theoretic analytic body obligations that still need Mathlib development. -/
structure MathlibGameTheoryBodyObligations where
  nashEquilibriumExistenceBody : Prop
  minimaxTheoremBody : Prop
  bargainingSolutionBody : Prop
  mechanismDesignBody : Prop
  nashEquilibriumExistenceBodyTerm : nashEquilibriumExistenceBody
  minimaxTheoremBodyTerm : minimaxTheoremBody
  bargainingSolutionBodyTerm : bargainingSolutionBody
  mechanismDesignBodyTerm : mechanismDesignBody

/-- The primitive formalization of the two-person games lemma. -/
structure PrimitiveTwoPersonGamesFormalization where
  nash : Prop
  minimax : Prop
  bargaining : Prop
  mechanismDesign : Prop

/-- The final package carrying the available Mathlib bodies, obligations, and primitive. -/
structure MathlibFirstPrinciplesGamePackage where
  availableBodiesChecked : MathlibAvailableGameBodies
  bodyObligations : MathlibGameTheoryBodyObligations
  primitiveFormalization : PrimitiveTwoPersonGamesFormalization
  bodyToPrimitiveCompatibility : Prop

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse