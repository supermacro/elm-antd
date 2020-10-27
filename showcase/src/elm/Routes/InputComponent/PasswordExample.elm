module Routes.InputComponent.PasswordExample exposing (Model, Msg, example, init, update)

import Ant.Input as Input exposing (input, toHtml, withPlaceholder, withType)
import Html exposing (Html)


type alias Model =
    Input.Model


type Msg
    = InputMsg Input.Model


init : Model
init =
    Input.init


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        InputMsg newModel ->
            ( newModel
            , Cmd.none
            )


example : Model -> Html Msg
example model =
    input InputMsg
        |> withPlaceholder "input password"
        |> withType Input.Password
        |> toHtml model
