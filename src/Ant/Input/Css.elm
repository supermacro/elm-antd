module Ant.Input.Css exposing (styles)

import Ant.Css.Common exposing (inputClass)
import Ant.Internals.Typography exposing (commonFontStyles, textColorRgba)
import Ant.Theme exposing (Theme)
import Color.Convert exposing (colorToHexWithAlpha)
import Color.Manipulate exposing (lighten)
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

        focusBoxShadowColor =
            theme.colors.primaryFaded
                |> Color.Manipulate.lighten 0.2
                |> colorToHexWithAlpha
                |> hex

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
                        [ borderColor <| hex <| colorToHexWithAlpha theme.colors.primaryFaded
                        , boxShadow5 zero zero zero (px 2) focusBoxShadowColor
                        , outline none
                        ]
                   , hover
                        [ borderColor <| hex <| colorToHexWithAlpha theme.colors.primaryFaded
                        ]
                   , active
                        [ borderColor <| hex <| colorToHexWithAlpha theme.colors.primary
                        ]
                   , transition
                        [ Css.Transitions.borderColor transitionDuration
                        , Css.Transitions.boxShadow transitionDuration
                        ]
                   ]
    in
    [ CG.class inputClass inputStyles ]
