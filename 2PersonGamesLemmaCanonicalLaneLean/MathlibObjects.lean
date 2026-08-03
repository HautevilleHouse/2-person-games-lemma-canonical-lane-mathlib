import Mathlib.Data.Real.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Algebra.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Basic

open scoped BigOperators

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

-- Basic definition of a two-player game
structure TwoPlayerGame where
  PlayerA : Type
  PlayerB : Type
  utilityA : PlayerA → PlayerB → ℝ
  utilityB : PlayerA → PlayerB → ℝ

-- Pure strategy Nash equilibrium
def IsNashEquilibrium (G : TwoPlayerGame) (a : G.PlayerA) (b : G.PlayerB) : Prop :=
  (∀ a' : G.PlayerA, G.utilityA a' b ≤ G.utilityA a b) ∧
  (∀ b' : G.PlayerB, G.utilityB a b' ≤ G.utilityB a b)

-- Finite two-player game with mixed strategies
structure FiniteTwoPlayerGame where
  PlayerA : Type
  PlayerB : Type
  [fintypeA : Fintype PlayerA]
  [decidableEqA : DecidableEq PlayerA]
  [fintypeB : Fintype PlayerB]
  [decidableEqB : DecidableEq PlayerB]
  utilityA : PlayerA → PlayerB → ℝ
  utilityB : PlayerA → PlayerB → ℝ

attribute [instance] FiniteTwoPlayerGame.fintypeA FiniteTwoPlayerGame.decidableEqA
attribute [instance] FiniteTwoPlayerGame.fintypeB FiniteTwoPlayerGame.decidableEqB

-- Mixed strategy for player A
structure MixedStrategyA (G : FiniteTwoPlayerGame) where
  prob : G.PlayerA → ℝ
  nonneg : ∀ a, 0 ≤ prob a
  sum_eq_one : (∑ a, prob a) = 1

-- Mixed strategy for player B
structure MixedStrategyB (G : FiniteTwoPlayerGame) where
  prob : G.PlayerB → ℝ
  nonneg : ∀ b, 0 ≤ prob b
  sum_eq_one : (∑ b, prob b) = 1

-- Expected utility for A
noncomputable def expectedUtilityA (G : FiniteTwoPlayerGame) (p : MixedStrategyA G) (q : MixedStrategyB G) : ℝ :=
  ∑ a, ∑ b, p.prob a * q.prob b * G.utilityA a b

-- Expected utility for B
noncomputable def expectedUtilityB (G : FiniteTwoPlayerGame) (p : MixedStrategyA G) (q : MixedStrategyB G) : ℝ :=
  ∑ a, ∑ b, p.prob a * q.prob b * G.utilityB a b

-- Mixed strategy Nash equilibrium
def IsMixedNashEquilibrium (G : FiniteTwoPlayerGame) (p : MixedStrategyA G) (q : MixedStrategyB G) : Prop :=
  (∀ p' : MixedStrategyA G, expectedUtilityA G p' q ≤ expectedUtilityA G p q) ∧
  (∀ q' : MixedStrategyB G, expectedUtilityB G p q' ≤ expectedUtilityB G p q)

-- Nash theorem (the 2-person games lemma): every finite two-player game has a mixed Nash equilibrium
def NashTheorem (G : FiniteTwoPlayerGame) : Prop :=
  ∃ p : MixedStrategyA G, ∃ q : MixedStrategyB G, IsMixedNashEquilibrium G p q

-- Bridge object for Nash existence
structure NashBridge (G : FiniteTwoPlayerGame) where
  equilibrium : MixedStrategyA G × MixedStrategyB G
  is_nash : IsMixedNashEquilibrium G equilibrium.1 equilibrium.2

-- Minimax theorem for zero-sum games
structure ZeroSumGame where
  PlayerA : Type
  PlayerB : Type
  [fintypeA : Fintype PlayerA]
  [decidableEqA : DecidableEq PlayerA]
  [fintypeB : Fintype PlayerB]
  [decidableEqB : DecidableEq PlayerB]
  payoff : PlayerA → PlayerB → ℝ

attribute [instance] ZeroSumGame.fintypeA ZeroSumGame.decidableEqA
attribute [instance] ZeroSumGame.fintypeB ZeroSumGame.decidableEqB

-- Mixed strategies for zero-sum games
structure ZeroSumMixedA (G : ZeroSumGame) where
  prob : G.PlayerA → ℝ
  nonneg : ∀ a, 0 ≤ prob a
  sum_eq_one : (∑ a, prob a) = 1

structure ZeroSumMixedB (G : ZeroSumGame) where
  prob : G.PlayerB → ℝ
  nonneg : ∀ b, 0 ≤ prob b
  sum_eq_one : (∑ b, prob b) = 1

noncomputable def zeroSumExpectedPayoff (G : ZeroSumGame) (p : ZeroSumMixedA G) (q : ZeroSumMixedB G) : ℝ :=
  ∑ a, ∑ b, p.prob a * q.prob b * G.payoff a b

-- Minimax value theorem statement
def MinimaxTheorem (G : ZeroSumGame) : Prop :=
  ∃ v : ℝ,
    (∃ p : ZeroSumMixedA G, ∀ q : ZeroSumMixedB G, v ≤ zeroSumExpectedPayoff G p q) ∧
    (∃ q : ZeroSumMixedB G, ∀ p : ZeroSumMixedA G, zeroSumExpectedPayoff G p q ≤ v)

-- Bridge object for minimax
structure MinimaxBridge (G : ZeroSumGame) where
  value : ℝ
  maxmin : ∃ p : ZeroSumMixedA G, ∀ q : ZeroSumMixedB G, value ≤ zeroSumExpectedPayoff G p q
  minmax : ∃ q : ZeroSumMixedB G, ∀ p : ZeroSumMixedA G, zeroSumExpectedPayoff G p q ≤ value

-- Bargaining problem
structure BargainingProblem where
  feasible : Set (ℝ × ℝ)
  disagreement : ℝ × ℝ

-- Nash bargaining solution property
def NashBargainingSolution (B : BargainingProblem) : Prop :=
  ∃ u : ℝ × ℝ, u ∈ B.feasible ∧
    ∀ v : ℝ × ℝ, v ∈ B.feasible →
      (v.1 - B.disagreement.1) * (v.2 - B.disagreement.2) ≤
        (u.1 - B.disagreement.1) * (u.2 - B.disagreement.2)

-- Mechanism design: a simple mechanism
structure Mechanism where
  PlayerA : Type
  PlayerB : Type
  Outcome : Type
  utilityA : PlayerA → PlayerB → Outcome → ℝ
  utilityB : PlayerA → PlayerB → Outcome → ℝ
  outcomeFunction : PlayerA → PlayerB → Outcome

-- Incentive compatibility (truthful reporting is a dominant strategy)
def IncentiveCompatible (M : Mechanism) (a : M.PlayerA) (b : M.PlayerB) : Prop :=
  (∀ a' : M.PlayerA,
    M.utilityA a b (M.outcomeFunction a b) ≥ M.utilityA a' b (M.outcomeFunction a' b)) ∧
  (∀ b' : M.PlayerB,
    M.utilityB a b (M.outcomeFunction a b) ≥ M.utilityB a b' (M.outcomeFunction a b'))

-- Canonical two-person games lemma object:
-- It packages the essential statement: every finite two-player game admits a mixed Nash equilibrium.
structure TwoPersonGamesLemmaCanonicalLaneLean where
  game : FiniteTwoPlayerGame
  proof : NashTheorem game

-- A derived lemma for zero-sum games: minimax theorem
structure TwoPersonZeroSumLemma where
  game : ZeroSumGame
  proof : MinimaxTheorem game

-- A derived lemma for bargaining: existence of Nash bargaining solution under certain conditions
-- (we just record the property)
structure BargainingLemma where
  problem : BargainingProblem
  solution : NashBargainingSolution problem

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse