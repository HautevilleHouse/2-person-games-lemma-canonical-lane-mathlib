import Mathlib

/-!
# Two Person Games Lemma Foundational Theorem Inhabitants

This module gives the term-level interface for the foundational two-person game
theorem inhabitants. A complete game-theoretic formalization supplies these
records; the records then construct the certificates for Nash equilibrium,
minimax theorem, bargaining solutions, mechanism design, and the canonical
bridge statements.
-/

namespace TwoPersonGamesLemmaCanonicalLaneLean

structure GameFoundations where
  twoPlayers : Prop
  finiteActions : Prop
  payoffFunctionsDefined : Prop
  expectedUtilityDefined : Prop
  twoPlayersTerm : twoPlayers
  finiteActionsTerm : finiteActions
  payoffFunctionsDefinedTerm : payoffFunctionsDefined
  expectedUtilityDefinedTerm : expectedUtilityDefined

structure MixedStrategies where
  probabilityDistributionsExist : Prop
  pureStrategiesEmbedded : Prop
  mixedExtensionsDefined : Prop
  simplexCompact : Prop
  probabilityDistributionsExistTerm : probabilityDistributionsExist
  pureStrategiesEmbeddedTerm : pureStrategiesEmbedded
  mixedExtensionsDefinedTerm : mixedExtensionsDefined
  simplexCompactTerm : simplexCompact

structure BestResponse where
  bestResponseDefined : Prop
  payoffMaximizing : Prop
  nonemptyBestResponse : Prop
  bergeTheorem : Prop
  bestResponseDefinedTerm : bestResponseDefined
  payoffMaximizingTerm : payoffMaximizing
  nonemptyBestResponseTerm : nonemptyBestResponse
  bergeTheoremTerm : bergeTheorem

structure NashEquilibrium where
  equilibriumDefined : Prop
  mutualBestResponse : Prop
  existenceTheorem : Prop
  nashExistenceMixed : Prop
  equilibriumDefinedTerm : equilibriumDefined
  mutualBestResponseTerm : mutualBestResponse
  existenceTheoremTerm : existenceTheorem
  nashExistenceMixedTerm : nashExistenceMixed

structure MinimaxTheorem where
  zeroSumGame : Prop
  valueDefined : Prop
  minimaxEquality : Prop
  saddlePointExists : Prop
  zeroSumGameTerm : zeroSumGame
  valueDefinedTerm : valueDefined
  minimaxEqualityTerm : minimaxEquality
  saddlePointExistsTerm : saddlePointExists

structure BargainingSolution where
  feasiblePayoffs : Prop
  disagreementPoint : Prop
  nashBargainingAxioms : Prop
  uniqueSolution : Prop
  feasiblePayoffsTerm : feasiblePayoffs
  disagreementPointTerm : disagreementPoint
  nashBargainingAxiomsTerm : nashBargainingAxioms
  uniqueSolutionTerm : uniqueSolution

structure MechanismDesign where
  socialChoiceFunction : Prop
  incentiveCompatibility : Prop
  revelationPrinciple : Prop
  implementationTheory : Prop
  socialChoiceFunctionTerm : socialChoiceFunction
  incentiveCompatibilityTerm : incentiveCompatibility
  revelationPrincipleTerm : revelationPrinciple
  implementationTheoryTerm : implementationTheory

structure BridgeStatements where
  nashExistenceFiniteGame : Prop
  minimaxZeroSum : Prop
  revelationPrinciple : Prop
  nashExistenceFiniteGameTerm : nashExistenceFiniteGame
  minimaxZeroSumTerm : minimaxZeroSum
  revelationPrincipleTerm : revelationPrinciple

structure TwoPersonGamesLemmaFoundationalInhabitants where
  game : GameFoundations
  mixed : MixedStrategies
  bestResponse : BestResponse
  nash : NashEquilibrium
  minimax : MinimaxTheorem
  bargaining : BargainingSolution
  mechanism : MechanismDesign
  bridge : BridgeStatements

end TwoPersonGamesLemmaCanonicalLaneLean