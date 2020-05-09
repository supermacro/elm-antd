module UI.Container exposing
    ( demoBox
    , paddingTop
    , paddingRight
    , paddingBottom
    , paddingLeft
    , update
    , view
    , Msg
    )

import Ant.Icons as Icons
import Ant.Tooltip as Tooltip exposing (tooltip)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html as Unstyled exposing (Html)
import Html.Styled as Styled exposing (fromUnstyled, toUnstyled, div, span, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import SyntaxHighlight exposing (useTheme, gitHub, elm, toBlockHtml)

import UI.Typography exposing (commonTextStyles)



type alias Model =
    { sourceCodeVisible : Bool
    }


type Msg
    = SourceCodeVisibilityToggled


update : Msg -> Model -> Model
update _ currentModel =
    { currentModel | sourceCodeVisible = not currentModel.sourceCodeVisible
    }


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



-- type alias ContainerMetaSectionActions a =
--     { ellie : Url
--     , copyCode : Maybe String
--     , showCode : Cmd msg
--     }

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
            ]
        ]
        [ fromUnstyled <| useTheme gitHub
        , fromUnstyled unstyledSourceCodeView
        ]


opacityTransition : Style
opacityTransition =
    transition
        [ Css.Transitions.opacity 250 ]


iconContainer :
    (List (String, String) -> Html msg)
    -> String
    -> msg 
    -> List ( String, String )
    -> Styled.Html msg
iconContainer icon tooltipText msg extraStyles =
    let
        commonIconStyles =
            [ ("margin-right", "10px")
            , ("margin-left", "10px")
            , ("cursor", "pointer")
            ]

        bareIconContainer = 
            span
                [ css
                    [ opacity inherit
                    , display inlineBlock
                    , marginTop (px 5)
                    , hover
                        [ opacity (num 1) ]
                    , opacityTransition
                    ]
                , onClick msg
                ]
                [ fromUnstyled <| icon (extraStyles ++ commonIconStyles) ]
    in
    tooltip tooltipText (toUnstyled bareIconContainer)
    |> Tooltip.toHtml
    |> fromUnstyled



view : Model -> Container -> Styled.Html Msg
view model (Container opts children) =
    let
        metaSectionContent =
            let
                metaSectionStyles = commonTextStyles ++
                    [ position relative
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
                        [ iconContainer
                            Icons.ellieLogo
                            "Open in Ellie"
                            SourceCodeVisibilityToggled
                            [ ("width", "12px") ]

                        , iconContainer
                            Icons.copyToClipboard
                            "Copy code"
                            SourceCodeVisibilityToggled
                            [ ("width", "16px") ]

                        , iconContainer
                            Icons.codeOpenBrackets
                            "Show code"
                            SourceCodeVisibilityToggled
                            [ ("width", "17px") ]
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
    div []
        (mainContainerSection :: metaSectionContent)
