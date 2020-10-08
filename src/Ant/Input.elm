module Ant.Input exposing (input, InputSize(..), withSize, onInput, withPlaceholder, toHtml)

{-| Input widget for data entry

@docs input, InputSize, withSize, onInput, withPlaceholder, toHtml

-}

import Ant.Internals.Typography exposing (commonFontStyles, textColorRgba)
import Ant.Theme exposing (Theme, defaultTheme)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html exposing (Html)
import Html.Styled as H exposing (toUnstyled)
import Html.Styled.Attributes exposing (css, placeholder)
import Html.Styled.Events as E


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
    , theme : Theme
    }


defaultInputOpts : InputOpts msg
defaultInputOpts =
    { size = Default
    , placeholder = Nothing
    , onInput = Nothing
    , theme = defaultTheme
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



--- UI Code


textColor : Color
textColor =
    let
        { r, g, b, a } =
            textColorRgba
    in
    rgba r g b a


{-| Convert the input into a `Html msg`
-}
toHtml : Input msg -> Html msg
toHtml (Input inputOpts) =
    let
        transitionDuration =
            350

        inputStyles =
            commonFontStyles
                ++ [ color textColor
                   , borderWidth (px 1)
                   , borderRadius (px 2)
                   , width (pct 100)
                   , height (px 30)
                   , borderStyle solid
                   , backgroundColor (hex "#fff")
                   , borderColor <| rgb 217 217 217
                   , property "caret-color" "#000"
                   , padding2 (px 4) (px 11)
                   , focus
                        [ borderColor (hex inputOpts.theme.primaryFaded)
                        , boxShadow5 zero zero zero (px 2) (rgba 24 144 255 0.2)
                        ]
                   , hover
                        [ borderColor (hex inputOpts.theme.primaryFaded)
                        ]
                   , active
                        [ borderColor (hex inputOpts.theme.primary)
                        ]
                   , focus
                        [ outline none ]
                   , transition
                        [ Css.Transitions.borderColor transitionDuration
                        , Css.Transitions.boxShadow transitionDuration
                        ]
                   ]

        placeholderValue =
            Maybe.withDefault "" inputOpts.placeholder

        optionalAttributes =
            case inputOpts.onInput of
                Just tagger ->
                    [ E.onInput tagger ]

                Nothing ->
                    []
    in
    toUnstyled <|
        H.input ([ css inputStyles, placeholder placeholderValue ] ++ optionalAttributes) []
