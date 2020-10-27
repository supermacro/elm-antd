module Routes.InputComponent.PasswordExample exposing (Model, Msg, example, init, update)

import Ant.Input as Input exposing (input, toHtml, withPlaceholder, withPasswordType)
import Html exposing (Html)


type alias Model =
    { inputValue : String
    , textVisibility : Bool
    }


type Msg
    = InputChanged String
    | InputTextVisibilityChanged Bool


init : Model
init =
    { inputValue = ""
    , textVisibility = False
    }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        InputChanged newValue ->
            ( { model | inputValue = newValue }
            , Cmd.none
            )

        InputTextVisibilityChanged newVisibility ->
            ( { model | textVisibility = newVisibility }
            , Cmd.none
            )


example : Model -> Html Msg
example model =
    input InputChanged
        |> withPlaceholder "input password"
        |> withPasswordType InputTextVisibilityChanged model.textVisibility
        |> toHtml model.inputValue
