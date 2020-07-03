module Routes.ButtonComponent.DisabledExample exposing (example)

import Ant.Button exposing (ButtonType(..), button, disabled, onClick, toHtml, withType)
import Html exposing (Html)


type Msg
    = Clicked


example : Html Msg
example =
    button "Primary (disabled)"
        |> withType Primary
        |> onClick Clicked
        -- It won't emit a Clicked event now
        |> disabled True
        |> toHtml
