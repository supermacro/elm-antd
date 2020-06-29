module Routes.ButtonComponent.TypeExample exposing (example)

import Ant.Button as Btn exposing (ButtonType(..), button, toHtml)
import Ant.Space as Space exposing (SpaceDirection(..))
import Html exposing (Html)


horizontalSpace : List (Html msg) -> Html msg
horizontalSpace =
    Space.toHtml << Space.direction Horizontal << Space.space


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
    horizontalSpace
        [ primaryButton
        , defaultButotn
        ]
