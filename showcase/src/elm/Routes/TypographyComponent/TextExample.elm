module Routes.TypographyComponent.TextExample exposing (example)

import Ant.Space as Space exposing (space)
import Ant.Typography.Text as Text exposing (TextType(..), text)
import Html exposing (Html)


example : Html msg
example =
    [ text "Ant Design (default)"
    , text "Ant Design (secondary)"
        |> Text.withType Secondary
    , text "Ant Design (warning)"
        |> Text.withType Warning
    , text "Ant Design (danger)"
        |> Text.withType Danger
    , text "Ant Design (disabled)"
        |> Text.disabled True
    , text "Ant Design (mark)"
        |> Text.highlighted True
    , text "Ant Design (code)"
        |> Text.code
    , text "Ant Design (keyboard)"
        |> Text.keyboard
    , text "Ant Design (underlined)"
        |> Text.underlined True
    , text "Ant Design (delete)"
        |> Text.lineThrough True
    , text "Ant Design (strong)"
        |> Text.strong
    , text "Ant Design (Link)"
        |> Text.withType (Link "https://elm-antd.netlify.app" Text.Self)
    ]
        |> List.map Text.toHtml
        |> space
        |> Space.direction Space.Vertical
        |> Space.toHtml
