module Routes.AlertComponent.CloseableExample exposing
    ( Model
    , Msg
    , init
    , update
    , view
    )

import Ant.Alert as Alert
    exposing
        ( Alert
        , AlertType(..)
        , CloseableAlertStack
        , alert
        , initAlertStack
        , stackToHtml
        , toHtml
        , updateAlertStack
        , withDescription
        , withType
        )
import Ant.Space as Space exposing (space, withSize)
import Html exposing (Html, div)
import Html.Attributes exposing (style)


type alias Model =
    { closeableAlerts : CloseableAlertStack Msg
    }


type Msg
    = AlertMsg Alert.Msg


init : Model
init =
    { closeableAlerts =
        initAlertStack AlertMsg
            [ alert "Warning Text Warning Text Warning TextW arning Text Warning Text Warning TextWarning Text"
                |> withType Warning
            , alert "Normal alertNormal alertNormal alertNormal alertNormal alertNormal alert"
            , alert "Error Text"
                |> withDescription "Error Description Error Description Error Description Error Description Error Description Error Description"
                |> withType Error
            ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AlertMsg alertMsg ->
            let
                ( alertModel, alertCmd ) =
                    updateAlertStack AlertMsg alertMsg model.closeableAlerts
            in
            ( { closeableAlerts = alertModel }
            , alertCmd
            )


view : Model -> Html Msg
view model =
    div
        [ style "width" "100%"
        ]
        [ stackToHtml model.closeableAlerts ]
