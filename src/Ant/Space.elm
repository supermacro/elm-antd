module Ant.Space exposing
    ( space
    , direction
    , SpaceDirection(..)
    , toHtml
    )


import Css exposing (displayFlex, marginRight, marginBottom, px, Px, flexDirection, column, row)
import Css.Global exposing (global, selector)
import Html exposing (Html)
import Html.Styled exposing (div, toUnstyled, fromUnstyled)
import Html.Styled.Attributes exposing (css, class)

type SpaceDirection
    = Horizontal
    | Vertical


type SpaceSize
    = Small
    | Medium
    | Large
    | Custom Float


type alias SpaceConfig =
    { direction : SpaceDirection
    , size : SpaceSize
    }


defaultSpaceConfig : SpaceConfig
defaultSpaceConfig =
    { direction = Vertical
    , size = Small
    }


type Space msg
    = Space SpaceConfig (List (Html msg))


space : List (Html msg) -> Space msg
space =
    Space defaultSpaceConfig


direction : SpaceDirection -> Space msg -> Space msg
direction dir (Space config children) =
    let
        newConfig =
            { config | direction = dir }
    in
    Space newConfig children


spaceSizeToPixels : SpaceSize -> Px
spaceSizeToPixels size =
    case size of
        Small -> px 8
        Medium -> px 16
        Large -> px 24
        Custom val -> px val


toHtml : Space msg -> Html msg
toHtml (Space config children) =
    let
        spaceClass = "elm-antd__space_container"

        marginRule = case config.direction of
            Horizontal -> marginRight
            Vertical -> marginBottom 

        spacingStyle =
            global
                [ selector ("." ++ spaceClass ++ " > *:not(:last-child)")
                    [ marginRule <| spaceSizeToPixels config.size ]
                ]

        styledChildren =
            List.map fromUnstyled children

        direction_ = case config.direction of
            Horizontal -> row
            Vertical -> column

        styledSpace =
            div
                [ class spaceClass
                , css [ displayFlex, flexDirection direction_ ]
                ]
                (spacingStyle :: styledChildren)
    
    in
    toUnstyled styledSpace
