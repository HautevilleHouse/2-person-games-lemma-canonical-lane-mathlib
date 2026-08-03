import Mathlib.Data.Real.Basic

/-!
# Two-Person Games Lemma Route Layer

This module records the theorem-route obligations that connect the
Two-Person Games Lemma Canonical Lane package to the foundational results
in game theory: Nash equilibrium, the minimax theorem, bargaining solutions,
mechanism design, and the admissible-class bridge.

The module binds to the abstract game-theoretic statements and keeps the full
analytic development as an explicit carried formalization obligation.
-/

namespace TwoPersonGamesLemmaCanonicalLaneLean

/-- A two-person game with payoff functions into `ℝ`. -/
structure TwoPersonGame where
  strategyA : Type u
  strategyB : Type v
  payoffA : strategyA → strategyB → ℝ
  payoffB : strategyA → strategyB → ℝ

/-- A Nash equilibrium of a two-person game. -/
structure NashEquilibrium (G : TwoPersonGame) where
  a : G.strategyA
  b : G.strategyB
  bestA : ∀ a', G.payoffA a' b ≤ G.payoffA a b
  bestB : ∀ b', G.payoffB a b' ≤ G.payoffB a b

/-- Existence of a Nash equilibrium. -/
def NashEquilibriumExistence (G : TwoPersonGame) : Prop := Nonempty (NashEquilibrium G)

/-- The minimax theorem: a saddle value for the first player's payoff. -/
def MinimaxTheorem (G : TwoPersonGame) : Prop :=
  ∃ v : ℝ, (∀ a, ∃ b, G.payoffA a b ≤ v) ∧ (∀ b, ∃ a, v ≤ G.payoffA a b)

/-- Pareto optimal outcome. -/
def ParetoOptimal (G : TwoPersonGame) (a : G.strategyA) (b : G.strategyB) : Prop :=
  ¬ ∃ (a' : G.strategyA) (b' : G.strategyB),
    (G.payoffA a b < G.payoffA a' b' ∧ G.payoffB a b ≤ G.payoffB a' b') ∨
    (G.payoffA a b ≤ G.payoffA a' b' ∧ G.payoffB a b < G.payoffB a' b')

/-- Existence of a Pareto-optimal bargaining solution. -/
def BargainingSolutionExistence (G : TwoPersonGame) : Prop :=
  ∃ (a : G.strategyA) (b : G.strategyB), ParetoOptimal G a b

/-- Dominant-strategy incentive compatibility for a mechanism. -/
def MechanismDesignIncentiveCompatibility (G : TwoPersonGame) : Prop :=
  ∃ (TypeA : Type) (TypeB : Type)
    (valuationA : TypeA → G.strategyA → G.strategyB → ℝ)
    (valuationB : TypeB → G.strategyA → G.strategyB → ℝ)
    (outcome : TypeA → TypeB → G.strategyA × G.strategyB),
      ∀ (a : TypeA) (b : TypeB) (a' : TypeA) (b' : TypeB),
        valuationA a (outcome a b).1 (outcome a b).2 ≥ valuationA a (outcome a' b).1 (outcome a' b).2 ∧
        valuationB b (outcome a b).1 (outcome a b).2 ≥ valuationB b (outcome a b').1 (outcome a b').2

/-- The admissible-class bridge to the canonical lane. -/
def AdmissibleClassBridge (G : TwoPersonGame) : Prop :=
  NashEquilibriumExistence G ∧ MinimaxTheorem G

/-- The two-person games lemma route obligations. -/
structure TwoPersonGamesLemmaObligations where
  nashEquilibriumExistence : Prop
  minimaxTheorem : Prop
  bargainingSolutionExistence : Prop
  mechanismDesignIncentiveCompatibility : Prop
  admissibleBridge : Prop

/-- Closed evidence for each obligation. -/
structure TwoPersonGamesLemmaEvidence (R : TwoPersonGamesLemmaObligations) where
  nashEquilibriumExistenceClosed : R.nashEquilibriumExistence
  minimaxTheoremClosed : R.minimaxTheorem
  bargainingSolutionExistenceClosed : R.bargainingSolutionExistence
  mechanismDesignIncentiveCompatibilityClosed : R.mechanismDesignIncentiveCompatibility
  admissibleBridgeClosed : R.admissibleBridge

/-- The route is closed only when each obligation has closed evidence. -/
def TwoPersonGamesLemmaClosed (R : TwoPersonGamesLemmaObligations) : Prop :=
  R.nashEquilibriumExistence ∧
  R.minimaxTheorem ∧
  R.bargainingSolutionExistence ∧
  R.mechanismDesignIncentiveCompatibility ∧
  R.admissibleBridge

/-- The full analytic game-theoretic foundation for the two-person games lemma. -/
structure GameTheoryAnalyticFoundation where
  game : TwoPersonGame
  nash : NashEquilibriumExistence game
  minimax : MinimaxTheorem game
  bargaining : BargainingSolutionExistence game
  mechanism : MechanismDesignIncentiveCompatibility game
  bridge : AdmissibleClassBridge game

/-- Projection from the analytic foundation to the route obligations. -/
def GameTheoryAnalyticFoundation.toObligations
    (F : GameTheoryAnalyticFoundation) : TwoPersonGamesLemmaObligations :=
  { nashEquilibriumExistence := NashEquilibriumExistence F.game
    minimaxTheorem := MinimaxTheorem F.game
    bargainingSolutionExistence := BargainingSolutionExistence F.game
    mechanismDesignIncentiveCompatibility := MechanismDesignIncentiveCompatibility F.game
    admissibleBridge := AdmissibleClassBridge F.game
  }

/-- The full analytic game-theory proof remains the explicit formalization payload. -/
def gameTheoryAnalyticFormalizationPayload : String :=
  "Nash equilibrium existence, minimax theorem, bargaining solutions, mechanism design incentive compatibility, and admissible-class bridge."

/--
Closed analytic-foundation evidence produces the route obligation evidence.
-/
def game_theory_foundation_evidence
    (F : GameTheoryAnalyticFoundation) :
    TwoPersonGamesLemmaEvidence F.toObligations :=
  { nashEquilibriumExistenceClosed := F.nash
    minimaxTheoremClosed := F.minimax
    bargainingSolutionExistenceClosed := F.bargaining
    mechanismDesignIncentiveCompatibilityClosed := F.mechanism
    admissibleBridgeClosed := F.bridge
  }

/--
Closed evidence gives the closed route proposition.
-/
theorem two_person_games_lemma_closed_from_evidence
    (R : TwoPersonGamesLemmaObligations) (E : TwoPersonGamesLemmaEvidence R) :
    TwoPersonGamesLemmaClosed R := by
  exact And.intro E.nashEquilibriumExistenceClosed
    (And.intro E.minimaxTheoremClosed
      (And.intro E.bargainingSolutionExistenceClosed
        (And.intro E.mechanismDesignIncentiveCompatibilityClosed
          E.admissibleBridgeClosed)))

/--
A closed analytic foundation closes the route obligation set.
-/
theorem two_person_games_lemma_closed_from_foundation
    (F : GameTheoryAnalyticFoundation) :
    TwoPersonGamesLemmaClosed F.toObligations :=
  two_person_games_lemma_closed_from_evidence _ (game_theory_foundation_evidence F)

end TwoPersonGamesLemmaCanonicalLaneLean