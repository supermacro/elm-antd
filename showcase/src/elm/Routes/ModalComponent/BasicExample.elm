module Routes.ModalComponent.BasicExample exposing (Model, Msg, init, update, view)

import Ant.Button as Btn exposing (button)
import Ant.Modal as Modal
import Ant.Typography.Text as Text
import Html exposing (Html, div)
import Html.Attributes exposing (style)


type alias Model =
    { modalOpen : Bool }


type Msg
    = OpenModal
    | ModalStateChanged Modal.ModalState
    | ModalConfirmClicked Modal.ModalState


init : Model
init =
    { modalOpen = False
    }


launchTheMissles : Cmd msg
launchTheMissles =
    Cmd.none


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        OpenModal ->
            ( { model | modalOpen = True }, Cmd.none )

        ModalStateChanged newState ->
            ( { model | modalOpen = newState }, Cmd.none )

        ModalConfirmClicked newState ->
            ( { model | modalOpen = newState }, launchTheMissles )


p : String -> Html msg
p =
    Text.text
        >> Text.toHtml
        >> List.singleton
        >> Html.p [ style "margin" "0" ]


view : Model -> Html Msg
view model =
    let
        buttonToggle =
            button "Open Modal"
                |> Btn.withType Btn.Primary
                |> Btn.onClick OpenModal
                |> Btn.toHtml

        contents =
            List.repeat 3 (p "Some contents ...")
                |> div []

        modalFooter =
            Modal.footer
                |> Modal.withOnConfirm ModalConfirmClicked

        htmlModal =
            Modal.modal contents
                |> Modal.withTitle "Basic Modal"
                |> Modal.withOnCancel ModalStateChanged
                |> Modal.withFooter modalFooter
                |> Modal.toHtml model.modalOpen
    in
    div [] [ htmlModal, buttonToggle ]
