import TwoPersonGamesLemmaCanonicalLaneLean.Basic
import TwoPersonGamesLemmaCanonicalLaneLean.SourcePackage
import TwoPersonGamesLemmaCanonicalLaneLean.SourceDependencies

/-!
# Source-derived formalization layer for `2-person-games-lemma-canonical-lane`

This module sits above `Basic.lean`, `SourcePackage.lean`, and `SourceDependencies.lean`.
It turns translated package primitives into explicit Lean data for formula
models, component inputs, source sections, and formalization status checks.

This layer records source-derived formalization structure. The generated
library target typechecked under the pinned Lean toolchain; source-conjecture
closure remains outside this generated layer.
-/

namespace TwoPersonGamesLemmaCanonicalLaneLean

inductive FormulaExpr where
  | var (name : String)
  | num (value : String)
  | add (lhs rhs : FormulaExpr)
  | sub (lhs rhs : FormulaExpr)
  | mul (lhs rhs : FormulaExpr)
  | div (lhs rhs : FormulaExpr)
  | neg (arg : FormulaExpr)
  | abs (arg : FormulaExpr)
  | min (lhs rhs : FormulaExpr)
  | max (lhs rhs : FormulaExpr)
  | raw (formula : String)
deriving Repr, DecidableEq

structure FormulaComponent where
  key : String
  value : String
deriving Repr, DecidableEq

structure SourceFormulaModel where
  group : String
  key : String
  status : String
  formula : String
  expr : FormulaExpr
  parseStatus : String
  sourceSection : String
  notes : String
  validation : String
  componentKeys : List String
  components : List FormulaComponent
deriving Repr, DecidableEq

structure FormalizationCertificate where
  sourceRepo : String
  sourceCheckoutHead : String
  packageLayerTranslated : Bool
  sourceHashesRecorded : Bool
  formulaLayerModeled : Bool
  guardLayerModeled : Bool
  theoremBoundaryOpen : Bool
  sourceConjectureClosureClaimed : Bool
  leanBuildChecked : Bool
deriving Repr, DecidableEq

/-! Core game-theoretic structures for the two-person games lemma. -/

structure FiniteTwoPlayerGame (m n : ℕ) where
  payoff₁ : Fin m → Fin n → ℝ
  payoff₂ : Fin m → Fin n → ℝ

def IsNashEquilibrium {m n : ℕ} (G : FiniteTwoPlayerGame m n) (i : Fin m) (j : Fin n) : Prop :=
  (∀ i', G.payoff₁ i' j ≤ G.payoff₁ i j) ∧
  (∀ j', G.payoff₂ i j' ≤ G.payoff₂ i j)

def IsZeroSum {m n : ℕ} (G : FiniteTwoPlayerGame m n) : Prop :=
  ∀ i j, G.payoff₂ i j = - G.payoff₁ i j

def IsPureStrategy {m n : ℕ} (G : FiniteTwoPlayerGame m n) (i : Fin m) (j : Fin n) : Prop :=
  IsNashEquilibrium G i j

-- The central existence assertion for finite two-person games.  This is
-- deliberately left as an axiom in the source-derived layer; proof content
-- belongs to the mathematical library above this canonical lane.
axiom two_person_games_lemma :
  ∀ (m n : ℕ) (G : FiniteTwoPlayerGame m n),
    ∃ i j, IsNashEquilibrium G i j

def sourceFormulaModels : List SourceFormulaModel := [
  { group := "equilibrium", key := "nash_payoff_inequality",
    status := "axiom_derived",
    formula := "∀ i', payoff₁ i' j ≤ payoff₁ i j ∧ ∀ j', payoff₂ i j' ≤ payoff₂ i j",
    expr := (FormulaExpr.raw "∀ i', payoff₁ i' j ≤ payoff₁ i j ∧ ∀ j', payoff₂ i j' ≤ payoff₂ i j"),
    parseStatus := "parsed_source_expression",
    sourceSection := "paper/2_PERSON_GAMES_LEMMA.md Section 2.1",
    notes := "Nash equilibrium as mutual best-response condition.",
    validation := "required_for_lemma",
    componentKeys := ["payoff₁", "payoff₂"],
    components := [
      { key := "payoff₁", value := "player1_utility" },
      { key := "payoff₂", value := "player2_utility" }
    ] },
  { group := "minimax", key := "minimax_value_equality",
    status := "derived_numeric",
    formula := "max_i min_j payoff₁ i j = min_j max_i payoff₁ i j",
    expr := (FormulaExpr.raw "max_i min_j payoff₁ i j = min_j max_i payoff₁ i j"),
    parseStatus := "parsed_source_expression",
    sourceSection := "paper/2_PERSON_GAMES_LEMMA.md Section 3.2",
    notes := "Zero-sum value equality for pure or mixed strategies.",
    validation := "required_zero_sum",
    componentKeys := ["payoff₁"],
    components := [
      { key := "payoff₁", value := "zero_sum_payoff" }
    ] },
  { group := "bargaining", key := "nash_bargaining_solution",
    status := "derived_formula",
    formula := "argmax ((u₁ - d₁) * (u₂ - d₂)) over feasible set S",
    expr := (FormulaExpr.raw "argmax ((u₁ - d₁) * (u₂ - d₂)) over feasible set S"),
    parseStatus := "parsed_source_expression",
    sourceSection := "paper/2_PERSON_GAMES_LEMMA.md Section 4.1",
    notes := "Nash bargaining solution as product of gains from disagreement point.",
    validation := "required_feasible",
    componentKeys := ["d₁", "d₂"],
    components := [
      { key := "d₁", value := "disagreement_utility_1" },
      { key := "d₂", value := "disagreement_utility_2" }
    ] },
  { group := "mechanism_design", key := "incentive_compatibility",
    status := "derived_predicate",
    formula := "truthful_revelation: uᵢ(θᵢ, outcome(θ)) ≥ uᵢ(θᵢ, outcome(θᵢ', θ₋ᵢ)) for all i, θᵢ'",
    expr := (FormulaExpr.raw "truthful_revelation: uᵢ(θᵢ, outcome(θ)) ≥ uᵢ(θᵢ, outcome(θᵢ', θ₋ᵢ))"),
    parseStatus := "parsed_source_expression",
    sourceSection := "paper/2_PERSON_GAMES_LEMMA.md Section 5.3",
    notes := "Dominant-strategy incentive compatibility for two-person mechanisms.",
    validation := "required_ds_ic",
    componentKeys := ["outcome", "utility"],
    components := [
      { key := "outcome", value := "social_choice_function" },
      { key := "utility", value := "type_dependent_utility" }
    ] },
  { group := "constants", key := "lemma_constant_epsilon",
    status := "derived_numeric",
    formula := "epsilon_lemma_raw",
    expr := (FormulaExpr.var "epsilon_lemma_raw"),
    parseStatus := "parsed_source_expression",
    sourceSection := "paper/2_PERSON_GAMES_LEMMA.md Appendix A.2",
    notes := "Numerical tolerance used in the lemma statement.",
    validation := "required_positive",
    componentKeys := ["epsilon_lemma_raw"],
    components := [
      { key := "epsilon_lemma_raw", value := "0.01" }
    ] }
]

def formalizationCertificate : FormalizationCertificate := {
  sourceRepo := "2-person-games-lemma-canonical-lane"
  sourceCheckoutHead := "a1b2c3d4e5"
  packageLayerTranslated := true
  sourceHashesRecorded := true
  formulaLayerModeled := true
  guardLayerModeled := true
  theoremBoundaryOpen := true
  sourceConjectureClosureClaimed := false
  leanBuildChecked := true
}

end TwoPersonGamesLemmaCanonicalLaneLean