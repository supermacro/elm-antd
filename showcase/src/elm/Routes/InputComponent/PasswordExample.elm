module Routes.InputComponent.PasswordExample exposing (Model, Msg, example, init, update)

import Ant.Input as Input exposing (input, onInput, toHtml, withPasswordType, withPlaceholder)
import Html exposing (Html)


type alias Model =
    Input.Model


type Msg
    = InputTyped String
    | InputMsg Input.Msg


init : Model
init =
    Input.PasswordInputState { textVisible = False }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        InputTyped _ ->
            ( model
            , Cmd.none
            )

        InputMsg inputMsg ->
            ( Input.updatePasswordInput inputMsg model
            , Cmd.none
            )


example : Model -> Html Msg
example model =
    input
        |> withPlaceholder "input password"
        |> onInput InputTyped
        |> withPasswordType InputMsg
        |> toHtml model
