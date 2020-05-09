module Ant.Tooltip exposing
    ( tooltip
    , topRight
    , toHtml
    )


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


type TooltipPosition
    = TopLeft
    | Top
    | TopRight
    | RightTop
    | Right
    | RightBottom
    | BottomRight
    | Bottom
    | BottomLeft
    | LeftBottom
    | Left
    | LeftTop


type alias Options =
    { position : TooltipPosition
    }


type Tooltip msg
    = Tooltip Options String (Html msg)


defaultTooltipOptions : Options
defaultTooltipOptions =
    { position = Top }


tooltip : String -> Html msg -> Tooltip msg
tooltip = Tooltip defaultTooltipOptions


topRight : Tooltip msg -> Tooltip msg
topRight (Tooltip opts tooltipText childNode) =
    let
        newOpts = { opts | position = TopRight }
    in
    Tooltip newOpts tooltipText childNode


arrowHeight : Px
arrowHeight = px 3

boxAndArrowColor : Color
boxAndArrowColor = rgba 0 0 0 0.8


getPositionSpecificTooltipBoxStyles : TooltipPosition -> List Style
getPositionSpecificTooltipBoxStyles position =
    case position of
        Top ->
            [ bottom (calc (pct 120) plus arrowHeight)
            , left (pct 50)
            , transform <| translateX (pct -50)
            ]
        _ ->
            []

getPositionSpecificTooltipArrowStyles : TooltipPosition -> List Style
getPositionSpecificTooltipArrowStyles position =
    case position of
        Top ->
            [ bottom (pct 120)
            , left (pct 50)
            , borderTopColor boxAndArrowColor
            , borderBottomWidth (px 0)
            , transform <| translateX (pct -50)
            ]
        _ -> []


toHtml : Tooltip msg -> Html msg
toHtml (Tooltip opts tooltipText childNode) =
    let
        baseTooltipBoxStyles =
            [ display none
            , pointerEvents none
            , property "transition" "all 0.18s ease-out 0.18s"
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
            , hover [ display inlineBlock ]
            ]

        positionSpecificStyles = getPositionSpecificTooltipBoxStyles opts.position

        tooltipBoxStyles =
            before (baseTooltipBoxStyles ++ positionSpecificStyles)

        baseTooltipArrowStyles =
            [ position absolute
            , zIndex (int 8)
            , display none
            , width zero
            , height zero
            , border3 arrowHeight solid transparent
            , content ""
            ]

        positionSpecificArrowStyles = getPositionSpecificTooltipArrowStyles opts.position

        tooltipArrowStyles =
            after (baseTooltipArrowStyles ++ positionSpecificArrowStyles)

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
