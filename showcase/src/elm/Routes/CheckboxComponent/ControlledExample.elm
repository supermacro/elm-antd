module Routes.CheckboxComponent.ControlledExample exposing (Model, Msg, example, init, update)

import Ant.Button as Btn exposing (button, onClick)
import Ant.Checkbox as Checkbox exposing (checkbox, withDisabled, withLabel, withOnCheck)
import Ant.Space as Space exposing (space)
import Html exposing (Html, br, div)
import Html.Attributes exposing (style)


type alias Model =
    { checked : Bool
    , disabled : Bool
    }


type Msg
    = CheckToggleButtonClicked
    | DisableToggleButtonClicked
    | CheckboxToggled Bool


init : Model
init =
    { checked = True
    , disabled = False
    }


update : Msg -> Model -> ( Model, Cmd msg )
update msg ({ checked, disabled } as model) =
    case msg of
        DisableToggleButtonClicked ->
            ( { model | disabled = not disabled }
            , Cmd.none
            )

        CheckboxToggled newVal ->
            ( { model | checked = newVal }
            , Cmd.none
            )

        CheckToggleButtonClicked ->
            ( { model | checked = not checked }
            , Cmd.none
            )


viewCheckbox : Model -> Html Msg
viewCheckbox model =
    let
        checkedLabelPart =
            if model.checked then
                "Checked"

            else
                "Unchecked"

        disabledLabelPart =
            if model.disabled then
                "Disabled"

            else
                "Enabled"
    in
    checkbox
        |> withOnCheck CheckboxToggled
        |> withLabel (checkedLabelPart ++ "-" ++ disabledLabelPart)
        |> withDisabled model.disabled
        |> Checkbox.toHtml model.checked


primaryButton : String -> Msg -> Html Msg
primaryButton label msg =
    button label
        |> onClick msg
        |> Btn.withType Btn.Primary
        |> Btn.toHtml


viewCheckButton : Model -> Html Msg
viewCheckButton { checked } =
    let
        buttonLabel =
            if checked then
                "Uncheck"

            else
                "Check"
    in
    primaryButton buttonLabel CheckToggleButtonClicked


viewDisableButton : Model -> Html Msg
viewDisableButton { disabled } =
    let
        buttonLabel =
            if disabled then
                "Enable"

            else
                "Disable"
    in
    primaryButton buttonLabel DisableToggleButtonClicked


example : Model -> Html Msg
example model =
    let
        spacedOutButtons =
            space [ viewCheckButton model, viewDisableButton model ]
                |> Space.toHtml
    in
    div []
        [ div [ style "margin-bottom" "20px" ]
            [ viewCheckbox model ]
        , spacedOutButtons
        ]
