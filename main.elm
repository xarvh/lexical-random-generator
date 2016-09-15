
import Dict
import NameGenerator exposing ( Lexicon )
import Html
import Html.App
import Random.Pcg as Random
import String
import String.Extra


import Regex exposing (contains, regex)





le = NameGenerator.fromString """

place
    Thorns,Great Forks,The Lap,Chiaroscuro

adverb
    always,inevitably,necessarily,surely,inescapably,assuredly

superlativeAdjective
    flawless,victorious,favoured,triumphant,successful,fortunate,propitious,lucky,outstanding,strong,
    auspicious,crowned,extraordinary,unbeaten,undefeated,unconquered,prevailing,excellent,superior,greatest,
    illustrious,splendid,fierce

genericAdjective
    blue,red,gray,bloody,yellow,black,white

noun
    champion,challenger,defender,conqueror,guardian,paladin,vanquisher,victor,warrior,
    fury,anger,wrath,storm,
    Sun,Moon

potentiallyQualifiedNoun
    {noun}
    {noun}
    {noun} of {place}
    {noun} of the Gods
    {noun} of {place}

exalted
    {adverb} {superlativeAdjective}
    {adverb} {superlativeAdjective} {potentiallyQualifiedNoun}
    {superlativeAdjective} {potentiallyQualifiedNoun}

ship
    {exalted}
"""







type alias Model =
    List String


type Msg =
    Generate (List String)


init =
    ( []
    , cmdGenerate
    )


cmdGenerate =
    Random.generate Generate <| Random.list 30 (NameGenerator.generator le "ship")


fix s =
--     s
    String.words s
    |> List.map (String.Extra.capitalize True)
    |> String.join " "


update msg model =
    case msg of
        Generate strings ->
            ( List.map fix strings, Cmd.none )



view model =
    Html.ul
        []
        <| List.map (\s -> Html.li [] [ Html.text s ]) model





main = Html.App.program
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }
