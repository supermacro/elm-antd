module Ant.Tooltip exposing (tooltip)


import Ant.Typography exposing (fontList)
import Css exposing (..)
-- import Css.Transitions exposing (transition, easeOut)
import Html exposing (Html)
import Html.Styled exposing (span, fromUnstyled, toUnstyled)
import Html.Styled.Attributes exposing (css)

{--
https://www.bitdegree.org/learn/css-tooltip
https://codepen.io/pure-css/pen/bddggP
https://kazzkiq.github.io/balloon.css/
--}

-- you have to escape the text to ensure that the `val` value
-- is wrapped in quotes
content : String -> Css.Style
content val =
    property "content" ("\"" ++ val ++ "\"")


tooltip : String -> Html msg -> Html msg
tooltip tooltipText childNode =
    let
        boxAndArrowColor = rgba 0 0 0 0.8

        arrowHeight = px 3

        tooltipBoxStyles =
            before
                [ display none
                , pointerEvents none
                -- , transition: all 0.18s ease-out 0.18s;
                , textIndent zero
                , fontFamilies fontList
                , fontSize (px 14)
                , backgroundColor boxAndArrowColor
                , color (hex "#fff")
                , padding (px 10)
                , content tooltipText
                , position absolute
                , whiteSpace noWrap
                , zIndex (int 10)
                , transform <| translate2 (pct -50) (px 0)
                , borderRadius (px 2)
                , bottom (calc (pct 120) plus arrowHeight)
                , left (pct 50)
                , transform <| translateX (pct -50)
                , hover [ display inlineBlock ]
                ]

        tooltipArrowStyles =
            after
                [ position absolute
                , zIndex (int 8)
                , display none
                , width zero
                , height zero
                , border3 arrowHeight solid transparent
                , content ""
                , bottom (pct 120)
                , left (pct 50)
                , borderTopColor boxAndArrowColor
                , borderBottomWidth (px 0)
                , transform <| translateX (pct -50)
                ]

        sharedHoverStyles =
            [ display inlineBlock, pointerEvents none ]

        hoverRules =
            hover
                [ before sharedHoverStyles, after sharedHoverStyles ]

        styledTooltip =
            span
                [ css
                    [ position relative
                    , tooltipBoxStyles
                    , tooltipArrowStyles
                    , hoverRules
                    ]
                ]
                [ fromUnstyled childNode ]
    in
    toUnstyled styledTooltip
