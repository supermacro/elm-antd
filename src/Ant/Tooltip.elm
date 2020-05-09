module Ant.Tooltip exposing
    ( tooltip
    , toHtml
    , withPosition
    , TooltipPosition(..)
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
https://webdesign.tutsplus.com/tutorials/css-tooltip-magic--cms-28082
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


withPosition : TooltipPosition -> Tooltip msg -> Tooltip msg
withPosition position (Tooltip opts tooltipText childNode) =
    let
        newOpts = { opts | position = position }
    in
    Tooltip newOpts tooltipText childNode
    

arrowSize : Px
arrowSize = px 3

boxAndArrowColor : Color
boxAndArrowColor = rgba 0 0 0 0.8

tooltipOffsetY : Pct
tooltipOffsetY = pct 120

tooltipOffsetX : Pct
tooltipOffsetX = pct 105


-- represents ::before
getPositionSpecificTooltipBoxStyles : TooltipPosition -> List Style
getPositionSpecificTooltipBoxStyles position =
    case position of
        Top ->
            [ bottom <| calc tooltipOffsetY plus arrowSize
            , left (pct 50)
            , transform <| translateX (pct -50)
            ]
        Right ->
            [ top (pct 50) 
            , left <| calc tooltipOffsetX plus arrowSize
            , transform <| translateY (pct -50)
            ]
        Bottom ->
            [ top <| calc tooltipOffsetY plus arrowSize
            , left (pct 50)
            , transform <| translateX (pct -50)
            ]
        Left ->
            [ top (pct 50)
            , right <| calc tooltipOffsetX plus arrowSize
            , transform <| translateY (pct -50)
            ]
        _ -> []

-- represents ::after
getPositionSpecificTooltipArrowStyles : TooltipPosition -> List Style
getPositionSpecificTooltipArrowStyles position =
    case position of
        Top ->
            [ bottom tooltipOffsetY
            , left (pct 50)
            , borderTopColor boxAndArrowColor
            , borderBottomWidth (px 0)
            , transform <| translateX (pct -50)
            ]
        Right ->
            [ borderRightColor boxAndArrowColor
            , borderLeftWidth zero
            , top (pct 50)
            , left tooltipOffsetX
            , transform <| translateY (pct -50)
            ]
        Bottom ->
            [ top tooltipOffsetY
            , left (pct 50)
            , borderBottomColor boxAndArrowColor
            , borderTopWidth zero
            , transform <| translateX (pct -50)
            ]
        Left ->
            [ borderLeftColor boxAndArrowColor
            , borderRightWidth zero
            , top (pct 50)
            , right tooltipOffsetX
            , transform <| translateY (pct -50)
            ]
        _ -> []


toHtml : Tooltip msg -> Html msg
toHtml (Tooltip opts tooltipText childNode) =
    let
        baseSharedStyles =
            [ opacity zero
            , property "transition" "font-size 0.18s ease 0.18s, padding 0.18s ease 0.18s, opacity 0.13s ease 0.13s"
            ]

        baseTooltipBoxStyles = baseSharedStyles ++
            [ pointerEvents none
            , textIndent zero
            , fontFamilies fontList
            , fontSize (px 12)
            , backgroundColor boxAndArrowColor
            , color (hex "#fff")
            , padding (px 8)
            , content tooltipText
            , position absolute
            , whiteSpace noWrap
            , zIndex (int 10)
            , transform <| translate2 (pct -50) (px 0)
            , borderRadius (px 2)
            , hover
                [ fontSize (px 14)
                , padding (px 10)
                ]
            ]

        positionSpecificStyles = getPositionSpecificTooltipBoxStyles opts.position

        tooltipBoxStyles =
            before (baseTooltipBoxStyles ++ positionSpecificStyles)

        baseTooltipArrowStyles = baseSharedStyles ++
            [ position absolute
            , zIndex (int 8)
            , width zero
            , height zero
            , border3 arrowSize solid transparent
            , content ""
            ]

        positionSpecificArrowStyles = getPositionSpecificTooltipArrowStyles opts.position

        tooltipArrowStyles =
            after (baseTooltipArrowStyles ++ positionSpecificArrowStyles)

        sharedHoverStyles =
            [ opacity (num 1)
            , pointerEvents none
            ]

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
