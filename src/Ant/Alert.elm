module Ant.Alert exposing
    ( Alert, AlertType(..)
    , alert
    , toHtml
    , withType
    , Msg, CloseableAlertStack
    , initAlertStack, updateAlertStack, stackToHtml, withDescription
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
import Css exposing (..)
import Css.Global exposing (global, selector)
import Css.Transitions exposing (transition)
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


type AlertState
    = Visible
    | Closing


type alias AlertConfig msg =
    { type_ : AlertType
    , state : AlertState
    , onClose : Maybe msg
    , description : Maybe String
    }


defaultAlertConfig : AlertConfig msg
defaultAlertConfig =
    { type_ = Success
    , state = Visible
    , onClose = Nothing
    , description = Nothing
    }


close_transition_duration_ms : Float
close_transition_duration_ms =
    1000


withClosingState : Alert msg -> Alert msg
withClosingState (Alert config alertText) =
    let
        newConfig =
            { config | state = Closing }
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


{-| Show a closing icon on the `Alert`. Note that you must wire up the Alert with your Model.
-}
withOnClose : (Msg -> msg) -> AlertId -> Alert msg -> Alert msg
withOnClose tagger alertId (Alert config alertText) =
    let
        msg =
            tagger <| CloseIconClicked alertId

        newConfig =
            { config | onClose = Just msg }
    in
    Alert newConfig alertText


{-| creates unique ids between push rounds and permutations of the stack
-}
createAlertId : PushRound -> Int -> String
createAlertId pushRound idx =
    String.fromInt pushRound ++ "-" ++ String.fromInt idx


{-| Takes a set of stateless alerts that don't ever emit messages and turns them into Alerts that a user can interact with (i.e. close them).

See the example above to see the usage of `initAlertStack`.

This alert stack must be saved in your model in order for it's state to be tracked and altered.

Every time a user clicks on the close icon, the alert will emit a `msg`.

-}
initAlertStack : (Msg -> msg) -> List (Alert msg) -> CloseableAlertStack msg
initAlertStack tagger alerts =
    let
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


type alias TypeColors =
    { background : Color
    , border : Color
    }


getAlertTypeColors : AlertType -> TypeColors
getAlertTypeColors type_ =
    case type_ of
        Success ->
            { background = rgb 246 255 237
            , border = rgb 183 235 143
            }

        Info ->
            { background = rgb 230 247 255
            , border = rgb 145 213 255
            }

        Warning ->
            { background = rgb 255 251 230
            , border = rgb 255 229 143
            }

        Error ->
            { background = rgb 255 242 240
            , border = rgb 255 204 199
            }


renderCloseIcon : msg -> AlertState -> Styled.Html msg
renderCloseIcon action state =
    let
        ( styles, events ) =
            case state of
                Visible ->
                    ( [ float right
                      , position relative
                      , left (px 20)
                      , hover
                            [ cursor pointer ]
                      ]
                    , [ onClick action ]
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
        alertClass =
            "elm-antd__alert"

        stateAttributeName =
            "is_closing"

        closingStateStyle =
            global
                [ selector ("." ++ alertClass ++ "[" ++ stateAttributeName ++ "=true]")
                    [ opacity (int 0)
                    , overflow hidden
                    , height zero
                    , padding zero
                    , border zero
                    , marginBottom zero
                    ]
                ]

        stateAttribute =
            case config.state of
                Visible ->
                    attribute stateAttributeName "false"

                Closing ->
                    attribute stateAttributeName "true"

        alertColors =
            getAlertTypeColors config.type_

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

        ( paddingRightStyle, closeIconHtml ) =
            case config.onClose of
                Nothing ->
                    ( paddingRight (px 15)
                    , span [] []
                    )

                Just msg ->
                    ( paddingRight (px 30)
                    , renderCloseIcon msg config.state
                    )

        baseStyles =
            [ fontSize (px 14)
            , backgroundColor alertColors.background
            , lineHeight (px 22)
            , border3 (px 1) solid alertColors.border
            , borderRadius (px 2)
            , paddingTop (px 8)
            , paddingBottom (px 8)
            , paddingLeft (px 15)
            , paddingRightStyle
            , width (pct 100)
            , transition
                [ Css.Transitions.opacity close_transition_duration_ms
                , Css.Transitions.height close_transition_duration_ms
                , Css.Transitions.padding close_transition_duration_ms
                , Css.Transitions.border close_transition_duration_ms
                , Css.Transitions.margin close_transition_duration_ms
                ]
            ]
                ++ commonFontStyles

        styledAlert =
            div
                [ css baseStyles
                , class alertClass
                , stateAttribute
                ]
                [ closingStateStyle
                , closeIconHtml
                , alertMessage
                , alertDescription
                ]
    in
    toUnstyled styledAlert
