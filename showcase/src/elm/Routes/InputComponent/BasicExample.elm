module Routes.InputComponent.BasicExample exposing (Model, Msg, example)

import Ant.Input exposing (input, onInput, toHtml, withPlaceholder)
import Html exposing (Html)


type alias Model =
    ()


type Msg
    = InputTyped String


example : Html Msg
example =
    input
        |> withPlaceholder "Basic Usage"
        |> onInput InputTyped
        |> toHtml
