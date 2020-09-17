module Routes.AlertComponent.BasicExample exposing (example)

import Ant.Alert exposing (alert, toHtml)
import Html exposing (Html)


example : Html msg
example =
    alert "Success Text"
        |> toHtml
