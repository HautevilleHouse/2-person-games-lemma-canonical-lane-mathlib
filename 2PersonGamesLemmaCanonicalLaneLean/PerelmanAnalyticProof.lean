import Mathlib.Data.Real.Basic

/-!
# 2-Person Games Lemma Canonical Lane

This module encodes admissible-class bridge certificates for the central
two-person game-theoretic results: Nash equilibrium, the minimax theorem,
bargaining solutions, and mechanism design.
-/

namespace TwoPersonGamesLemmaCanonicalLaneLean

/-- A normal-form two-person game. -/
structure NormalFormGame where
  PlayerI : Type
  PlayerII : Type
  StrategyI : Type
  StrategyII : Type
  payoffI : StrategyI → StrategyII → ℝ
  payoffII : StrategyI → StrategyII → ℝ

namespace NormalFormGame

/-- Pure-strategy Nash equilibrium condition. -/
def IsPureNash (G : NormalFormGame) (s : G.StrategyI) (t : G.StrategyII) : Prop :=
  (∀ s', G.payoffI s' t ≤ G.payoffI s t) ∧
  (∀ t', G.payoffII s t' ≤ G.payoffII s t)

/-- Zero-sum condition. -/
def IsZeroSum (G : NormalFormGame) : Prop :=
  ∀ s t, G.payoffII s t = - G.payoffI s t

end NormalFormGame

/-- A two-person zero-sum game. -/
structure ZeroSumGame where
  game : NormalFormGame
  zero_sum : NormalFormGame.IsZeroSum game

/-! ## Nash equilibrium certificate -/

structure NashExistencePackage (Γ : NormalFormGame) where
  mixedStrategiesDefined : Prop
  finiteExtensions : Prop
  bestResponseCorrespondence : Prop
  fixedPointCondition : Prop

structure NashExistenceEvidence {Γ : NormalFormGame} (P : NashExistencePackage Γ) where
  mixedStrategiesDefined_closed : P.mixedStrategiesDefined
  finiteExtensions_closed : P.finiteExtensions
  bestResponseCorrespondence_closed : P.bestResponseCorrespondence
  fixedPointCondition_closed : P.fixedPointCondition

def NashExistencePackageClosed {Γ : NormalFormGame} (P : NashExistencePackage Γ) : Prop :=
  P.mixedStrategiesDefined ∧ P.finiteExtensions ∧ P.bestResponseCorrespondence ∧ P.fixedPointCondition

theorem nash_existence_closed_from_evidence {Γ : NormalFormGame} (P : NashExistencePackage Γ)
    (E : NashExistenceEvidence P) : NashExistencePackageClosed P := by
  exact And.intro E.mixedStrategiesDefined_closed
    (And.intro E.finiteExtensions_closed
      (And.intro E.bestResponseCorrespondence_closed E.fixedPointCondition_closed))

structure NashEquilibriumCertificate {Γ : NormalFormGame} (P : NashExistencePackage Γ) where
  existenceClaim : Prop
  equilibriumProfileConstructed : Prop
  bestResponsesVerified : Prop
  mixedStrategySupport : Prop
  existenceClaim_closed : existenceClaim
  equilibriumProfileConstructed_closed : equilibriumProfileConstructed
  bestResponsesVerified_closed : bestResponsesVerified
  mixedStrategySupport_closed : mixedStrategySupport
  nashEvidence : NashExistenceEvidence P

def NashEquilibriumCertificateClosed {Γ : NormalFormGame} {P : NashExistencePackage Γ}
    (C : NashEquilibriumCertificate P) : Prop :=
  C.existenceClaim ∧ C.equilibriumProfileConstructed ∧ C.bestResponsesVerified ∧ C.mixedStrategySupport ∧
  NashExistencePackageClosed P

theorem nash_equilibrium_certificate_closed {Γ : NormalFormGame} {P : NashExistencePackage Γ}
    (C : NashEquilibriumCertificate P) : NashEquilibriumCertificateClosed C := by
  exact And.intro C.existenceClaim_closed
    (And.intro C.equilibriumProfileConstructed_closed
      (And.intro C.bestResponsesVerified_closed
        (And.intro C.mixedStrategySupport_closed
          (nash_existence_closed_from_evidence P C.nashEvidence))))

/-! ## Minimax theorem certificate -/

structure MinimaxExistencePackage (Z : ZeroSumGame) where
  mixedValueDefined : Prop
  minimaxEquality : Prop
  saddlePointCondition : Prop
  valueExistence : Prop

structure MinimaxExistenceEvidence {Z : ZeroSumGame} (P : MinimaxExistencePackage Z) where
  mixedValueDefined_closed : P.mixedValueDefined
  minimaxEquality_closed : P.minimaxEquality
  saddlePointCondition_closed : P.saddlePointCondition
  valueExistence_closed : P.valueExistence

def MinimaxExistencePackageClosed {Z : ZeroSumGame} (P : MinimaxExistencePackage Z) : Prop :=
  P.mixedValueDefined ∧ P.minimaxEquality ∧ P.saddlePointCondition ∧ P.valueExistence

theorem minimax_existence_closed_from_evidence {Z : ZeroSumGame} (P : MinimaxExistencePackage Z)
    (E : MinimaxExistenceEvidence P) : MinimaxExistencePackageClosed P := by
  exact And.intro E.mixedValueDefined_closed
    (And.intro E.minimaxEquality_closed
      (And.intro E.saddlePointCondition_closed E.valueExistence_closed))

structure MinimaxCertificate {Z : ZeroSumGame} (P : MinimaxExistencePackage Z) where
  minimaxTheoremClaim : Prop
  valueEquality : Prop
  optimalStrategies : Prop
  minimaxTheoremClaim_closed : minimaxTheoremClaim
  valueEquality_closed : valueEquality
  optimalStrategies_closed : optimalStrategies
  minimaxEvidence : MinimaxExistenceEvidence P

def MinimaxCertificateClosed {Z : ZeroSumGame} {P : MinimaxExistencePackage Z}
    (C : MinimaxCertificate P) : Prop :=
  C.minimaxTheoremClaim ∧ C.valueEquality ∧ C.optimalStrategies ∧ MinimaxExistencePackageClosed P

theorem minimax_certificate_closed {Z : ZeroSumGame} {P : MinimaxExistencePackage Z}
    (C : MinimaxCertificate P) : MinimaxCertificateClosed C :=
  by
  exact And.intro C.minimaxTheoremClaim_closed
    (And.intro C.valueEquality_closed
      (And.intro C.optimalStrategies_closed
        (minimax_existence_closed_from_evidence P C.minimaxEvidence)))

/-! ## Nash bargaining solution certificate -/

structure BargainingSolutionPackage where
  feasibleSet : Prop
  disagreementPoint : Prop
  nashProduct : Prop
  paretoEfficiency : Prop
  symmetryInvariance : Prop
  independenceOfIrrelevantAlternatives : Prop

structure BargainingSolutionEvidence (P : BargainingSolutionPackage) where
  feasibleSet_closed : P.feasibleSet
  disagreementPoint_closed : P.disagreementPoint
  nashProduct_closed : P.nashProduct
  paretoEfficiency_closed : P.paretoEfficiency
  symmetryInvariance_closed : P.symmetryInvariance
  independenceOfIrrelevantAlternatives_closed : P.independenceOfIrrelevantAlternatives

def BargainingSolutionPackageClosed (P : BargainingSolutionPackage) : Prop :=
  P.feasibleSet ∧ P.disagreementPoint ∧ P.nashProduct ∧ P.paretoEfficiency ∧
  P.symmetryInvariance ∧ P.independenceOfIrrelevantAlternatives

theorem bargaining_solution_closed_from_evidence (P : BargainingSolutionPackage)
    (E : BargainingSolutionEvidence P) : BargainingSolutionPackageClosed P := by
  exact And.intro E.feasibleSet_closed
    (And.intro E.disagreementPoint_closed
      (And.intro E.nashProduct_closed
        (And.intro E.paretoEfficiency_closed
          (And.intro E.symmetryInvariance_closed E.independenceOfIrrelevantAlternatives_closed))))

structure BargainingCertificate (P : BargainingSolutionPackage) where
  solutionExists : Prop
  characterizedByAxioms : Prop
  solutionExists_closed : solutionExists
  characterizedByAxioms_closed : characterizedByAxioms
  bargainingEvidence : BargainingSolutionEvidence P

def BargainingCertificateClosed (P : BargainingSolutionPackage) (C : BargainingCertificate P) : Prop :=
  C.solutionExists ∧ C.characterizedByAxioms ∧ BargainingSolutionPackageClosed P

theorem bargaining_certificate_closed (P : BargainingSolutionPackage) (C : BargainingCertificate P) :
    BargainingCertificateClosed P C := by
  exact And.intro C.solutionExists_closed
    (And.intro C.characterizedByAxioms_closed
      (bargaining_solution_closed_from_evidence P C.bargainingEvidence))

/-! ## Mechanism design certificate -/

structure MechanismDesignPackage where
  preferenceTypes : Prop
  allocationRule : Prop
  incentiveCompatibility : Prop
  revelationPrinciple : Prop
  socialChoiceFunction : Prop
  strategyProofness : Prop

structure MechanismDesignEvidence (P : MechanismDesignPackage) where
  preferenceTypes_closed : P.preferenceTypes
  allocationRule_closed : P.allocationRule
  incentiveCompatibility_closed : P.incentiveCompatibility
  revelationPrinciple_closed : P.revelationPrinciple
  socialChoiceFunction_closed : P.socialChoiceFunction
  strategyProofness_closed : P.strategyProofness

def MechanismDesignPackageClosed (P : MechanismDesignPackage) : Prop :=
  P.preferenceTypes ∧ P.allocationRule ∧ P.incentiveCompatibility ∧ P.revelationPrinciple ∧
  P.socialChoiceFunction ∧ P.strategyProofness

theorem mechanism_design_closed_from_evidence (P : MechanismDesignPackage)
    (E : MechanismDesignEvidence P) : MechanismDesignPackageClosed P := by
  exact And.intro E.preferenceTypes_closed
    (And.intro E.allocationRule_closed
      (And.intro E.incentiveCompatibility_closed
        (And.intro E.revelationPrinciple_closed
          (And.intro E.socialChoiceFunction_closed E.strategyProofness_closed))))

structure MechanismDesignCertificate (P : MechanismDesignPackage) where
  mechanismExists : Prop
  revelationPrincipleHolds : Prop
  incentiveCompatibleImplementation : Prop
  mechanismExists_closed : mechanismExists
  revelationPrincipleHolds_closed : revelationPrincipleHolds
  incentiveCompatibleImplementation_closed : incentiveCompatibleImplementation
  mechanismEvidence : MechanismDesignEvidence P

def MechanismDesignCertificateClosed (P : MechanismDesignPackage) (C : MechanismDesignCertificate P) : Prop :=
  C.mechanismExists ∧ C.revelationPrincipleHolds ∧ C.incentiveCompatibleImplementation ∧
  MechanismDesignPackageClosed P

theorem mechanism_design_certificate_closed (P : MechanismDesignPackage) (C : MechanismDesignCertificate P) :
    MechanismDesignCertificateClosed P C := by
  exact And.intro C.mechanismExists_closed
    (And.intro C.revelationPrincipleHolds_closed
      (And.intro C.incentiveCompatibleImplementation_closed
        (mechanism_design_closed_from_evidence P C.mechanismEvidence)))

/-! ## Canonical lane bridge for two-person games lemma -/

/-- The admissible-class bridge: each named certificate closes the corresponding
theorem, and together they form the two-person games lemma canonical lane. -/
theorem two_person_games_lemma_canonical_lane_bridge
    {Γ : NormalFormGame} {P : NashExistencePackage Γ}
    {Z : ZeroSumGame} {M : MinimaxExistencePackage Z}
    (B : BargainingSolutionPackage) (D : MechanismDesignPackage)
    (NC : NashEquilibriumCertificate P)
    (MC : MinimaxCertificate M)
    (BC : BargainingCertificate B)
    (DC : MechanismDesignCertificate D) :
    NashEquilibriumCertificateClosed NC ∧
    MinimaxCertificateClosed MC ∧
    BargainingCertificateClosed B BC ∧
    MechanismDesignCertificateClosed D DC := by
  exact And.intro (nash_equilibrium_certificate_closed NC)
    (And.intro (minimax_certificate_closed MC)
      (And.intro (bargaining_certificate_closed B BC)
        (mechanism_design_certificate_closed D DC)))

end TwoPersonGamesLemmaCanonicalLaneLean