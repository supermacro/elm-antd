module Routes.CheckboxComponent.BasicExample exposing (Model, Msg, example, init, update)

import Ant.Checkbox as Checkbox exposing (checkbox, toHtml, withLabel, withOnCheck)
import Html exposing (Html)


type alias Model =
    { checked : Bool
    }


type Msg
    = CheckboxToggled


init : Model
init =
    { checked = False
    }


update : Msg -> Model -> ( Model, Cmd msg )
update _ { checked } =
    ( { checked = not checked }
    , Cmd.none
    )


example : Model -> Html Msg
example model =
    checkbox model.checked
        |> withOnCheck CheckboxToggled
        |> withLabel "Checkbox"
        |> toHtml
