module Routes.DividerComponent.HorizontalExample exposing (example)

import Ant.Divider as Divider exposing (divider)
import Ant.Typography.Text as Text
import Html exposing (Html, div, span, text)
import Html.Styled as H exposing (fromUnstyled, text, toUnstyled)


example : Html msg
example =
    let
        basicDivider =
            Divider.divider
                |> Divider.toHtml

        dashedDivdier =
            Divider.divider
                |> Divider.withLine Divider.Dashed
                |> Divider.toHtml

        loremIpsum =
            Text.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo."
                |> Text.toHtml
    in
    div []
        [ loremIpsum
        , basicDivider
        , loremIpsum
        , dashedDivdier
        , loremIpsum
        ]
