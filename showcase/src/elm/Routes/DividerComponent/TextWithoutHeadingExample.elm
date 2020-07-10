module Routes.DividerComponent.TextWithoutHeadingExample exposing (example)

import Ant.Divider as Divider
import Ant.Typography.Text as Text
import Html exposing (Html, div, span, text)
import Html.Styled as H exposing (fromUnstyled, text, toUnstyled)


example : Html msg
example =
    let
        dividerCenter =
            Divider.divider
                |> Divider.withLabel "Center"
                |> Divider.withOrientation Divider.Center
                |> Divider.toHtml

        dividerLeft =
            Divider.divider
                |> Divider.withLabel "Left"
                |> Divider.withOrientation Divider.Left
                |> Divider.toHtml

        dividerRight =
            Divider.divider
                |> Divider.withLabel "Right"
                |> Divider.withOrientation Divider.Right
                |> Divider.toHtml

        loremIpsum =
            Text.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo."
                |> Text.toHtml
    in
    div []
        [ loremIpsum
        , dividerCenter
        , loremIpsum
        , dividerLeft
        , loremIpsum
        , dividerRight
        , loremIpsum
        ]
