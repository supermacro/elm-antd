module Routes.FormComponent.BasicExample exposing (Model, Msg, example, init, update)

import Ant.Form as Form exposing (Form)
import Ant.Form.View as FV
import Html exposing (Html)


type EmailAddress
    = EmailAddress String


type alias Model =
    { loginFormState : FV.Model FormValues
    }


type alias FormValues =
    { email : String
    , password : String
    , rememberMe : Bool
    }


type Msg
    = FormChanged (FV.Model FormValues)
    | LogIn EmailAddress String Bool


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        FormChanged newFormModel ->
            ( { loginFormState = newFormModel }, Cmd.none )

        LogIn email password rememberMe ->
            let
                loginFormState =
                    model.loginFormState

                newModel =
                    { loginFormState | state = FV.Success "You have been logged in successfully" }
            in
            ( { loginFormState = newModel }
            , Cmd.none
            )


parseEmailAddress : String -> Result String EmailAddress
parseEmailAddress str =
    if String.contains "@" str then
        Ok (EmailAddress str)

    else
        Err "The e-mail address must contain a '@' symbol"


form : Form FormValues Msg
form =
    let
        emailField =
            Form.textField
                { parser = parseEmailAddress
                , value = .email
                , update = \email values -> { values | email = email }
                , error = always Nothing
                , attributes =
                    { label = "Email"
                    , placeholder = ""
                    }
                }

        passwordField =
            Form.passwordField
                { parser = Ok
                , value = .password
                , update = \password values -> { values | password = password }
                , error = always Nothing
                , attributes =
                    { label = "Password"
                    , placeholder = ""
                    }
                }

        rememberMeCheckbox =
            Form.checkboxField
                { parser = Ok
                , value = .rememberMe
                , update = \value values -> { values | rememberMe = value }
                , error = always Nothing
                , attributes =
                    { label = "Remember me" }
                }
    in
    Form.succeed LogIn
        |> Form.append emailField
        |> Form.append passwordField
        |> Form.append rememberMeCheckbox


init : Model
init =
    let
        formState =
            FV.idle
                { email = ""
                , password = ""
                , rememberMe = True
                }
    in
    { loginFormState = formState
    }


example : Model -> Html Msg
example { loginFormState } =
    FV.toHtml
        { onChange = FormChanged
        , action = "Submit"
        , loading = "Logging in"
        , validation = FV.ValidateOnSubmit
        }
        form
        loginFormState
