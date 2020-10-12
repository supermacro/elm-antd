module Ant.Alert exposing
    ( Alert, AlertType(..)
    , alert
    , withType
    , withDescription
    , toHtml
    , Msg, CloseableAlertStack
    , initAlertStack, updateAlertStack, stackToHtml
    )

{-| Alert component

**This component has a stateless and a stateful API**

<https://ant.design/components/alert/>

Alerts inform your users of relevant information.

@docs Alert, AlertType


## Stateless API

The following functions allow you to simply plop in an alert that never emits `Msg`s. If you want to control their visibility, you would have to do so on your own.

@docs alert
@docs withType
@docs withDescription
@docs toHtml


## Stateful API

If you want to render interactive alerts, you will have to create a "stack" of stateful alerts, which can contain between 0 and `n` `Alert`s. Every alert inside this stack is interactive - the user can close them at will. In other words, the alerts in this stack produce `Msg` values that you must handle.

There are 3 things you must do in order to properly manage your stateful stack of alerts:

1.  initialize the stack with `initAlertStack` and save this stack in your model.
2.  Create a `Msg` value that contains a `Alert.Msg`
3.  Handle `Alert.Msg` values with updateAlertStack

A alert stack is nothing more than just a `List (Alert msg)` (with some internal mutations done to them), so to show them in your view, all you need to do is call `List.map toHtml statefulAlerts`

Example:

    type Msg
        = AlertMsg Alert.Msg

    model : Model
    model =
        { statefulAlertStack =
            initAlertStack AlertMsg
                [ alert "Hey there, you can close me :)"
                ]
        }

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            AlertMsg alertMsg ->
                let
                    ( alertModel, alertCmd ) =
                        updateAlertStack AlertMsg alertMsg model.statefulAlertStack
                in
                ( { closeableAlerts = alertModel }
                , alertCmd
                )

    view : Model -> Html msg
    view { statefulAlertStack } =
        div [] <|
            stackToHtml statefulAlertStack

@docs Msg, CloseableAlertStack

@docs initAlertStack, updateAlertStack, stackToHtml

-}

import Ant.Icons as Icons exposing (closeOutlined)
import Ant.Internals.Typography exposing (commonFontStyles)
import Ant.Css.Common exposing (alertClass, alertInfoClass, alertSuccessClass, alertWarningClass, alertErrorClass, alertStateAttributeName)
import Css exposing (..)
import Css.Global exposing (global, selector)
import Html exposing (Html)
import Html.Keyed
import Html.Styled as Styled exposing (div, fromUnstyled, span, text, toUnstyled)
import Html.Styled.Attributes exposing (attribute, class, css)
import Html.Styled.Events exposing (onClick)
import Process
import Task


{-| An `Alert` is what is returned when you create an alert component

You can customize alerts.

To turn an `Alert` into `Html msg` call `toHtml`

-}
type Alert msg
    = Alert (AlertConfig msg) String


{-| Represents the index in the alert stack list
-}
type alias AlertId =
    String


{-| Tracks the number of times we've pushed to the stack
-}
type alias PushRound =
    Int


{-| Represents the state of closeable alerts
-}
type CloseableAlertStack msg
    = CloseableAlertStack PushRound (List ( Alert msg, AlertId ))


{-| Messages emitted by closeable alerts
-}
type Msg
    = CloseIconClicked AlertId
    | CloseAnimationFinished AlertId


{-| The kind of alert. Determines the colors used for background and border.
-}
type AlertType
    = Success
    | Info
    | Warning
    | Error


type CloseableAlertState
    = Visible
    | Closing


type alias CloseableInfo msg =
    { state : CloseableAlertState
    , onClose : msg
    }

type alias AlertConfig msg =
    { type_ : AlertType
    , closeableInfo : Maybe ( CloseableInfo msg )
    , description : Maybe String
    }


defaultAlertConfig : AlertConfig msg
defaultAlertConfig =
    { type_ = Success
    , closeableInfo = Nothing
    , description = Nothing
    }


close_transition_duration_ms : Float
close_transition_duration_ms =
    1000


{- THIS FUNCTION SHOULD NEVER BE EXPOSED.

It is used internally to set a stateful alert to the Closing state.
-}
withClosingState : Alert msg -> Alert msg
withClosingState (Alert config alertText) =
    let
        newCloseableInfo = 
            Maybe.map
                (\closeableInfo -> { closeableInfo | state = Closing })
                config.closeableInfo

        newConfig =
            { config | closeableInfo = newCloseableInfo }
    in
    Alert newConfig alertText


{-| Update a stack of closeable alerts. This function should be hooked up to your `update` function.
-}
updateAlertStack : (Msg -> msg) -> Msg -> CloseableAlertStack msg -> ( CloseableAlertStack msg, Cmd msg )
updateAlertStack tagger msg (CloseableAlertStack pushRound stack) =
    case msg of
        CloseIconClicked targetAlertId ->
            let
                newStack =
                    List.map
                        (\( alert_, alertId ) ->
                            if alertId == targetAlertId then
                                ( withClosingState alert_, alertId )

                            else
                                ( alert_, alertId )
                        )
                        stack

                alertClosedTask =
                    Process.sleep close_transition_duration_ms
                        |> Task.perform (always (CloseAnimationFinished targetAlertId))
            in
            ( CloseableAlertStack pushRound newStack
            , Cmd.map tagger alertClosedTask
            )

        CloseAnimationFinished targetAlertId ->
            let
                newStack =
                    stack
                        |> List.filter (\( _, id ) -> id /= targetAlertId)
            in
            ( CloseableAlertStack pushRound newStack, Cmd.none )


{-| Create an alert.

alert "Hello, world!"

-}
alert : String -> Alert msg
alert =
    Alert defaultAlertConfig


{-| Change the type of the alert. By default, alerts are Success types.

    alert "Error! Something went wrong!"
        |> withType Error
        |> toHtml

-}
withType : AlertType -> Alert msg -> Alert msg
withType type_ (Alert config alertText) =
    let
        newConfig =
            { config | type_ = type_ }
    in
    Alert newConfig alertText


{-| Provide a descriptive label / header to your alert, which will be rendered in bigger / emphasized text.

    alert "Very long alert that may require a more succinct label / summary"
        |> withDescription "Invalid Password"
        |> toHtml

-}
withDescription : String -> Alert msg -> Alert msg
withDescription alertDescription (Alert config alertText) =
    let
        newConfig =
            { config | description = Just alertDescription }
    in
    Alert newConfig alertText


{- THIS FUNCTION SHOULD NEVER BE EXPOSED.

Show a closing icon on the `Alert`. Note that you must wire up the Alert with your Model.
-}
withOnClose : (Msg -> msg) -> AlertId -> Alert msg -> Alert msg
withOnClose tagger alertId (Alert config alertText) =
    let
        msg =
            tagger <| CloseIconClicked alertId
        
        closeableInfo =
            { state = Visible
            , onClose = msg
            }

        newConfig =
            { config | closeableInfo = Just closeableInfo
            }
    in
    Alert newConfig alertText


{-| creates unique ids between push rounds and permutations of the stack
-}
createAlertId : PushRound -> Int -> String
createAlertId pushRound idx =
    String.fromInt pushRound ++ "-" ++ String.fromInt idx


{-| THIS API IS UNSTABLE AND ALSO VISUALLY UNAPPEALING. DO NOT USE STATEFUL ALERTS YET.

Takes a set of stateless alerts that don't ever emit messages and turns them into Alerts that a user can interact with (i.e. close them).

See the example above to see the usage of `initAlertStack`.

This alert stack must be saved in your model in order for it's state to be tracked and altered.

Every time a user clicks on the close icon, the alert will emit a `msg`.

-}
initAlertStack : (Msg -> msg) -> List (Alert msg) -> CloseableAlertStack msg
initAlertStack tagger alerts =
    let
        -- push rounds are used to generate unique identifiers for each stateful alert
        pushRound =
            0

        intoKeyedAlert idx alert_ =
            let
                alertId =
                    createAlertId pushRound idx
            in
            ( withOnClose tagger alertId alert_, alertId )
    in
    CloseableAlertStack pushRound <|
        List.indexedMap intoKeyedAlert alerts



------------------------
-- View Code


renderCloseIcon : CloseableInfo msg -> Styled.Html msg
renderCloseIcon { state, onClose } =
    let
        msg = onClose

        ( styles, events ) =
            case state of
                Visible ->
                    ( [ float right
                      , position relative
                      , left (px 20)
                      , hover
                            [ cursor pointer ]
                      ]
                    , [ onClick msg ]
                    )

                Closing ->
                    ( [ opacity inherit ]
                    , []
                    )

        styledIconHtml =
            closeOutlined
                |> Icons.withStyles [ ( "color", "rgba(0, 0, 0, 0.45)" ) ]
                |> Icons.toHtml
                |> fromUnstyled
    in
    span (css styles :: events) [ styledIconHtml ]


{-| Render a stack of closeable alerts into your `view`.
-}
stackToHtml : CloseableAlertStack msg -> Html msg
stackToHtml (CloseableAlertStack _ stack) =
    Html.Keyed.ul [] <|
        List.map (\( alert_, alertId ) -> ( alertId, toHtml alert_ )) stack


{-| Convert an `Alert` into a `Html msg`

    alert "Hellow, world!"
        |> toHtml

-}
toHtml : Alert msg -> Html msg
toHtml (Alert config alertText) =
    let
        stateAttribute =
            case config.closeableInfo of
                Just { state } ->
                    case state of
                        Visible ->
                            attribute alertStateAttributeName "false"

                        Closing ->
                            attribute alertStateAttributeName "true"
                
                Nothing ->
                    attribute "noop" "noop"




        ( alertMessage, alertDescription ) =
            case config.description of
                Nothing ->
                    ( text alertText, text "" )

                Just description ->
                    ( div
                        [ css
                            [ fontSize (px 16)
                            , marginBottom (px 5)
                            ]
                        ]
                        [ text alertText ]
                    , text description
                    )

        closeIconHtml =
            case config.closeableInfo of
                Nothing ->
                    span [] []

                Just closeableInfo ->
                    renderCloseIcon closeableInfo

        alertTypeClassName =
            case config.type_ of
                Success ->
                    alertSuccessClass

                Info ->
                    alertInfoClass

                Warning ->
                    alertWarningClass

                Error ->
                    alertErrorClass


        styledAlert =
            div
                [ class alertClass
                , class alertTypeClassName
                , stateAttribute
                ]
                [ closeIconHtml
                , alertMessage
                , alertDescription
                ]
    in
    toUnstyled styledAlert

