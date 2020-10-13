module Ant.Button.Css exposing (styles)

{- Themable styles for Button component -}

import Ant.Css.Common exposing (..)
import Ant.Internals.Typography exposing (fontList, textColorRgba)
import Ant.Theme exposing (Theme)
import Css exposing (..)
import Css.Animations as CA exposing (keyframes)
import Css.Global as CG exposing (Snippet)
import Css.Transitions exposing (transition)


textColor : Color
textColor =
    let
        { r, g, b, a } =
            textColorRgba
    in
    rgba r g b a


cursorHoverEnabled : Bool -> Style
cursorHoverEnabled enabled =
    let
        rule =
            if enabled then
                pointer

            else
                notAllowed
    in
    hover [ cursor rule ]


disabledBorderColor : Style
disabledBorderColor =
    borderColor <| rgb 217 217 217


simpleDisabledRules : List Style
simpleDisabledRules =
    [ disabledBorderColor
    , borderStyle solid
    , cursorHoverEnabled False
    ]


styles : Theme -> List Snippet
styles theme =
    let
        transitionDuration =
            350

        antButtonBoxShadow =
            Css.boxShadow5 (px 0) (px 2) (px 0) (px 0) (Css.rgba 0 0 0 0.016)

        waveEffect =
            keyframes
                [ ( 100, [ CA.property "box-shadow" <| "0 0 0 " ++ theme.colors.primaryStrong ] )
                , ( 100, [ CA.property "box-shadow" <| "0 0 0 8px " ++ theme.colors.primaryStrong ] )
                , ( 100, [ CA.property "opacity" "0" ] )
                ]

        animatedBefore : ColorValue compatible -> Style
        animatedBefore color =
            before
                [ property "content" "\" \""
                , display block
                , position absolute
                , width (pct 100)
                , height (pct 100)
                , right (px 0)
                , left (px 0)
                , top (px 0)
                , bottom (px 0)
                , borderRadius (px 2)
                , backgroundColor color
                , boxShadow4 (px 0) (px 0) (px 0) (hex theme.colors.primary)
                , opacity (num 0.2)
                , zIndex (int -1)
                , animationName waveEffect
                , animationDuration (sec 1.5)
                , property "animation-timing-function" "cubic-bezier(0.08, 0.82, 0.17, 1)"
                , property "animation-fill-mode" "forwards"
                , pointerEvents none
                ]

        animationStyle =
            CG.withClass "elm-antd__animated_before"
                [ position relative
                , animatedBefore (hex theme.colors.primaryStrong)
                ]

        baseAttributes =
            [ borderRadius (px 2)
            , padding2 (px 4) (px 15)
            , fontFamilies fontList
            , borderWidth (px 1)
            , fontSize (px 14)
            , height (px 30)
            , outline none
            ]

        defaultButtonStyles =
            [ color textColor
            , borderStyle solid
            , backgroundColor (hex "#fff")
            , borderColor <| rgb 217 217 217
            , antButtonBoxShadow
            , animationStyle
            , focus
                [ borderColor (hex theme.colors.primaryFaded)
                , color (hex theme.colors.primaryFaded)
                ]
            , hover
                [ borderColor (hex theme.colors.primaryFaded)
                , color (hex theme.colors.primaryFaded)
                ]
            , active
                [ borderColor (hex theme.colors.primary)
                , color (hex theme.colors.primary)
                ]
            , transition
                [ Css.Transitions.borderColor transitionDuration
                , Css.Transitions.color transitionDuration
                ]
            ]

        primaryButtonStyles =
            [ color (hex "#fff")
            , borderStyle solid
            , backgroundColor (hex theme.colors.primary)
            , borderColor (hex theme.colors.primary)
            , antButtonBoxShadow
            , animationStyle
            , focus
                [ backgroundColor (hex theme.colors.primaryFaded)
                , borderColor (hex theme.colors.primaryFaded)
                ]
            , hover
                [ backgroundColor (hex theme.colors.primaryFaded)
                , borderColor (hex theme.colors.primaryFaded)
                ]
            , active
                [ backgroundColor (hex theme.colors.primaryStrong)
                , borderColor (hex theme.colors.primaryStrong)
                ]
            , transition
                [ Css.Transitions.backgroundColor transitionDuration
                , Css.Transitions.borderColor transitionDuration
                ]
            ]

        textButtonStyles =
            [ color textColor
            , border zero
            , backgroundColor (hex "#fff")
            , hover
                [ backgroundColor (rgba 0 0 0 0.018) ]
            , transition
                [ Css.Transitions.backgroundColor transitionDuration ]
            ]

        dashedButtonAttributes =
            defaultButtonStyles
                ++ [ borderStyle dashed
                   ]

        linkButtonAttributes =
            [ color (hex theme.colors.primary)
            , border zero
            , backgroundColor (hex "#fff")
            , hover
                [ color (hex theme.colors.primaryFaded) ]
            , transition
                [ Css.Transitions.color transitionDuration ]
            ]
    in
    [ CG.class btnClass baseAttributes

    -- default button styles
    , makeSelector (btnDefaultClass ++ ":not([disabled])")
        (cursorHoverEnabled True :: defaultButtonStyles)
    , makeSelector (btnDefaultClass ++ ":disabled")
        simpleDisabledRules

    -- primary button styles
    , makeSelector (btnPrimaryClass ++ ":not([disabled])")
        (cursorHoverEnabled True :: primaryButtonStyles)
    , makeSelector (btnPrimaryClass ++ ":disabled")
        simpleDisabledRules

    -- dashed button styles
    , makeSelector (btnDashedClass ++ ":not([disabled])")
        (cursorHoverEnabled True :: dashedButtonAttributes)
    , makeSelector (btnDashedClass ++ ":disabled")
        [ disabledBorderColor
        , borderStyle dashed
        , cursorHoverEnabled False
        ]

    -- text button styles
    , makeSelector (btnTextClass ++ ":not([disabled])")
        (cursorHoverEnabled True :: textButtonStyles)
    , makeSelector (btnTextClass ++ ":disabled")
        [ border zero
        , backgroundColor transparent
        , cursorHoverEnabled False
        ]

    -- link button styles
    , makeSelector (btnLinkClass ++ ":not([disabled])")
        (cursorHoverEnabled True :: linkButtonAttributes)
    , makeSelector (btnLinkClass ++ ":disabled")
        baseAttributes
    ]
