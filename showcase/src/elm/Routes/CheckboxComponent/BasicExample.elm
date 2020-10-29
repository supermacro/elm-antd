module Routes.CheckboxComponent.BasicExample exposing (Model, Msg, example, init, update)

import Ant.Checkbox as Checkbox exposing (checkbox, toHtml, withLabel, withOnCheck)
import Html exposing (Html)


type alias Model =
    { checked : Bool
    }


type Msg
    = CheckboxToggled Bool


init : Model
init =
    { checked = False
    }


update : Msg -> Model -> ( Model, Cmd msg )
update (CheckboxToggled newVal) { checked } =
    ( { checked = newVal }
    , Cmd.none
    )


example : Model -> Html Msg
example model =
    checkbox
        |> withOnCheck CheckboxToggled
        |> withLabel "Checkbox"
        |> toHtml model.checked
