module Routes.TypographyComponent.TextExample exposing (example)

import Ant.Typography.Text as Text exposing (text, TextType(..))
import Ant.Space as Space exposing (space)
import Html exposing (Html)


verticalAlign : List (Html msg) -> Html msg
verticalAlign =
    Space.toHtml << space


example : Html msg
example =
    verticalAlign <| List.map Text.toHtml
        [ text "Ant Design"
        , text "Ant Design"
            |> Text.textType Secondary
        , text "Ant Design"
            |> Text.textType Warning
        , text "Ant Design"
            |> Text.textType Danger
        , text "Ant Design"
            |> Text.disabled True
        , text "Ant Design"
            |> Text.highlighted True
        , text "Ant Design"
            |> Text.code
        , text "Ant Design"
            |> Text.keyboard
        , text "Ant Design"
            |> Text.underlined True
        , text "Ant Design"
            |> Text.lineThrough True
        , text "Ant Design"
            |> Text.strong
        ]
