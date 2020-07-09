module Ant.Drawer exposing
    ( Drawer
    , drawer, collapsed, withHeader, withPlacement, Placement(..), Header(..)
    , toHtml
    , onClickOutside, onClose, withFooter
    )

{-| Drawer component

@docs Drawer


# Customizing the Drawer

@docs drawer, collapsed, withHeader, withPlacement, Placement, Header

@docs toHtml

-}

import Css exposing (..)
import Html exposing (Html)
import Html.Styled as H exposing (text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events as Events


{-| Determines the placement of the drawer
-}
type Placement
    = Top
    | Right
    | Bottom
    | Left


{-| Determins the type of the Header, either a String or an entire Html node
-}
type Header msg
    = Title String
    | Node (Html msg)


type alias Options msg =
    { placement : Placement
    , collapsed : Bool
    , header : Header msg
    , onClickOutside : Maybe msg
    , onClose : Maybe msg
    , footer : Maybe (Html msg)
    }


defaultOptions : Options msg
defaultOptions =
    { placement = Right
    , collapsed = False
    , header = Title ""
    , onClickOutside = Nothing
    , onClose = Nothing
    , footer = Nothing
    }


{-| Represents a drawer component
-}
type Drawer msg
    = Drawer (Options msg) (Html msg)


{-| Create a Drawer component.

    drawer (Text.text "Some content..." |> Text.toHtml)
        |> witHeader (Title "Basic Drawer")
        |> collapsed False
        |> toHtml

-}
drawer : Html msg -> Drawer msg
drawer content =
    Drawer defaultOptions content


withPlacement : Placement -> Drawer msg -> Drawer msg
withPlacement placement (Drawer options content) =
    let
        newOptions =
            { options | placement = placement }
    in
    Drawer newOptions content


withHeader : Header msg -> Drawer msg -> Drawer msg
withHeader headerValue (Drawer options content) =
    let
        newOptions =
            { options | header = headerValue }
    in
    Drawer newOptions content


withFooter : Html msg -> Drawer msg -> Drawer msg
withFooter footer (Drawer options content) =
    let
        newOptions =
            { options | footer = Just footer }
    in
    Drawer newOptions content


onClickOutside : msg -> Drawer msg -> Drawer msg
onClickOutside msg (Drawer options content) =
    let
        newOptions =
            { options | onClickOutside = Just msg }
    in
    Drawer newOptions content


onClose : msg -> Drawer msg -> Drawer msg
onClose msg (Drawer options content) =
    let
        newOptions =
            { options | onClose = Just msg }
    in
    Drawer newOptions content


collapsed : Bool -> Drawer msg -> Drawer msg
collapsed value (Drawer options content) =
    let
        newOptions =
            { options | collapsed = value }
    in
    Drawer newOptions content


headerToHtml : Header msg -> H.Html msg
headerToHtml headerValue =
    case headerValue of
        Title title ->
            let
                headerAttributes =
                    [ padding2 (px 16) (px 24)
                    , borderStyle solid
                    , borderBottom3 (px 1) solid (hex "#f0f0f0")
                    ]
            in
            H.div
                [ css headerAttributes ]
                [ H.text title ]

        Node node ->
            H.fromUnstyled node


footerToHtml : Html msg -> H.Html msg
footerToHtml footer =
    let
        footerAttributes =
            [ padding (px 10)
            , borderStyle solid
            , borderTop3 (px 1) solid (hex "#f0f0f0")
            ]
    in
    H.div
        [ css footerAttributes ]
        [ H.fromUnstyled footer ]


contentToHtml : Html msg -> H.Html msg
contentToHtml content =
    let
        bodyAttributes =
            [ padding (px 24)
            , overflow auto
            , flexGrow (int 1)
            ]
        styledContent =
            H.div
                [ css bodyAttributes ]
                [ H.fromUnstyled content ]
    in
    styledContent


{-| Turn your Drawer into Html msg
-}
toHtml : Drawer msg -> Html msg
toHtml (Drawer options content) =
    let
        maskAttributes =
            css
                [ position fixed
                , top (px 0)
                , left (px 0)
                , bottom (px 0)
                , right (px 0)
                , height (pct 100)
                , width (pct 100)
                , backgroundColor (Css.rgba 0 0 0 0.45)
                , zIndex (int 1)
                ]

        placementAttributes =
            case options.placement of
                Left ->
                    [ top (px 0), left (px 0), width (pct 30), height (pct 100) ]

                Right ->
                    [ top (px 0), right (px 0), width (pct 30), height (pct 100) ]

                Top ->
                    [ top (px 0), left (px 0), width (pct 100), height (pct 30) ]

                Bottom ->
                    [ bottom (px 0), width (pct 100), height (pct 30) ]

        baseAttributes =
            [ height (pct 100)
            , width (pct 25)
            , position absolute
            , backgroundColor (hex "#fff")
            , displayFlex
            , flexDirection column
            ]

        maybeOnClose =
            options.onClose
                |> Maybe.map Events.onClick
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        maybeOnClickOutside =
            options.onClickOutside
                |> Maybe.map Events.onClick
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        attributes =
            [ css <| baseAttributes ++ placementAttributes ]

        drawerBody =
            case options.footer of
                Just footerNode ->
                    [ headerToHtml options.header
                    , contentToHtml content
                    , footerToHtml footerNode
                    ]

                Nothing ->
                    [ headerToHtml options.header
                    , contentToHtml content
                    ]
    in
    toUnstyled
        (if options.collapsed then
            H.div [] []

         else
            H.div
                (maskAttributes :: maybeOnClickOutside)
                [ H.div
                    attributes
                    drawerBody
                ]
        )
