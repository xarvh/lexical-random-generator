module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events
import LexicalRandom
import Random
import String.Extra
import Time exposing (Time)
import Task


lexiconAsString =
    """
# This defines how to generate a `fleet` name
# It is used to generate the list *headers* you can see on the right ->
fleet
    # Three different ways of generating a fleet name
    # (Try to add one and see what happens!)
    {color} Fleet
    {properNoun} Fleet
    {noun} Fleet

# This defines how to generate a `ship` name
# It is used to generate the list *entries* you can see on the right ->
ship
    {noun}
    {properNoun}
    {color} {properNoun}
    {color} {noun}
    {superlativeAdjective}
    {pretentious}

adverb
    # you can divide the options by comma or newline, there is no difference
    always,inevitably,necessarily
    surely,inescapably,assuredly

superlativeAdjective
    flawless,victorious,favoured,triumphant,successful,fortunate
    lucky,outstanding,strong,illustrious,splendid,fierce,auspicious,crowned
    extraordinary,unbeaten,undefeated,unconquered,prevailing,excellent,superior
    greatest,amazing,awesome,excellent,fabulous,fantastic,favorable,fortuitous
    ineffable,perfect,propitious,spectacular,wondrous

color
    blue,red,gray,purple,vermillion,yellow,black,white,azure

noun
    champion,challenger,defender,conqueror,guardian,paladin,vanquisher,victor
    warrior,augury,hammer,mallet,anvil,sword,mercy,blade,sabre,dagger,scimitar
    foil,glaive,arrow,fury,anger,wrath,storm,lightning,thunder,omen,vengeance
    light,sunrise,peace
    Sun,Moon,Daystar,cross

potentiallyQualifiedNoun
    {noun}
    {noun}
    {noun} of {properNoun}
    {noun} of {properNoun}
    {noun} of the Gods

pretentious
    {adverb} {superlativeAdjective}
    {adverb} {superlativeAdjective} {potentiallyQualifiedNoun}
    {superlativeAdjective} {potentiallyQualifiedNoun}

properNoun
    {ini}{end}
    {ini}{mid}{end}

# Phonems can be generated from dictionaries or lists of words.
# Check inside the tools/ directory!
ini
    in,re,un,con,de,dis,ex,im,an,com,en,al,pro,pre,per,over,as,ar,di,mis,be,ac,
    sub,ad,ma,mar,car,out,ap,au,or,for,ob,par,co,se,em,man,vi,non,am,mo,su,ab
    cor,ca,pa,es,hy,can,bar,mi,col,so,mon,at,up,ir,ver,ra,mer,lu,gen,trans,pe,ro

mid
    i,ti,a,o,er,ter,u,ri,to,si,cal,di,ca,al,ta,li,ni,tion,per,der,ra,tu,e,ful,na
    ma,la,ing,fi,sa,ci,ous,con,is,en,re

end
    ly,es,ness,er,est,ers,tions,ty,tion,able,ic,ings,ments,ry,ties,tors,al,cal
    man,ters,less,cy,ous,tive,ful,men,ates,ble,an,tic,ists,gy,na,ies,sions,son
    ans,ta,ment,ton,ism,ries,ics,bles,bly,als,fies,fy,la,da,en,lates
"""



-- types


type alias Fleet =
    { name : String
    , shipNames : List String
    }


type alias Model =
    { lexiconAsString : String
    , seed : Random.Seed
    , fleets : List Fleet
    }


type Msg
    = Init Time
    | UserChangesText String



-- generator


generateFleets : Model -> Model
generateFleets model =
    let
        defaultLexicon =
            LexicalRandom.fromString model.lexiconAsString

        generatorByKey key =
            LexicalRandom.generator "???" defaultLexicon key
                |> Random.map String.Extra.toTitleCase

        shipName =
            generatorByKey "ship"

        fleetName =
            generatorByKey "fleet"

        generateSome generator =
            Random.list 4 generator

        generateFleet =
            Random.map2 Fleet fleetName (generateSome shipName)

        ( fleets, unusedSeed ) =
            Random.step (generateSome generateFleet) model.seed
    in
        { model | fleets = fleets }



-- TEA


noCmd : Model -> ( Model, Cmd msg )
noCmd model =
    ( model, Cmd.none )


init : ( Model, Cmd Msg )
init =
    let
        model =
            { lexiconAsString = lexiconAsString
            , seed = Random.initialSeed 0
            , fleets = []
            }

        cmd =
            Task.perform Init Time.now
    in
        ( model, cmd )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Init time ->
            { model | seed = Random.initialSeed (round time) }
                |> generateFleets
                |> noCmd

        UserChangesText lexiconAsString ->
            { model | lexiconAsString = lexiconAsString }
                |> generateFleets
                |> noCmd


view : Model -> Html Msg
view model =
    let
        viewShip name =
            li [] [ text name ]

        viewFleet fleet =
            div
                []
                [ h3 [] [ text fleet.name ]
                , ul [] (List.map viewShip fleet.shipNames)
                ]

        pane =
            style
                [ ( "display", "inline-block" )
                ]
    in
        div
            [ style
                [ ( "display", "flex" )
                , ( "justify-content", "space-around" )
                ]
            ]
            [ div
                []
                [ textarea
                    [ Html.Attributes.cols 120
                    , Html.Attributes.rows 40
                    , Html.Events.onInput UserChangesText
                    ]
                    [ text model.lexiconAsString ]
                ]
            , div
                []
                (List.map viewFleet model.fleets)
            ]


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }
