module Routes.TypographyComponent.TextExample exposing (example)

import Ant.Space as Space exposing (space)
import Ant.Typography.Text as Text exposing (TextType(..), text)
import Html exposing (Html)


example : Html msg
example =
    List.map Text.toHtml
        [ text "Ant Design"
        , text "Ant Design"
            |> Text.withType Secondary
        , text "Ant Design"
            |> Text.withType Warning
        , text "Ant Design"
            |> Text.withType Danger
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
        , text "Ant Design (Link)"
            |> Text.withType (Link "https://elm-antd.netlify.app" Text.Blank)
        ]
        |> space
        |> Space.direction Space.Vertical
        |> Space.toHtml
