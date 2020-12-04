module Ant.Space exposing
    ( space
    , direction, withSize, SpaceDirection(..), SpaceSize(..), withFullCrossAxisSize
    , toHtml
    )

{-| Utilities for setting spacing between components


# Creating a Space value

@docs space

Note that by default, a Space value is set to be horizontally layed out with a "small" space between elements


# Customizing the layout between components

@docs direction, withSize, SpaceDirection, SpaceSize, withFullCrossAxisSize


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


type CrossAxisSize
    = Full
    | Auto


type alias SpaceConfig =
    { direction : SpaceDirection
    , size : SpaceSize
    , crossAxisSize : CrossAxisSize
    }


defaultSpaceConfig : SpaceConfig
defaultSpaceConfig =
    { direction = Horizontal
    , size = Small
    , crossAxisSize = Auto
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


{-| Whether to fill up the full space (100% width or 100% height) of the perpendicular axis. The main axis of a `Space` container is determined by the direction of the `Space` container.

If the direction is `Horizontal` then the cross axis is vertical. Thus, `withFullCrossAxisSize` will set `height: 100%`.

If the direction is `Vertical` then the cross axis is horizontal. Thus, `withFullCrossAxisSize` will set `width: 100%`.

-}
withFullCrossAxisSize : Space msg -> Space msg
withFullCrossAxisSize (Space config children) =
    let
        newConfig =
            { config
                | crossAxisSize = Full
            }
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

        ( marginRule, crossAxisSpacingStyle ) =
            case config.direction of
                Horizontal ->
                    let
                        verticalSpacing =
                            case config.crossAxisSize of
                                Full ->
                                    Css.height (Css.pct 100)

                                Auto ->
                                    Css.height Css.auto
                    in
                    ( marginRight, verticalSpacing )

                Vertical ->
                    let
                        horizontalSpacing =
                            case config.crossAxisSize of
                                Full ->
                                    Css.width (Css.pct 100)

                                Auto ->
                                    Css.width Css.auto
                    in
                    ( marginBottom, horizontalSpacing )

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
                , css [ display inlineFlex, flexDirection direction_, crossAxisSpacingStyle ]
                ]
                (spacingStyle :: styledChildren)
    in
    toUnstyled styledSpace
