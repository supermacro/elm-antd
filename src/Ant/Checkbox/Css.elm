module Ant.Checkbox.Css exposing (styles)

import Ant.Css.Common exposing (checkboxCustomCheckmarkClass, checkboxLabelClass, makeSelector, userSelectNone)
import Ant.Internals.Typography exposing (commonFontStyles, headingColorRgba)
import Ant.Theme exposing (Theme)
import Color.Convert exposing (colorToHexWithAlpha)
import Css exposing (..)
import Css.Global as CG exposing (Snippet)
import Css.Transitions exposing (transition, easeInOut, Transition)
import Css.Animations as Animations

textColor : Color
textColor =
    let
        { r, g, b, a } =
            headingColorRgba
    in
    rgba r g b a


emptyContent : Style
emptyContent =
    property "content" "\"\""


styles : Theme -> List Snippet
styles theme =
    let
        primaryColor =
            hex <| colorToHexWithAlpha theme.colors.primary
        checkboxEffect = (Animations.keyframes [(0, [(Animations.opacity (num 0.5)), (Animations.transform [scale 1.0])]), (100, [(Animations.opacity (num 0)), (Animations.transform [scale 1.6])])])
    in
    [ CG.class "checkbox-wrapper"
        (commonFontStyles
            ++ userSelectNone
            ++ [ display inlineBlock
               , height (px 16)
               , width (px 16)
               , color textColor
               , position relative
               --, paddingLeft (px 22)
               , paddingTop (px 1)
               , fontSize (px 14)
               , cursor pointer
               ]
        )
    , CG.class ("checkbox-wrapper" ++ "--disabled")
        [ cursor notAllowed ]

    -- hide the default browser checkbox
    -- the default browser checkbox is used to maintain the state of the checkbox.
    -- We then use the state ("checked" or "unchecked" to style our checkbox appropriately)
    , makeSelector ("checkbox-wrapper" ++ "> input[type=\"checkbox\"]")
        [ display none
        ]

    , makeSelector ("checkbox-wrapper--checked::after")
        [ emptyContent
        , borderRadius (px 2)
        , borderWidth (px 1)
        , borderStyle solid
        , borderColor (hex "#ff1818")
        --, visibility hidden
        , width (pct 100)
        , height (pct 100)
        , top zero
        , left zero
        , position absolute
        , animationName checkboxEffect
        , animationDuration (sec 0.36)
        , Css.property "animation-fill-mode" "backwards"
        , Css.property "animation-timing-function" "ease-in-out"
        ]

    -- base custom checkbox / checkmark styles
    , makeSelector ("checkbox-wrapper" ++ "> " ++ ("." ++ checkboxCustomCheckmarkClass))
        [ position absolute
        , top zero
        , left zero
        , height (px 16)
        , width (px 16)
        , backgroundColor (hex "#fff")
        , borderRadius (px 2)
        , borderWidth (px 1)
        , borderStyle solid
        , borderColor (hex "#d9d9d9")
        , Css.property "transition" "all 0.3s"
        ]

    -- checked checkbox styles
    , makeSelector ("checkbox-wrapper" ++ "> input[type=\"checkbox\"]:checked ~ " ++ "." ++ checkboxCustomCheckmarkClass)
        [ backgroundColor primaryColor
        , borderColor primaryColor
        ]
    , makeSelector ("checkbox-wrapper" ++ "> input[type=\"checkbox\"]:active ~ " ++ "." ++ checkboxCustomCheckmarkClass)
        [ borderColor primaryColor
        ]
    , makeSelector ("checkbox-wrapper" ++ "> input[type=\"checkbox\"]:hover ~ " ++ "." ++ checkboxCustomCheckmarkClass)
        [ borderColor primaryColor
        ]
    , makeSelector ("checkbox-wrapper" ++ "> input[type=\"checkbox\"]:disabled ~ " ++ "." ++ checkboxCustomCheckmarkClass)
        [ borderColor (hex "#d9d9d9")
        , backgroundColor (hex "#f5f5f5")
        , cursor notAllowed
        ]

    -- checkmark styles
    , makeSelector ("checkbox-wrapper" ++ "> " ++ "." ++ checkboxCustomCheckmarkClass ++ ":after")
        [ emptyContent
        , position absolute
        , display block
        , visibility hidden
        , left (px 4)
        , top (px 1.63)
        , width (px 5.5)
        , height (px 9)
        , borderStyle solid
        , borderColor (hex "#fff")
        , borderWidth4 zero (px 2) (px 2) zero
        , transform <| rotate (deg 45)
        ]
    , makeSelector ("checkbox-wrapper" ++ "> input[type=\"checkbox\"]:disabled ~" ++ "." ++ checkboxCustomCheckmarkClass ++ ":after")
        [ borderColor (hex "#b8b8b8")
        ]

    -- show checkmark when checkbox is checked
    , makeSelector ("checkbox-wrapper" ++ "> " ++ "input[type=\"checkbox\"]:checked ~ " ++ "." ++ checkboxCustomCheckmarkClass ++ ":after")
        [ visibility visible
        ]
    ]
