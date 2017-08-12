module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (style)
import NameGenerator
import Random exposing (Generator)
import Random.Extra
import Task
import Time exposing (Time)


type alias Model =
    { names : Dict String (List String)
    }


type Msg
    = OnNow Time



-- generate names


namesListGenerator : String -> Generator (List String)
namesListGenerator color =
    Random.list 10 (NameGenerator.ship color)


colorAndNamesGenerator : String -> Generator ( String, List String )
colorAndNamesGenerator color =
    namesListGenerator color |> Random.map ((,) color)


namesDictGenerator : Generator (Dict String (List String))
namesDictGenerator =
    [ "yellow"
    , "purple"
    , "cyan"
    ]
        |> List.map colorAndNamesGenerator
        |> Random.Extra.combine
        |> Random.map Dict.fromList



-- View


viewColor : ( String, List String ) -> Html msg
viewColor ( color, names ) =
    div
        [ style [ ( "color", color ) ] ]
        [ h3 [] [ "Names for a " ++ color ++ " ship:" |> text ]
        , ul
            []
            (List.map (\n -> li [] [ text n ]) names)
        ]


view : Model -> Html msg
view model =
    model.names
        |> Dict.toList
        |> List.map viewColor
        |> div
            [ style
                [ ( "display", "flex" )
                , ( "justify-content", "space-around" )
                , ( "background-color", "grey" )
                ]
            ]



-- TEA


init : ( Model, Cmd Msg )
init =
    ( { names = Dict.empty }, Task.perform OnNow Time.now )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnNow now ->
            let
                ( names, newSeed ) =
                    now
                        |> round
                        |> Random.initialSeed
                        |> Random.step namesDictGenerator
            in
                ( { model | names = names }, Cmd.none )


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
