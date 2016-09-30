module Main exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events
import LexicalRandom as LexicalRandom
import Random
import Time exposing (Time)
import Task


lexicon =
    """
# this is a comment

ini
    # definitions can be separed by comma or newline, it's the same
    in,re,un,con,de,dis,ex,im,an,com,en,al,pro,pre,per,over,as,ar,di,mis,be,ac,sub,ad,ma,mar,car,out,ap,au,or,for,ob,
    par,co,se,em,man,vi,non,am,mo,su,ab,cor,ca,pa,es,hy,can,bar,mi,col,so,mon,at,up,ir,ver,ra,mer,lu,gen,trans,pe,ro,

mid
    i,ti,a,o,er,ter,u,ri,to,si,cal,di,ca,al,ta,li,ni,tion,per,der,ra,tu,e,ful,na,ma,la,ing,fi,sa,ci,ous,con,is,en,re,

end
    ly,es,ness,er,est,ers,tions,ty,tion,able,ic,ings,ments,ry,ties,tors,al,cal,man,ters,less,cy,ous,tive,ful,men,
    ates,ble,an,tic,ists,gy,na,ies,sions,son,ans,ta,ment,ton,ism,ries,ics,bles,bly,als,fies,fy,la,da,en,lates,

properNoun
    {ini}{end}
    {ini}{mid}{end}

adverb
    always,inevitably,necessarily,surely,inescapably,assuredly

superlativeAdjective
    flawless,victorious,favoured,triumphant,successful,fortunate,lucky,outstanding,strong,illustrious,splendid,fierce
    auspicious,crowned,extraordinary,unbeaten,undefeated,unconquered,prevailing,excellent,superior,greatest
    amazing,awesome,excellent,fabulous,fantastic,favorable,fortuitous,ineffable,perfect,propitious,spectacular,wondrous

color
    blue,red,gray,purple,vermillion,yellow,black,white,azure

noun
    champion,challenger,defender,conqueror,guardian,paladin,vanquisher,victor,warrior,augury
    hammer,mallet,anvil,sword,mercy,blade,sabre,dagger,scimitar,foil,glaive
    arrow,fury,anger,wrath,storm,lightning,thunder,omen,vengeance,light,sunrise,peace
    Sun,Moon,Daystar,cross

potentiallyQualifiedNoun
    {noun}
    {noun}
    {noun} of {properNoun}
    {noun} of {properNoun}
    {noun} of the Gods

exalted
    {adverb} {superlativeAdjective}
    {adverb} {superlativeAdjective} {potentiallyQualifiedNoun}
    {superlativeAdjective} {potentiallyQualifiedNoun}

ship
    {noun}
    {properNoun}
    {color} {properNoun}
    {color} {noun}
    {superlativeAdjective}
    {exalted}

fleet
    {color} Fleet
    {properNoun} Fleet
    {noun} Fleet
"""



-- MODEL


type alias Fleet =
    { name : String
    , shipNames : List String
    }


type alias Model =
    { lexicon : String
    , seed : Random.Seed
    , fleets : List Fleet
    }


init =
    ( Model lexicon (Random.initialSeed 0) [], Task.perform identity Init Time.now )



-- GENERATORS


updateFleets model =
    let
        defaultLexicon =
            LexicalRandom.fromString model.lexicon

        filler key =
            "[" ++ key ++ "?]"

        generatorByKey key =
            LexicalRandom.generator filler defaultLexicon key
                |> Random.map LexicalRandom.capitalize

        shipName =
            generatorByKey "ship"

        fleetName =
            generatorByKey "fleet"

        generateSome generator =
            Random.int 2 5 `Random.andThen` \n -> Random.list n generator

        generateFleet =
            Random.map2 Fleet fleetName (generateSome shipName)

        ( fleets, unusedSeed ) =
            Random.step (generateSome generateFleet) model.seed
    in
        { model | fleets = fleets }



-- UPDATE


type Msg
    = Init Time
    | UserChangesText String


update msg model =
    case msg of
        Init time ->
            ( updateFleets { model | seed = Random.initialSeed (round time) }, Cmd.none )

        UserChangesText lexicon ->
            ( updateFleets { model | lexicon = lexicon }, Cmd.none )



-- VIEW


view model =
    let
        viewShip name =
            li [] [ text name ]

        viewFleet fleet =
            div
                []
                [ h1 [] [ text fleet.name ]
                , ul [] (List.map viewShip fleet.shipNames)
                ]

        pane =
            style
                [ ( "display", "inline-block" )
                ]
    in
        div
            []
            [ div
                [ pane ]
                [ textarea
                    [ cols 120
                    , rows 40
                    , Html.Events.onInput UserChangesText
                    ]
                    [ text model.lexicon ]
                ]
            , div [ pane ] (List.map viewFleet model.fleets)
            ]


main =
    Html.App.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
