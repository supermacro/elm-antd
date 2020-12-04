module Routes.InputComponent.TextAreaExample exposing (Model, Msg, example, init, update)

import Ant.Input exposing (input, toHtml, withTextAreaType)
import Html exposing (Html)


type alias Model =
    { textAreaValue : String
    }


type Msg
    = TextAreaValueChanged String


init : Model
init =
    { textAreaValue = ""
    }


update : Msg -> Model -> ( Model, Cmd msg )
update (TextAreaValueChanged newValue) model =
    ( { model | textAreaValue = newValue }, Cmd.none )


example : Model -> Html Msg
example model =
    input TextAreaValueChanged
        |> withTextAreaType { rows = 5 }
        |> toHtml model.textAreaValue
