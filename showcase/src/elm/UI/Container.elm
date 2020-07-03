module UI.Container exposing
    ( Model
    , Msg(..)
    , demoBox
    , paddingBottom
    , paddingLeft
    , paddingRight
    , paddingTop
    , update
    , view
    )

import Ant.Icons as Icons
import Ant.Tooltip as Tooltip exposing (tooltip)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html as Unstyled exposing (Html)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text, toUnstyled)
import Html.Styled.Attributes as A exposing (css, href)
import Html.Styled.Events exposing (onClick)
import SyntaxHighlight exposing (elm, gitHub, toBlockHtml, useTheme)
import UI.Typography exposing (commonTextStyles)
import Utils


type alias Model =
    { sourceCodeVisible : Bool
    , sourceCode : String
    }


type Msg
    = SourceCodeVisibilityToggled
    | CopySourceToClipboardRequested
      -- ContentMsg represents an opaque message
      -- emitted by the contents of a demoBox Container
    | ContentMsg


type alias ContainerOptions =
    { paddingTop : Style
    , paddingRight : Style
    , paddingBottom : Style
    , paddingLeft : Style
    , meta : ContainerMetaSection
    }


type Container
    = Container ContainerOptions (Styled.Html Msg)


defaultContainerOptions : ContainerMetaSection -> ContainerOptions
defaultContainerOptions metaSection =
    { paddingTop = Css.paddingTop (px 10)
    , paddingRight = Css.paddingRight (px 10)
    , paddingBottom = Css.paddingBottom (px 10)
    , paddingLeft = Css.paddingLeft (px 10)
    , meta = metaSection
    }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        SourceCodeVisibilityToggled ->
            ( { model
                | sourceCodeVisible = not model.sourceCodeVisible
              }
            , Cmd.none
            )

        CopySourceToClipboardRequested ->
            ( model, Utils.copySourceToClipboard model.sourceCode )

        ContentMsg ->
            ( model, Cmd.none )



-- View code


container : ContainerMetaSection -> Styled.Html Msg -> Container
container =
    Container << defaultContainerOptions


paddingTop : Float -> Container -> Container
paddingTop val (Container opts children) =
    let
        newOpts =
            { opts | paddingTop = Css.paddingTop (px val) }
    in
    Container newOpts children


paddingRight : Float -> Container -> Container
paddingRight val (Container opts children) =
    let
        newOpts =
            { opts | paddingRight = Css.paddingRight (px val) }
    in
    Container newOpts children


paddingBottom : Float -> Container -> Container
paddingBottom val (Container opts children) =
    let
        newOpts =
            { opts | paddingBottom = Css.paddingBottom (px val) }
    in
    Container newOpts children


paddingLeft : Float -> Container -> Container
paddingLeft val (Container opts children) =
    let
        newOpts =
            { opts | paddingLeft = Css.paddingLeft (px val) }
    in
    Container newOpts children



type alias ContainerMetaSection =
    { title : String
    , content : String
    , ellieDemo : String
    , sourceCode : String
    }


demoBox : ContainerMetaSection -> Styled.Html Msg -> Container
demoBox meta content =
    container meta content
        |> paddingBottom 50
        |> paddingTop 30
        |> paddingRight 24
        |> paddingLeft 24


borderColor : Color
borderColor =
    hex "#f0f0f0"


viewSourceCode : String -> Styled.Html Msg
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


type Either a b = Left a | Right b
type alias EllieAppUrl = String

type alias IconContainerOptions msg =
    { icon : List ( String, String) -> Html msg
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
            [ fromUnstyled <| icon (extraStyles ++ commonIconStyles) ]

        bareIconContainer =
            case event of
                Left msg ->
                    span
                        [ baseAttributes
                        , onClick msg
                        ]
                        childNode

                Right ellieAppUrl ->
                    Styled.a
                        [ baseAttributes
                        , A.target "_blank"
                        , href ellieAppUrl
                        ]
                        childNode
    in
    tooltip tooltipText (toUnstyled bareIconContainer)
        |> Tooltip.toHtml
        |> fromUnstyled


view : Model -> Container -> Styled.Html Msg
view model (Container opts children) =
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
                        [ iconContainer <| IconContainerOptions 
                            Icons.ellieLogo
                            "Open in Ellie"
                            (Right opts.meta.ellieDemo)
                            [ ( "width", "12px" ) ]
                        , iconContainer <| IconContainerOptions
                            Icons.copyToClipboard
                            "Copy code"
                            (Left CopySourceToClipboardRequested)
                            [ ( "width", "16px" ) ]
                        , iconContainer <| IconContainerOptions
                            Icons.codeOpenBrackets
                            "Show code"
                            (Left SourceCodeVisibilityToggled)
                            [ ( "width", "17px" ) ]
                        ]

                sourceCodeView =
                    if model.sourceCodeVisible then
                        viewSourceCode opts.meta.sourceCode

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
                    [ text opts.meta.title ]
                , div
                    [ css
                        [ padding4 (px 18) (px 24) (px 12) (px 24) ]
                    ]
                    [ text opts.meta.content ]
                , callToActionIcons
                , sourceCodeView
                ]
            ]

        mainContainerSection =
            div
                [ css
                    [ border3 (px 1) solid borderColor
                    , opts.paddingTop
                    , opts.paddingRight
                    , opts.paddingBottom
                    , opts.paddingLeft
                    ]
                ]
                [ children ]
    in
    div [ css [ marginBottom (em 1) ] ]
        (mainContainerSection :: metaSectionContent)
