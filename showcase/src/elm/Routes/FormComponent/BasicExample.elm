module Routes.FormComponent.BasicExample exposing (Model, Msg, example, init, update)

import Ant.Form as Form exposing (Form)
import Ant.Form.PasswordField exposing (PasswordFieldValue)
import Ant.Form.View as FV
import Ant.Typography.Text as Text exposing (text)
import Html exposing (Html)
import Html.Attributes as A


type EmailAddress
    = EmailAddress String


type Checkboxes
    = Checkboxes Bool Bool


type alias Model =
    { loginFormState : FV.Model FormValues
    }


type alias FormValues =
    { email : String
    , password : PasswordFieldValue
    , rememberMe : Bool
    , dummy : Bool
    , address : String
    }


type Msg
    = FormChanged (FV.Model FormValues)
    | LogIn EmailAddress String Checkboxes (Maybe String)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        FormChanged newFormModel ->
            ( { loginFormState = newFormModel }, Cmd.none )

        LogIn email password (Checkboxes rememberMe dummy) maybeAddress ->
            let
                loginFormState =
                    model.loginFormState

                newModel =
                    { loginFormState | state = FV.Success }
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
            Form.inputField
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
                { parser = \{ value } -> Ok value
                , value = .password
                , update = \password values -> { values | password = password }
                , error = always Nothing
                , attributes =
                    { label = "Password"
                    , placeholder = ""
                    }
                }

        rememberMeCheckbox =
            let
                forgotPasswordLink =
                    text "forgot password?"
                        |> Text.withType (Text.Link "https://example.com/reset-password" Text.Self)
                        |> Text.toHtml
                        |> List.singleton
                        |> Html.span [ A.style "margin-left" "20px" ]
            in
            Form.checkboxField
                { parser = Ok
                , value = .rememberMe
                , update = \value values -> { values | rememberMe = value }
                , error = always Nothing
                , attributes =
                    { label = "Remember me" }
                }
                |> Form.withAdjacentHtml forgotPasswordLink

        dummyCheckbox =
            Form.checkboxField
                { parser = Ok
                , value = .dummy
                , update = \value values -> { values | dummy = value }
                , error = always Nothing
                , attributes =
                    { label = "Test123" }
                }

        addressField =
            Form.inputField
                { parser = Ok
                , value = .address
                , update = \value values -> { values | address = value }
                , error = always Nothing
                , attributes =
                    { label = "Address"
                    , placeholder = "Address"
                    }
                }
    in
    Form.succeed LogIn
        |> Form.append emailField
        |> Form.append passwordField
        |> Form.append
            -- horizontally render groups of fields using the
            -- `group` function
            (Form.succeed Checkboxes
                |> Form.append rememberMeCheckbox
                |> Form.append dummyCheckbox
                |> Form.group
            )
        -- Make fields optional
        |> Form.append (Form.optional addressField)


init : Model
init =
    let
        formState =
            FV.idle
                { email = ""
                , password = { value = "", textVisible = False }
                , rememberMe = True
                , dummy = True
                , address = ""
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
