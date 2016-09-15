module NameGenerator exposing
    ( Definition, Lexicon
    , generator
    , fromString
    )


import Dict exposing (Dict)
import Random.Pcg as Random exposing (Generator)
import String
import Regex



-- types

type alias Definition =
    List String


type alias Lexicon =
    Dict String (List Definition)



-- Generate a name given a lexicon and a key of that lexicon

generator : Lexicon -> String -> Generator String
generator lexicon key =

    case Dict.get key lexicon of

        Nothing ->
            -- either the key is plain invalid, or it is stuck in a loop
            Random.constant <| "--[" ++ key ++ "]--"

        Just definitions ->
            let
                reducedLexicon =
                    Dict.remove key lexicon


                -- TODO: PR to mgold/elm-random-pcb to add a mapN : (List a -> b) -> List (Generator a) -> Generator b
                foldDefinition definitionFragment accumulatedGenerator =
                    Random.map2 (++) accumulatedGenerator <|
                        case String.uncons definitionFragment of
                            Just ( '$', key ) -> generator reducedLexicon key
                            _ -> Random.constant definitionFragment


                definitionToGenerator : Definition -> Generator String
                definitionToGenerator definition =
                    List.foldl foldDefinition (Random.constant "") definition
            in
                Random.choices <| List.map definitionToGenerator definitions



-- Load a lexicon from a multi-line string

fromString : String -> Lexicon
fromString stringLexicon =
    let
        stringToDefinition stringDefinition =
            let
                chunkToFrags chunk =
                    case String.split "}" chunk of
                        key :: constant :: [] -> [ "$" ++ key, constant ]
                        _ -> [chunk]
            in
                stringDefinition
                |> String.split "{"
                |> List.map chunkToFrags
                |> List.concat


        addToLexiconKey key line lexicon =
            let
                newDefinitions =
                    String.trim line
                    |> String.split ","
                    |> List.map stringToDefinition

                existingDefinitions =
                    Dict.get key lexicon
                    |> Maybe.withDefault []
            in
                Dict.insert key (List.append existingDefinitions newDefinitions) lexicon


        addLine : String -> ( String, Lexicon ) -> ( String, Lexicon )
        addLine line ( currentKey, lexicon ) =
            if Regex.contains (Regex.regex "^\\s*#") line
            then ( currentKey, lexicon )
            else
                if Regex.contains (Regex.regex "^\\s") line
                then ( currentKey, addToLexiconKey currentKey line lexicon )
                else ( line, lexicon )
    in
        snd <| List.foldl addLine ("default", Dict.empty) (String.lines stringLexicon)
