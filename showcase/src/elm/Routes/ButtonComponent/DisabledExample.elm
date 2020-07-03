module Routes.ButtonComponent.DisabledExample exposing (example)

import Ant.Button exposing (ButtonType(..), button, disabled, toHtml, withType)
import Html exposing (Html)


example : Html msg
example =
    button "Primary (disabled)"
        |> withType Primary
        |> disabled True
        |> toHtml

