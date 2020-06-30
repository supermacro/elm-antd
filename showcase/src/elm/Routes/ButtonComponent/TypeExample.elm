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
            button "Primary Button"
                |> Btn.withType Primary
                |> toHtml

        defaultButton =
            button "Default Button"
                |> Btn.withType Default
                |> toHtml

        dashedButton =
            button "Dashed Button"
                |> Btn.withType Dashed
                |> toHtml
    in
    horizontalSpace
        [ primaryButton
        , defaultButton
        , dashedButton
        ]
