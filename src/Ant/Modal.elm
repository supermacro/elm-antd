module Ant.Modal exposing
    ( Modal, ModalState
    , modal, withClosable, withMask, withOnCancel, withTitle
    , withFooter
    , ModalFooter, footer, withOnConfirm, withOnConfirmText
    , toHtml
    , withCancelText
    )

{-| Render a Modal dialog to the page.


# Example:

    type Msg
        = ModalStateChanged Ant.Modal.ModalState
        | ModalConfirmClicked Ant.Modal.ModalState
        | LaunchMisslesButtonClicked

    update : Msg -> Model -> ( Model, Cmd msg )
    update msg model =
        case msg of
            LaunchMisslesButtonClicked ->
                ( { model | modalOpen = True }, Cmd.none )

            ModalStateChanged newState ->
                ( { model | modalOpen = newState }, Cmd.none )

            ModalConfirmClicked newState ->
                let
                    cmd =
                        initiateLaunchSequence model
                in
                ( { model | modalOpen = newState }, cmd )

    view : Model -> Html Msg
    view model =
        let
            buttonToggle =
                button "Fire ze missles!"
                    |> Btn.withType Btn.Primary
                    |> Btn.onClick LaunchMisslesButtonClicked
                    |> Btn.toHtml

            modalFooter =
                Modal.footer
                    |> Modal.withOnConfirm ModalConfirmClicked

            htmlModal =
                Modal.modal modalContents
                    |> Modal.withTitle "Are you sure you want to launch ze missles?"
                    |> Modal.withOnCancel ModalStateChanged
                    |> Modal.withFooter modalFooter
                    |> Modal.toHtml model.modalOpen
        in
        div [] [ htmlModal, buttonToggle ]


# Definition

@docs Modal, ModalState


# Creating and configuring a Modal

@docs modal, withClosable, withMask, withOnCancel, withTitle

@docs withFooter


#### Footer Configuration

@docs ModalFooter, footer, withOnConfirm, withOnConfirmText


# Rendering the Modal

@docs toHtml

-}

import Ant.Button as Btn exposing (button)
import Ant.Icons as Icon exposing (closeOutlined)
import Ant.Internals.Typography exposing (commonFontStyles)
import Ant.Modal.Css exposing (modalContainerClass, modalContentsClass, modalFooterClass, modalHeaderClass, modalRootClass)
import Css exposing (..)
import Css.Global as CG
import Css.Transitions exposing (transition)
import Html as H exposing (Attribute, Html)
import Html.Attributes as Attr exposing (attribute, class)
import Html.Events exposing (stopPropagationOn, targetValue)
import Html.Styled as S exposing (fromUnstyled, toUnstyled)
import Html.Styled.Attributes as A exposing (css)
import Html.Styled.Events as StyledEvents
import Json.Decode as Json


{-| State of the Modal, currently this is a simple Bool alias that represents the Modal's visibility, but it may change in the future to hold other state.

This value must be saved in your Model.

-}
type alias ModalState =
    Bool


{-| Opaque type that represents a configurable Modal.
-}
type Modal msg
    = Modal (ModalOptions msg) (Html msg)


type alias ModalOptions msg =
    { title : Maybe String
    , closable : Bool
    , showMask : Bool

    -- A function that will be called when a user clicks mask,
    -- close button on top right or Cancel button
    , onCancel : Maybe (ModalState -> msg)
    , footer : Maybe (ModalFooter msg)
    }


{-| Represents a configurable Modal footer. See the [`footer`](#footer) function for creating this type.

See the [Footer Configuration](#footer-configuration) section on options for configuring a `ModalFooter`.

-}
type ModalFooter msg
    = ModalFooter (FooterConfig msg)


type alias FooterConfig msg =
    { cancelText : String
    , confirmText : String
    , onConfirm : Maybe (ModalState -> msg)
    }


defaultModalOptions : ModalOptions msg
defaultModalOptions =
    { title = Nothing
    , closable = True
    , showMask = True
    , onCancel = Nothing
    , footer = Nothing
    }



-- Footer Configuration


{-| Create a configurable [`Footer`](#Footer) to be rendered with the [`withFooter`](#withFooter) function.

By default, a footer is rendered with nothing inside of it. If you want a "canel" button, you need to call `withOnCancel` on the Modal itself. And if you want a confirm button, you need to call [`withOnConfirm`](#withOnConfirm) on the footer.

-}
footer : ModalFooter msg
footer =
    ModalFooter
        { cancelText = "Cancel"
        , confirmText = "OK"
        , onConfirm = Nothing
        }


{-| Used to render a primary call-to-action on the footer modal.

    type Msg = ModalConfirmClicked Modal.ModalState

    update : Msg -> Model -> ( Model, Cmd msg )
    update msg =
        case msg of
            ModalConfirmClicked newState ->
                ({ modal | missleLaunchModal | newState }, launchTheMissles )

    modalFooter =
        Modal.footer
            |> Modal.withOnConfirm ModalConfirmClicked

    myModal = Modal.modal
        |> Modal.withFooter modalFooter

-}
withOnConfirm : (ModalState -> msg) -> ModalFooter msg -> ModalFooter msg
withOnConfirm setVisibility (ModalFooter opts) =
    ModalFooter
        { opts
            | onConfirm = Just setVisibility
        }


{-| Set a custom prompt for the primary call-to-action on the modal footer.
-}
withOnConfirmText : String -> ModalFooter msg -> ModalFooter msg
withOnConfirmText val (ModalFooter opts) =
    ModalFooter
        { opts
            | confirmText = val
        }


{-| Set a custom prompt for the cancel button on the modal footer.

Recall that to actually render a "cancel" button, you need to call [`withOnCancel`](#withOnCancel) on the Modal itself.

-}
withCancelText : String -> ModalFooter msg -> ModalFooter msg
withCancelText val (ModalFooter opts) =
    ModalFooter
        { opts
            | cancelText = val
        }



-- Modal Configuration


{-| Create a configurable Modal that will render whatever you pass into it within the body of the Modal.
-}
modal : Html msg -> Modal msg
modal =
    Modal defaultModalOptions


{-| Specify a title to be rendered at the Header of the Modal.
-}
withTitle : String -> Modal msg -> Modal msg
withTitle title (Modal options contents) =
    Modal { options | title = Just title } contents


{-| Whether a close (`x`) button is visible on top right of the modal dialog or not.

The default is `True` already.

Note that this icon will only render if the option is toggled on **AND** the `withOnCancel` function has been called.

-}
withClosable : Bool -> Modal msg -> Modal msg
withClosable toggle (Modal opts contents) =
    Modal { opts | closable = toggle } contents


{-| Whether a [`ModalFooter`](#ModalFooter) should be added to the Modal. By default the Modal does not have a footer.

See the [Footer Configuration](#footer-configuration) section on creating and configuring footers.

-}
withFooter : ModalFooter msg -> Modal msg -> Modal msg
withFooter footer_ (Modal opts contents) =
    Modal { opts | footer = Just footer_ } contents


{-| Specify a `msg` tag that will be triggered when a user clicks out of the Modal (on the opaque mask surrounding the Modal), [close button on top right](#withClosable) or Cancel button on the [`footer`](#footer).
-}
withOnCancel : (ModalState -> msg) -> Modal msg -> Modal msg
withOnCancel setVisibility (Modal opts contents) =
    Modal { opts | onCancel = Just setVisibility } contents


{-| Whether a opaque dark grey background gets rendered behind the Modal to provide visual emphasis on to the Modal.

By default this value is set to `True`.

The "click out" behaviour is not affected by this combinator. Clicking outside of the modal still hides the Modal if you have configured [`withOnCancel`](#withOnCancel).

-}
withMask : Bool -> Modal msg -> Modal msg
withMask toggle (Modal opts contents) =
    Modal { opts | showMask = toggle } contents



-- View Code


{-| Custom Event Handler For "Clicking Out" of a modal

This ensures that the onClick event only gets fired when you click on the OUTSIDE of the modal
Based off of: <https://ellie-app.com/bWWj6YLtd5Qa1>

-}
onClick : msg -> Attribute msg
onClick tagger =
    stopPropagationOn "click" <|
        Json.map (\val -> ( tagger, val /= "modal-root" )) targetValue


closeIcon : ModalOptions msg -> Html msg
closeIcon opts =
    let
        black =
            rgba 0 0 0

        styledHtml =
            if not opts.closable then
                S.text ""

            else
                case opts.onCancel of
                    Nothing ->
                        S.text ""

                    Just updateVisibility ->
                        closeOutlined
                            |> Icon.withSize (Icon.CustomPx 19)
                            |> Icon.toHtml
                            |> fromUnstyled
                            |> List.singleton
                            |> S.div
                                [ StyledEvents.onClick (updateVisibility False)
                                , css
                                    [ position absolute
                                    , color (black 0.5)
                                    , top (px 15)
                                    , right (px 15)
                                    , width (px 30)
                                    , height (px 30)
                                    , textAlign center
                                    , hover
                                        [ color (black 0.75)
                                        , cursor pointer
                                        ]
                                    , transition
                                        [ Css.Transitions.color 300 ]
                                    ]
                                ]
    in
    toUnstyled styledHtml



-- TODO: add type anotation


makeBorder f =
    let
        ( width, style, color ) =
            ( px 1, solid, hex "#f0f0f0" )
    in
    f width style color


viewHeader : ModalOptions msg -> Html msg
viewHeader opts =
    let
        headerTitle title =
            S.div [ css commonFontStyles ]
                [ S.text title ]

        headerBorder =
            makeBorder borderBottom3

        styledHtml =
            case opts.title of
                Just title ->
                    S.div
                        [ A.class modalHeaderClass
                        , css
                            [ headerBorder
                            , fontWeight (int 500)
                            ]
                        ]
                        [ headerTitle title ]

                Nothing ->
                    S.text ""
    in
    toUnstyled styledHtml


viewFooter : ModalOptions msg -> Html msg
viewFooter opts =
    let
        viewFooter_ : ModalFooter msg -> Html msg
        viewFooter_ (ModalFooter footer_) =
            let
                cancelButton =
                    case opts.onCancel of
                        Nothing ->
                            S.text ""

                        Just updateVisibility ->
                            button footer_.cancelText
                                |> Btn.onClick (updateVisibility False)
                                |> Btn.toHtml
                                |> fromUnstyled
                                |> List.singleton
                                |> S.span [ css [ marginRight (px 8) ] ]

                okButton =
                    case footer_.onConfirm of
                        Nothing ->
                            S.text ""

                        Just onConfirm ->
                            button footer_.confirmText
                                |> Btn.onClick (onConfirm False)
                                |> Btn.withType Btn.Primary
                                |> Btn.toHtml
                                |> fromUnstyled

                footerBorder =
                    makeBorder borderTop3

                styledFooter =
                    S.div
                        [ A.class modalFooterClass
                        , css
                            [ displayFlex
                            , justifyContent flexEnd
                            , footerBorder
                            ]
                        ]
                        [ cancelButton, okButton ]
            in
            toUnstyled styledFooter
    in
    case opts.footer of
        Nothing ->
            H.text ""

        Just footer_ ->
            viewFooter_ footer_


{-| Render the Modal.
-}
toHtml : ModalState -> Modal msg -> Html msg
toHtml isVisible (Modal opts contents) =
    let
        -- prevent scrolling
        globalStyles =
            [ CG.typeSelector "body"
                [ overflowY hidden
                , overflowX hidden
                ]
            ]
                |> CG.global
                |> toUnstyled

        {- Currently assuming there's 2 kinds of layouts:

           - 2-row: Header + Content
           - 3-row: Header + Content + Footer
        -}
        layoutInfoAttr =
            let
                attr =
                    attribute "layout"
            in
            case opts.footer of
                Just _ ->
                    attr "3-row"

                Nothing ->
                    attr "2-row"

        modalHtml =
            H.div [ class modalContainerClass, layoutInfoAttr ]
                [ closeIcon opts
                , viewHeader opts
                , H.div [ class modalContentsClass ] [ contents ]
                , viewFooter opts
                ]

        visibilityAttr =
            attribute "visible" << boolToString

        maskVisibilityAttr =
            attribute "mask-visible" << boolToString

        maybeMaskOnClick =
            case opts.onCancel of
                Nothing ->
                    []

                Just updateVisibility ->
                    [ onClick (updateVisibility False) ]

        attributes =
            if isVisible then
                maybeMaskOnClick
                    ++ [ visibilityAttr True
                       , maskVisibilityAttr opts.showMask
                       , class modalRootClass
                       , Attr.value "modal-root"
                       ]

            else
                [ visibilityAttr False
                , class modalRootClass
                ]
    in
    if isVisible then
        H.div attributes
            [ globalStyles, modalHtml ]

    else
        H.div attributes
            [ modalHtml ]


boolToString : Bool -> String
boolToString val =
    if val then
        "true"

    else
        "false"
