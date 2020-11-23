module Ant.Typography.Text.Css exposing
    ( styles
    , textCodeClass
    , textClass
    , textKeyboardClass
    , textLinkClass
    , textPrimaryClass
    , textSecondaryClass
    , textWarningClass
    , textDangerClass
    )

import Ant.Theme exposing (Theme)
import Ant.Css.Common exposing (elmAntdPrefix)
import Ant.Internals.Typography exposing (fontList, textSelectionStyles)
import Css exposing (..)
import Css.Global as CG exposing (Snippet)
import Css.Transitions exposing (transition)
import Color
import Color.Convert exposing (colorToHexWithAlpha)
import Color.Manipulate as Manipulate


-- Class List

textClass : String
textClass =
    elmAntdPrefix ++ "__text"


textLinkClass : String
textLinkClass =
    textClass ++ "-link"

textPrimaryClass : String
textPrimaryClass =
    textClass ++ "-primary"

textSecondaryClass : String
textSecondaryClass =
    textClass ++ "-secondary"

textWarningClass : String
textWarningClass =
    textClass ++ "-warning"

textDangerClass : String
textDangerClass =
    textClass ++ "-danger"

textCodeClass : String
textCodeClass =
    textClass ++ "-code"

textKeyboardClass : String
textKeyboardClass =
    textClass ++ "-keyboard"



---- 

codeFontList : List String
codeFontList =
    [ qt "SFMono-Regular"
    , "Consolas"
    , qt "Liberation Mono"
    , "Menlo"
    , "Courier"
    , "monospace"
    ]

type Effects = NoHoverEffect | WithHoverEffect

createColorStyles : Color.Color -> Effects -> List Style
createColorStyles color_ effects =
    let
        fadedColor = Manipulate.fadeOut 0.3 color_

        maybeHoverStyle =
            case effects of
                WithHoverEffect ->
                    [ hover
                        [ color (hex <| colorToHexWithAlpha fadedColor) ]
                    , transition
                        [ Css.Transitions.color 350
                        ]
                    ]

                NoHoverEffect ->
                    []
    in
    maybeHoverStyle ++ 
        [ color (hex <| colorToHexWithAlpha color_)
        , visited
            [ color (hex <| colorToHexWithAlpha color_)
            ]
        ]


styles : Theme -> List Snippet
styles theme =
    [ CG.class textClass
        [ fontFamilies fontList
        , lineHeight (px 18)
        , fontSize (px 14)
        , fontWeight normal
        , textDecoration none
        , textSelectionStyles
        ]

    , CG.selector ("." ++ textClass ++ "[bold=true]")
        [ fontWeight (int 600)
        ]

    , CG.class textPrimaryClass
        [ color (hex <| colorToHexWithAlpha theme.typography.primaryTextColor)
        ]

    , CG.class textSecondaryClass
        [ color (hex <| colorToHexWithAlpha theme.typography.secondaryTextColor)
        ]

    , CG.class textLinkClass
        (createColorStyles theme.colors.primary WithHoverEffect)

    , CG.class textWarningClass
        (createColorStyles theme.colors.warning NoHoverEffect)

    , CG.class textDangerClass
        (createColorStyles theme.colors.danger NoHoverEffect)

    , CG.selector ("." ++ textClass ++ "[highlighted=true]")
        [ color (hex "#000")
        , backgroundColor (hex "#ffe58f")
        , maxWidth fitContent
        , property "max-width" "-moz-fit-content"
        ]

    , CG.selector ("span." ++ textClass)
        [ cursor text_
        ]
    , CG.selector ("a." ++ textClass)
        [ cursor pointer
        ]
    , CG.selector ("." ++ textClass ++ "[disabled=true]")
        [ property "user-select" "none"
        , cursor notAllowed
        , color (hex <| colorToHexWithAlpha <| Manipulate.fadeOut 0.2 theme.typography.secondaryTextColor)
        ]

    , CG.selector ("." ++ textClass ++ "[underlined=true]")
        [ textDecoration underline
        ]

    , CG.selector ("." ++ textClass ++ "[lineThrough=true]")
        [ textDecoration lineThrough
        ]

    , CG.class textKeyboardClass
        [ fontFamilies codeFontList
        , backgroundColor (rgba 150 150 150 0.06)
        , padding3 (px 2.38) (px 4.76) (px 1.19)
        , marginLeft (px 2.3)
        , marginRight (px 2.3)
        , border3 (px 1) solid (rgba 0 0 0 0.1)
        , borderBottom3 (px 2) solid (rgba 0 0 0 0.1)
        , borderRadius (px 3)
        , fontSize (px 12.6)
        , lineHeight (px 18.7008)
        ]

    , CG.class textCodeClass
        [ fontFamilies codeFontList
        , backgroundColor (rgba 150 150 150 0.1)
        , padding3 (px 2.38) (px 4.76) (px 1.19)
        , marginLeft (px 2.3)
        , marginRight (px 2.3)
        , border3 (px 1) solid (rgba 0 0 0 0.1)
        , borderRadius (px 3)
        , fontSize (px 11.9)
        , lineHeight (px 18.7008)
        ]
    ]

