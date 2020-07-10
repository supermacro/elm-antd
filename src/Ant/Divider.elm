module Ant.Divider exposing
    ( Divider
    , divider, Line(..), withLine, Orientation(..), withOrientation, Type(..), TextStyle(..), withTextStyle, withLabel
    , toHtml
    , withType
    )

{-| Divider component

@docs Divider


# Customizing the Divider

@docs divider, Line, withLine, Orientation, withOrientation, Type, TextStyle, withTextStyle, withLabel

@docs toHtml

-}

import Ant.Typography as Typography
import Ant.Typography.Text as Text
import Css exposing (..)
import Css.Global exposing (children, typeSelector)
import Html exposing (Html)
import Html.Styled as H exposing (text, toUnstyled)
import Html.Styled.Attributes exposing (css)


type Line
    = Dashed
    | Solid


type Orientation
    = Left
    | Right
    | Center


type Type
    = Horizontal
    | Vertical


type TextStyle
    = Plain
    | Heading


type alias Options =
    { line : Line
    , orientation : Orientation
    , type_ : Type
    , textStyle : TextStyle
    , label : Maybe String
    }


defaultOptions : Options
defaultOptions =
    { line = Solid
    , orientation = Center
    , type_ = Horizontal
    , textStyle = Plain
    , label = Nothing
    }


type Divider
    = Divider Options


{-| Create a Divider component.

    Divider.divider
        |> Divider.toHtml

-}
divider : Divider
divider =
    Divider defaultOptions


withLabel : String -> Divider -> Divider
withLabel label (Divider options) =
    let
        newOptions =
            { options | label = Just label }
    in
    Divider newOptions


withTextStyle : TextStyle -> Divider -> Divider
withTextStyle textStyle (Divider options) =
    let
        newOptions =
            { options | textStyle = textStyle }
    in
    Divider newOptions


withLine : Line -> Divider -> Divider
withLine line (Divider options) =
    let
        newOptions =
            { options | line = line }
    in
    Divider newOptions


withType : Type -> Divider -> Divider
withType type_ (Divider options) =
    let
        newOptions =
            { options | type_ = type_ }
    in
    Divider newOptions


withOrientation : Orientation -> Divider -> Divider
withOrientation orientation (Divider options) =
    let
        newOptions =
            { options | orientation = orientation }
    in
    Divider newOptions


labelToHtml : String -> TextStyle -> H.Html msg
labelToHtml label textStyle =
    let
        content =
            case textStyle of
                Plain ->
                    Text.text label
                        |> Text.toHtml

                Heading ->
                    Typography.title label
                        |> Typography.level Typography.H5
                        |> Typography.toHtml
    in
    H.fromUnstyled content


toHtml : Divider -> Html msg
toHtml (Divider options) =
    let
        typeAttributes =
            case options.type_ of
                Horizontal ->
                    [ width (pct 100)
                    , minWidth (pct 100)
                    , margin2 (px 24) (px 0)
                    , displayFlex
                    , alignItems center
                    , textAlign center
                    ]

                Vertical ->
                    [ height (pct 100), minHeight (pct 100) ]

        baseAttributes =
            typeAttributes

        lineAttribute =
            case options.line of
                Solid ->
                    solid

                Dashed ->
                    dashed

        pseudoAttributes =
            [ property "content" "''"
            , borderTop3 (px 1) lineAttribute (hex "#f0f0f0")
            ]

        beforeWidth =
            case options.orientation of
                Left ->
                    width (pct 5)

                Center ->
                    width (pct 50)

                Right ->
                    width (pct 95)

        afterWidth =
            case options.orientation of
                Left ->
                    width (pct 95)

                Center ->
                    width (pct 50)

                Right ->
                    width (pct 5)

        textAttributes =
            [ css
                [ padding2 (px 0) (px 8)
                , children
                    [ typeSelector "h5"
                        [ margin (px 0)
                        ]
                    ]
                ]
            ]

        attributes =
            [ css <| baseAttributes ++ [ before (pseudoAttributes ++ [ beforeWidth ]), after (pseudoAttributes ++ [ afterWidth ]) ] ]
    in
    toUnstyled
        (case options.label of
            Just l ->
                H.div
                    attributes
                    [ H.span textAttributes
                        [ labelToHtml l options.textStyle ]
                    ]

            Nothing ->
                H.div attributes []
        )
