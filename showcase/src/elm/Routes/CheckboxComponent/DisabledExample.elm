module Routes.CheckboxComponent.DisabledExample exposing (example)

import Ant.Checkbox as Checkbox exposing (Checkbox, checkbox, toHtml, withDisabled)
import Html exposing (Html, br, div)


type CheckedState
    = Checked
    | NotChecked

disabledCheckbox : CheckedState -> Html msg
disabledCheckbox checked =
    let
        isChecked =
            case checked of
                Checked -> True
                NotChecked -> False
    in
    checkbox isChecked
        |> withDisabled True
        |> toHtml


example : Html msg
example =
    div []
        [ disabledCheckbox NotChecked
        , br [] []
        , disabledCheckbox Checked
        ]

