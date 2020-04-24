module Ant.Space exposing (space, toHtml)


import Css exposing (displayFlex, marginRight, px, Px)
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

        spacingStyle =
            global
                [ selector ("." ++ spaceClass ++ " > *:not(:last-child)")
                    [ marginRight <| spaceSizeToPixels config.size ]
                ]

        styledChildren =
            List.map fromUnstyled children

        styledSpace =
            div
                [ class spaceClass
                , css [ displayFlex ]
                ]
                (spacingStyle :: styledChildren)
    
    in
    toUnstyled styledSpace
