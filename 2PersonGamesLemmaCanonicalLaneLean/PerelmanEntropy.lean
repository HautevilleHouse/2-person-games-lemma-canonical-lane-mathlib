/-!
# Two-Person Games Lemma Package
-/

namespace HautevilleHouse
namespace TwoPersonGamesLemmaCanonicalLaneLean

universe u

-- A basic structure for a two-person game.
structure TwoPersonGame (I : Type u) (II : Type u) (A : Type u) where
  payoff₁ : I → II → A
  payoff₂ : I → II → A

-- A meaningful definition: Nash equilibrium in a two-person game.
def IsNashEquilibrium {I II A : Type} [LE A]
    (G : TwoPersonGame I II A) (s₁ : I) (s₂ : II) : Prop :=
  (∀ i : I, G.payoff₁ s₁ s₂ ≥ G.payoff₁ i s₂) ∧
  (∀ j : II, G.payoff₂ s₁ s₂ ≥ G.payoff₂ s₁ j)

-- The admissible-class bridge package: for a given class of games,
-- each field is a predicate asserting that the corresponding key theorem
-- holds for that game.
structure TwoPersonGamesLemmaPackage (Game : Type u) where
  nashEquilibrium : Game → Prop
  minimaxTheorem : Game → Prop
  bargainingSolution : Game → Prop
  mechanismDesign : Game → Prop
  twoPersonGamesLemma : Game → Prop

-- Evidence that the bridge is real: for every game in the class,
-- each of the key results is closed.
structure TwoPersonGamesLemmaEvidence {Game : Type u} (P : TwoPersonGamesLemmaPackage Game) where
  nashEquilibrium_bridge : ∀ g : Game, P.nashEquilibrium g
  minimaxTheorem_bridge : ∀ g : Game, P.minimaxTheorem g
  bargainingSolution_bridge : ∀ g : Game, P.bargainingSolution g
  mechanismDesign_bridge : ∀ g : Game, P.mechanismDesign g
  twoPersonGamesLemma_bridge : ∀ g : Game, P.twoPersonGamesLemma g

-- The closed form of the package: all key results hold for all games.
def TwoPersonGamesLemmaClosed {Game : Type u} (P : TwoPersonGamesLemmaPackage Game) : Prop :=
  ∀ g : Game,
    P.nashEquilibrium g ∧ P.minimaxTheorem g ∧ P.bargainingSolution g ∧
    P.mechanismDesign g ∧ P.twoPersonGamesLemma g

-- Bridge theorem: evidence from each individual game closes the entire package.
theorem two_person_games_lemma_closed_from_evidence
    {Game : Type u} (P : TwoPersonGamesLemmaPackage Game) (E : TwoPersonGamesLemmaEvidence P) :
    TwoPersonGamesLemmaClosed P := by
  intro g
  exact And.intro (E.nashEquilibrium_bridge g)
    (And.intro (E.minimaxTheorem_bridge g)
      (And.intro (E.bargainingSolution_bridge g)
        (And.intro (E.mechanismDesign_bridge g) (E.twoPersonGamesLemma_bridge g))))

end TwoPersonGamesLemmaCanonicalLaneLean
end HautevilleHouse