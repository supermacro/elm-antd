module Routes.ButtonComponent.TypeExample exposing (example)

import Ant.Button as Btn exposing (button, toHtml, ButtonType(..))
import Ant.Space as Space
import Html exposing (Html)

example : Html msg
example =
    let
        primaryButton =
            button "Primary"
            |> Btn.withType Primary
            |> toHtml

        defaultButotn =
            button "Default"
            |> Btn.withType Default
            |> toHtml
    
    in
    Space.toHtml <|
        Space.space
            [ primaryButton
            , defaultButotn
            ]
