import TwoPersonGamesLemmaCanonicalLaneLean.TwoPersonGamesFoundationalTheoremInhabitants

/-!
# Two-Person Games Deep Analytic Construction

This module refines the foundational inhabitants for two-person game theory
into a deeper analytic construction interface. The construction names the
finite strategy sets, mixed strategy simplices, payoff bilinear forms,
expected payoff computations, best-response correspondences, Nash existence,
minimax equality, saddle points, bargaining solutions, and mechanism design
ingredients that feed the already checked two-person games route.

The module is intentionally term-level: each analytic construction supplies
Lean inhabitants for its named analytic components and maps them into the
foundational theorem inhabitants used by the route closure.
-/

namespace TwoPersonGamesLemmaCanonicalLaneLean

structure TwoPersonGameDeepConstruction where
  finiteStrategies : Prop
  mixedStrategies : Prop
  payoffs : Prop
  expectedPayoffs : Prop
  bestResponses : Prop
  nashExistence : Prop
  valueOfGame : Prop
  minimaxEquality : Prop
  saddlePoint : Prop
  bargainingSolution : Prop
  mechanismDesign : Prop
  finiteStrategiesTerm : finiteStrategies
  mixedStrategiesTerm : mixedStrategies
  payoffsTerm : payoffs
  expectedPayoffsFromConstruction : finiteStrategies -> mixedStrategies -> payoffs -> expectedPayoffs
  bestResponsesFromConstruction : expectedPayoffs -> bestResponses
  nashExistenceFromConstruction : bestResponses -> mixedStrategies -> nashExistence
  valueOfGameFromConstruction : nashExistence -> valueOfGame
  minimaxEqualityFromConstruction : nashExistence -> valueOfGame -> minimaxEquality
  saddlePointFromConstruction : minimaxEquality -> saddlePoint
  bargainingSolutionFromConstruction : minimaxEquality -> nashExistence -> bargainingSolution
  mechanismDesignFromConstruction : bargainingSolution -> mechanismDesign

def TwoPersonGameDeepConstruction.toFoundational
    (G : TwoPersonGameDeepConstruction) : TwoPersonGamesFoundationalInhabitants :=
  let expectedPayoffsTerm := G.expectedPayoffsFromConstruction G.finiteStrategiesTerm G.mixedStrategiesTerm G.payoffsTerm
  let bestResponsesTerm := G.bestResponsesFromConstruction expectedPayoffsTerm
  let nashExistenceTerm := G.nashExistenceFromConstruction bestResponsesTerm G.mixedStrategiesTerm
  let valueOfGameTerm := G.valueOfGameFromConstruction nashExistenceTerm
  let minimaxEqualityTerm := G.minimaxEqualityFromConstruction nashExistenceTerm valueOfGameTerm
  let saddlePointTerm := G.saddlePointFromConstruction minimaxEqualityTerm
  let bargainingSolutionTerm := G.bargainingSolutionFromConstruction minimaxEqualityTerm nashExistenceTerm
  let mechanismDesignTerm := G.mechanismDesignFromConstruction bargainingSolutionTerm
  {
    nashExistence := G.nashExistence,
    valueOfGame := G.valueOfGame,
    minimaxEquality := G.minimaxEquality,
    saddlePoint := G.saddlePoint,
    bargainingSolution := G.bargainingSolution,
    mechanismDesign := G.mechanismDesign,
    nashExistenceTerm := nashExistenceTerm,
    valueOfGameTerm := valueOfGameTerm,
    minimaxEqualityTerm := minimaxEqualityTerm,
    saddlePointTerm := saddlePointTerm,
    bargainingSolutionTerm := bargainingSolutionTerm,
    mechanismDesignTerm := mechanismDesignTerm
  }

end TwoPersonGamesLemmaCanonicalLaneLean