module UI.Container exposing
    ( Model
    , Msg(..)
    , createDemoBox
    , initModel
    , initStatefulModel
    , setSourceCode
    , update
    , view
    )

import Ant.Icons as Icons exposing (Icon)
import Ant.Tooltip as Tooltip exposing (tooltip)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html as Unstyled exposing (Html)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text, toUnstyled)
import Html.Styled.Attributes as A exposing (css, href)
import Html.Styled.Events exposing (onClick)
import SyntaxHighlight exposing (elm, gitHub, toBlockHtml, useTheme)
import UI.Typography exposing (commonTextStyles)
import Utils exposing (SourceCode)


type alias Model m msg =
    { fileName : String
    , sourceCodeVisible : Bool
    , sourceCode : Maybe String

    -- the model associated with the example
    , state : DemoState m msg
    }


type alias DemoState m msg =
    { model : m
    , update : msg -> m -> ( m, Cmd msg )
    }


type Msg msg
    = SourceCodeVisibilityToggled
    | CopySourceToClipboardRequested
      -- represents a message emitted from within a demo / example
    | ContentMsg msg


type alias DemoBoxMetaInfo =
    { title : String
    , content : String
    , ellieDemo : String
    }


{-| Create a demo model that has no state
-}
initModel : String -> Model () Never
initModel fileName =
    { sourceCodeVisible = False
    , sourceCode = Nothing
    , fileName = fileName
    , state =
        { model = ()
        , update = \_ _ -> ( (), Cmd.none )
        }
    }


{-| Initialize a demo container that has some state for its example
-}
initStatefulModel : String -> m -> (msg -> m -> ( m, Cmd msg )) -> Model m msg
initStatefulModel fileName initialModel updateFn =
    { sourceCodeVisible = False
    , sourceCode = Nothing
    , fileName = fileName
    , state =
        { model = initialModel
        , update = updateFn
        }
    }



{-
   Maybe this should be renamed to `view`?

-}


createDemoBox :
    (Msg a -> msg)
    -> Model m a
    -> (m -> Html a)
    -> DemoBoxMetaInfo
    -> Styled.Html msg
createDemoBox tagger model demoView metaInfo =
    let
        demo =
            demoView model.state.model

        styledDemo =
            fromUnstyled demo
                |> Styled.map ContentMsg

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledDemo ]
    in
    view model metaInfo styledDemo
        |> Styled.map tagger


setSourceCode : List SourceCode -> Model m msg -> Model m msg
setSourceCode sourceCodeList model =
    let
        maybeSourceCode =
            sourceCodeList
                |> List.filter (\{ fileName } -> fileName == model.fileName)
                |> List.head
                |> Maybe.map .fileContents
    in
    { model | sourceCode = maybeSourceCode }


update : (Msg a -> msg) -> Msg a -> Model m a -> ( Model m a, Cmd msg )
update tagger msg model =
    case msg of
        SourceCodeVisibilityToggled ->
            ( { model
                | sourceCodeVisible = not model.sourceCodeVisible
              }
            , Cmd.none
            )

        CopySourceToClipboardRequested ->
            case model.sourceCode of
                Just source ->
                    ( model, Utils.copySourceToClipboard source )

                Nothing ->
                    ( model, Cmd.none )

        ContentMsg innerMsg ->
            let
                demoModel =
                    model.state.model

                demoUpdateFn =
                    model.state.update

                ( newDemoModel, demoCmd ) =
                    demoUpdateFn innerMsg demoModel
            in
            ( { model | state = DemoState newDemoModel demoUpdateFn }
            , Cmd.map (tagger << ContentMsg) demoCmd
            )



-------------------------
-- View code


borderColor : Color
borderColor =
    hex "#f0f0f0"


viewSourceCode : String -> Styled.Html (Msg msg)
viewSourceCode sourceCode =
    let
        unstyledSourceCodeView =
            elm sourceCode
                |> Result.map (toBlockHtml Nothing)
                |> Result.withDefault
                    (Unstyled.code [] [ Unstyled.text sourceCode ])
    in
    div
        [ css
            [ padding2 (px 15) (px 25)
            , borderTop3 (px 1) dashed borderColor
            , overflowX scroll
            ]
        ]
        [ fromUnstyled <| useTheme gitHub
        , fromUnstyled unstyledSourceCodeView
        ]


opacityTransition : Style
opacityTransition =
    transition
        [ Css.Transitions.opacity 250 ]


type Either a b
    = Left a
    | Right b


type alias EllieAppUrl =
    String


type alias IconContainerOptions msg =
    { icon : Icon msg
    , tooltipText : String
    , event : Either msg EllieAppUrl
    , extraStyles : List ( String, String )
    }


iconContainer : IconContainerOptions msg -> Styled.Html msg
iconContainer { icon, tooltipText, event, extraStyles } =
    let
        commonIconStyles =
            [ ( "margin-right", "10px" )
            , ( "margin-left", "10px" )
            , ( "cursor", "pointer" )
            ]

        baseAttributes =
            css
                [ opacity inherit
                , display inlineBlock
                , marginTop (px 5)
                , hover
                    [ opacity (num 1) ]
                , opacityTransition
                ]

        childNode =
            icon
                |> Icons.withStyles (extraStyles ++ commonIconStyles)
                |> Icons.toHtml
                |> fromUnstyled

        bareIconContainer =
            case event of
                Left msg ->
                    span
                        [ baseAttributes
                        , onClick msg
                        ]
                        [ childNode ]

                Right ellieAppUrl ->
                    Styled.a
                        [ baseAttributes
                        , A.target "_blank"
                        , href ellieAppUrl
                        ]
                        [ childNode ]
    in
    tooltip tooltipText (toUnstyled bareIconContainer)
        |> Tooltip.toHtml
        |> fromUnstyled


view : Model m msg -> DemoBoxMetaInfo -> Styled.Html (Msg msg) -> Styled.Html (Msg msg)
view model metaInfo demo =
    let
        metaSectionContent =
            let
                metaSectionStyles =
                    commonTextStyles
                        ++ [ position relative
                           , borderBottom3 (px 1) solid borderColor
                           , borderRight3 (px 1) solid borderColor
                           , borderLeft3 (px 1) solid borderColor
                           ]

                callToActionIcons =
                    div
                        [ css
                            [ Css.paddingTop (px 12)
                            , textAlign center
                            , borderTop3 (px 1) dashed borderColor
                            , Css.paddingTop (px 15)
                            , Css.paddingBottom (px 15)
                            , opacity (num 0.5)
                            , hover
                                [ opacity (num 0.6) ]
                            , opacityTransition
                            ]
                        ]
                        [ iconContainer <|
                            IconContainerOptions
                                Icons.ellieLogo
                                "Open in Ellie"
                                (Right metaInfo.ellieDemo)
                                []
                        , iconContainer <|
                            IconContainerOptions
                                Icons.copyToClipboard
                                "Copy code"
                                (Left CopySourceToClipboardRequested)
                                [ ( "width", "16px" ) ]
                        , iconContainer <|
                            IconContainerOptions
                                Icons.codeOpenBrackets
                                "Show code"
                                (Left SourceCodeVisibilityToggled)
                                [ ( "width", "17px" ) ]
                        ]

                sourceCodeView =
                    if model.sourceCodeVisible then
                        case model.sourceCode of
                            Just source ->
                                viewSourceCode source

                            Nothing ->
                                div [] []

                    else
                        div [] []
            in
            [ div
                [ css metaSectionStyles
                ]
                [ div
                    [ css
                        [ fontWeight (int 500)
                        , Css.position Css.absolute
                        , top (px -10)
                        , Css.paddingLeft (px 8)
                        , Css.paddingRight (px 8)
                        , backgroundColor (rgb 255 255 255)
                        , left (px 16)
                        ]
                    ]
                    [ text metaInfo.title ]
                , div
                    [ css
                        [ padding4 (px 18) (px 24) (px 12) (px 24) ]
                    ]
                    [ text metaInfo.content ]
                , callToActionIcons
                , sourceCodeView
                ]
            ]

        mainContainerSection =
            div
                [ css
                    [ border3 (px 1) solid borderColor
                    , Css.paddingTop (px 30)
                    , Css.paddingRight (px 24)
                    , Css.paddingBottom (px 50)
                    , Css.paddingLeft (px 24)
                    ]
                ]
                [ demo ]
    in
    div [ css [ marginBottom (em 1) ] ]
        (mainContainerSection :: metaSectionContent)
