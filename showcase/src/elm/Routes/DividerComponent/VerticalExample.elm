module Routes.DividerComponent.VerticalExample exposing (example)

import Ant.Divider as Divider
import Ant.Typography.Text as Text
import Css exposing (..)
import Html exposing (Html, div, span, text)
import Html.Styled as H exposing (fromUnstyled, text, toUnstyled)


example : Html msg
example =
    let
        dividerVertical =
            Divider.divider
                |> Divider.withType Divider.Vertical
                |> Divider.toHtml

        text =
            Text.text "Text"
                |> Text.toHtml
    in
    div []
        [ text
        , dividerVertical
        , text
        , dividerVertical
        , text
        ]
