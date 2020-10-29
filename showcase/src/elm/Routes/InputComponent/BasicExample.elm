module Routes.InputComponent.BasicExample exposing (Model, Msg, example, init, update)

import Ant.Input as Input exposing (input, toHtml, withPlaceholder)
import Html exposing (Html)


type alias Model =
    { inputValue : String }


type Msg
    = InputChanged String


init : Model
init =
    { inputValue = ""
    }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        InputChanged inputValue ->
            ( { model | inputValue = inputValue }
            , Cmd.none
            )


example : Model -> Html Msg
example model =
    input InputChanged
        |> withPlaceholder "Basic Usage"
        |> toHtml model.inputValue
