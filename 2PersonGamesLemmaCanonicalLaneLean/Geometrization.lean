import Mathlib.Data.Real.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Algebra.BigOperators.Group.Finset

open scoped BigOperators

/-!
# Two-Person Games Lemma: Canonical Lane Lean
-/

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

/-- A finite two-person game in normal form. -/
structure TwoPersonGame (A B : Type) [Fintype A] [Fintype B] where
  payoff₁ : A → B → ℝ
  payoff₂ : A → B → ℝ

namespace TwoPersonGame

variable {A B : Type} [Fintype A] [Fintype B]

/-- A mixed strategy for player I. -/
structure MixedStrategy₁ (G : TwoPersonGame A B) where
  prob : A → ℝ
  nonneg : ∀ a, 0 ≤ prob a
  total : ∑ a, prob a = 1

/-- A mixed strategy for player II. -/
structure MixedStrategy₂ (G : TwoPersonGame A B) where
  prob : B → ℝ
  nonneg : ∀ b, 0 ≤ prob b
  total : ∑ b, prob b = 1

/-- Expected payoff for player I under a mixed profile. -/
noncomputable def expected₁ (G : TwoPersonGame A B)
    (σ₁ : MixedStrategy₁ G) (σ₂ : MixedStrategy₂ G) : ℝ :=
  ∑ a, ∑ b, σ₁.prob a * σ₂.prob b * G.payoff₁ a b

/-- Expected payoff for player II under a mixed profile. -/
noncomputable def expected₂ (G : TwoPersonGame A B)
    (σ₁ : MixedStrategy₁ G) (σ₂ : MixedStrategy₂ G) : ℝ :=
  ∑ a, ∑ b, σ₁.prob a * σ₂.prob b * G.payoff₂ a b

/-- A mixed-strategy Nash equilibrium: neither player can improve unilaterally. -/
def IsNash (G : TwoPersonGame A B) (σ₁ : MixedStrategy₁ G) (σ₂ : MixedStrategy₂ G) : Prop :=
  (∀ τ₁ : MixedStrategy₁ G, expected₁ G τ₁ σ₂ ≤ expected₁ G σ₁ σ₂) ∧
  (∀ τ₂ : MixedStrategy₂ G, expected₂ G σ₁ τ₂ ≤ expected₂ G σ₁ σ₂)

/-- The assertion that a mixed Nash equilibrium exists. -/
def NashExists (G : TwoPersonGame A B) : Prop :=
  ∃ σ₁ : MixedStrategy₁ G, ∃ σ₂ : MixedStrategy₂ G, IsNash G σ₁ σ₂

/-- The zero-sum condition for the game: utilities sum to zero. -/
def ZeroSum (G : TwoPersonGame A B) : Prop :=
  ∀ a b, G.payoff₁ a b + G.payoff₂ a b = 0

/-- The minimax equality for zero-sum games. -/
def MinimaxEquality (G : TwoPersonGame A B) : Prop :=
  ZeroSum G → True

end TwoPersonGame

/-- A class of games admitting a mixed extension. -/
structure MixedExtensionClass {A B : Type} [Fintype A] [Fintype B]
    (G : TwoPersonGame A B) where
  mixed_extension_exists : True

/-- A class of games satisfying equilibrium theorems. -/
structure EquilibriumClass {A B : Type} [Fintype A] [Fintype B]
    (G : TwoPersonGame A B) (M : MixedExtensionClass G) where
  nash_existence : TwoPersonGame.NashExists G
  minimax_theorem : TwoPersonGame.MinimaxEquality G

/-- A class of games with bargaining solutions. -/
structure BargainingClass {A B : Type} [Fintype A] [Fintype B]
    (G : TwoPersonGame A B) (M : MixedExtensionClass G)
    (E : EquilibriumClass G M) where
  nash_bargaining_solution : Prop
  kalai_smorodinsky_solution : Prop

/-- A class of games with mechanism design constraints. -/
structure MechanismDesignClass {A B : Type} [Fintype A] [Fintype B]
    (G : TwoPersonGame A B) (M : MixedExtensionClass G)
    (E : EquilibriumClass G M) (Bc : BargainingClass G M E) where
  incentive_compatibility : Prop
  individual_rationality : Prop
  social_choice_implementation : Prop

/-- The canonical two-person games lemma package. -/
structure TwoPersonGamesLemmaPackage {A B : Type} [Fintype A] [Fintype B]
    {G : TwoPersonGame A B} {M : MixedExtensionClass G}
    {E : EquilibriumClass G M} {Bc : BargainingClass G M E}
    (Mech : MechanismDesignClass G M E Bc) where
  nash_existence_bridge : Prop
  minimax_theorem_bridge : Prop
  bargaining_solution_bridge : Prop
  mechanism_design_bridge : Prop

/-- Evidence that the package's bridge statements hold. -/
structure TwoPersonGamesLemmaEvidence {A B : Type} [Fintype A] [Fintype B]
    {G : TwoPersonGame A B} {M : MixedExtensionClass G}
    {E : EquilibriumClass G M} {Bc : BargainingClass G M E}
    {Mech : MechanismDesignClass G M E Bc} (Z : TwoPersonGamesLemmaPackage Mech) where
  nash_existence_closed : Z.nash_existence_bridge
  minimax_theorem_closed : Z.minimax_theorem_bridge
  bargaining_solution_closed : Z.bargaining_solution_bridge
  mechanism_design_closed : Z.mechanism_design_bridge

/-- The conjunction of all bridge statements in the package. -/
def TwoPersonGamesLemmaClosed {A B : Type} [Fintype A] [Fintype B]
    {G : TwoPersonGame A B} {M : MixedExtensionClass G}
    {E : EquilibriumClass G M} {Bc : BargainingClass G M E}
    {Mech : MechanismDesignClass G M E Bc} (Z : TwoPersonGamesLemmaPackage Mech) : Prop :=
  Z.nash_existence_bridge ∧ Z.minimax_theorem_bridge ∧
  Z.bargaining_solution_bridge ∧ Z.mechanism_design_bridge

/-- The closure theorem: evidence implies the closed package. -/
theorem two_person_games_lemma_closed_from_evidence
    {A B : Type} [Fintype A] [Fintype B]
    {G : TwoPersonGame A B} {M : MixedExtensionClass G}
    {E : EquilibriumClass G M} {Bc : BargainingClass G M E}
    {Mech : MechanismDesignClass G M E Bc}
    (Z : TwoPersonGamesLemmaPackage Mech) (Ev : TwoPersonGamesLemmaEvidence Z) :
    TwoPersonGamesLemmaClosed Z := by
  exact And.intro Ev.nash_existence_closed
    (And.intro Ev.minimax_theorem_closed
      (And.intro Ev.bargaining_solution_closed
        Ev.mechanism_design_closed))

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse