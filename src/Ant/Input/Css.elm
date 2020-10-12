module Ant.Input.Css exposing (styles)

import Ant.Css.Common exposing (inputClass)
import Ant.Internals.Typography exposing (commonFontStyles, textColorRgba)
import Ant.Theme exposing (Theme)
import Css exposing (..)
import Css.Global as CG exposing (Snippet)
import Css.Transitions exposing (transition)


textColor : Color
textColor =
    let
        { r, g, b, a } =
            textColorRgba
    in
    rgba r g b a


styles : Theme -> List Snippet
styles theme =
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
                        [ borderColor (hex theme.primaryFaded)
                        , boxShadow5 zero zero zero (px 2) (rgba 24 144 255 0.2)
                        ]
                   , hover
                        [ borderColor (hex theme.primaryFaded)
                        ]
                   , active
                        [ borderColor (hex theme.primary)
                        ]
                   , focus
                        [ outline none ]
                   , transition
                        [ Css.Transitions.borderColor transitionDuration
                        , Css.Transitions.boxShadow transitionDuration
                        ]
                   ]
    in
    [ CG.class inputClass inputStyles ]
