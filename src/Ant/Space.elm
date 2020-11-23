module Ant.Space exposing
    ( space
    , direction, withSize, SpaceDirection(..), SpaceSize(..)
    , toHtml
    )

{-| Utilities for setting spacing between components


# Creating a Space value

@docs space

Note that by default, a Space value is set to be horizontally layed out with a "small" space between elements


# Customizing the layout between components

@docs direction, withSize, SpaceDirection, SpaceSize


# Rendering your Space component

@docs toHtml

-}

import Css exposing (Px, column, display, flexDirection, inlineFlex, marginBottom, marginRight, px, row)
import Css.Global exposing (global, selector)
import Html exposing (Html)
import Html.Styled exposing (div, fromUnstyled, toUnstyled)
import Html.Styled.Attributes exposing (class, css)


{-| Direction of the layout (think flexbox direction)
-}
type SpaceDirection
    = Horizontal
    | Vertical


{-| The size of the space between elements
-}
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
    { direction = Horizontal
    , size = Small
    }


type Space msg
    = Space SpaceConfig (List (Html msg))


{-| Create a Space value with default values

    space [ myEl, myOtherEl, mySuperCoolEl ]

-}
space : List (Html msg) -> Space msg
space =
    Space defaultSpaceConfig


{-| Set the direction of your Space value

    space myElementList
        |> direction Vertical

-}
direction : SpaceDirection -> Space msg -> Space msg
direction dir (Space config children) =
    let
        newConfig =
            { config | direction = dir }
    in
    Space newConfig children


{-| Alter the sizing between elements. By default the size is `Small`

    space elements
        |> withSize Large

-}
withSize : SpaceSize -> Space msg -> Space msg
withSize size (Space config children) =
    let
        newConfig =
            { config | size = size }
    in
    Space newConfig children


spaceSizeToPixels : SpaceSize -> Px
spaceSizeToPixels size =
    case size of
        Small ->
            px 8

        Medium ->
            px 16

        Large ->
            px 24

        Custom val ->
            px val


spaceSizeToString : SpaceSize -> String
spaceSizeToString size =
    case size of
        Small ->
            "sm"

        Medium ->
            "md"

        Large ->
            "lg"

        Custom val ->
            "custom-" ++ String.fromFloat val


{-| Convert your Space into a `Html msg`
-}
toHtml : Space msg -> Html msg
toHtml (Space config children) =
    let
        spaceClass =
            "elm-antd__space_container-" ++ spaceSizeToString config.size

        marginRule =
            case config.direction of
                Horizontal ->
                    marginRight

                Vertical ->
                    marginBottom

        spacingStyle =
            global
                [ selector ("." ++ spaceClass ++ " > *:not(:last-child)")
                    [ marginRule <| spaceSizeToPixels config.size ]
                ]

        styledChildren =
            List.map
                (\child -> div [ class "elm-antd__space-item" ] [ fromUnstyled child ])
                children

        direction_ =
            case config.direction of
                Horizontal ->
                    row

                Vertical ->
                    column

        styledSpace =
            div
                [ class spaceClass
                , css [ display inlineFlex, flexDirection direction_ ]
                ]
                (spacingStyle :: styledChildren)
    in
    toUnstyled styledSpace
