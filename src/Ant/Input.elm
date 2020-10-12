module Ant.Input exposing (input, InputSize(..), withSize, onInput, withPlaceholder, toHtml)

{-
    A NOTE TO DEVELOPERS.

    This component is themable.

    See styles at src/Ant/Input/Css.elm
-}


{-| Input widget for data entry

@docs input, InputSize, withSize, onInput, withPlaceholder, toHtml

-}

import Ant.Css.Common exposing (inputClass)
import Css exposing (..)
import Html as H exposing (Html)
import Html.Attributes exposing (class, placeholder)
import Html.Events as E


type Input msg
    = Input (InputOpts msg)


{-| Determines the vertical height of the input
-}
type InputSize
    = Default
    | Large
    | Small


type alias InputOpts msg =
    { size : InputSize
    , placeholder : Maybe String
    , onInput : Maybe (String -> msg)
    }


defaultInputOpts : InputOpts msg
defaultInputOpts =
    { size = Default
    , placeholder = Nothing
    , onInput = Nothing
    }


{-| Create a customizeable input component
-}
input : Input msg
input =
    Input defaultInputOpts


{-| Add a placeholder to the input
-}
withPlaceholder : String -> Input msg -> Input msg
withPlaceholder value (Input inputOpts) =
    let
        newOpts =
            { inputOpts | placeholder = Just value }
    in
    Input newOpts


{-| Change the size of the input
-}
withSize : InputSize -> Input msg -> Input msg
withSize size (Input inputOpts) =
    let
        newOpts =
            { inputOpts | size = size }
    in
    Input newOpts


{-| Emit a `msg` event that contains the current value (of type `String`) of the input on every keystroke
-}
onInput : (String -> msg) -> Input msg -> Input msg
onInput tagger (Input inputOpts) =
    let
        newOpts =
            { inputOpts | onInput = Just tagger }
    in
    Input newOpts



{-| Convert the input into a `Html msg`
-}
toHtml : Input msg -> Html msg
toHtml (Input inputOpts) =
    let
        placeholderValue =
            Maybe.withDefault "" inputOpts.placeholder

        optionalAttributes =
            case inputOpts.onInput of
                Just tagger ->
                    [ E.onInput tagger ]

                Nothing ->
                    []
    in
    H.input ([ class inputClass, placeholder placeholderValue ] ++ optionalAttributes) []

