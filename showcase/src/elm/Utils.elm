port module Utils exposing
    ( ComponentCategory(..)
    , DocumentationRoute
    , copySourceToClipboard
    , intoKebabCase
    )

import Html.Styled as Styled


port copySourceToClipboard : String -> Cmd msg


type ComponentCategory
    = General
    | Layout
    | Navigation
    | DataEntry
    | DataDisplay
    | Feedback
    | Other


type alias RouteTitle =
    String


type alias DocumentationRoute model msg =
    { title : RouteTitle
    , update : msg -> model -> ( model, Cmd msg )
    , category : ComponentCategory
    , view : model -> Styled.Html msg
    , initialModel : model
    }


intoTracker : ( Int, Char ) -> String -> String
intoTracker ( charIdx, char ) current =
    let
        newCurrentWord =
            if Char.isUpper char then
                let
                    lowercase =
                        String.fromChar <| Char.toLower char
                in
                if charIdx /= 0 then
                    current ++ "-" ++ lowercase

                else
                    current ++ lowercase

            else
                current ++ String.fromChar char
    in
    newCurrentWord


{-| Takes a PascalCase or snakeCase string and turns it into kebab-case-string
-}
intoKebabCase : String -> String
intoKebabCase str =
    let
        charList =
            String.toList str

        indexedList =
            List.indexedMap Tuple.pair charList
    in
    List.foldl intoTracker "" indexedList
