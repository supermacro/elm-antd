module Routes.InputComponent.BasicExample exposing (example)

import Ant.Input exposing (input, onInput, toHtml, withPlaceholder)
import Html exposing (Html)


type Msg
    = InputTyped String


example : Html Msg
example =
    input
        |> withPlaceholder "Basic Usage"
        |> onInput InputTyped
        |> toHtml
