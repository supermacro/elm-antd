module Routes.TooltipComponent.BasicExample exposing (example)

import Ant.Tooltip exposing (tooltip)
import Ant.Typography.Text as Text
import Html exposing (Html, text)

example : Html msg
example =
    Text.text "Tooltip will show on mouse enter."
    |> Text.toHtml
    |> tooltip "prompt text"
