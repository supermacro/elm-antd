module UI.Container exposing
    ( demoBox
    , paddingTop
    , paddingRight
    , paddingBottom
    , paddingLeft
    , toHtml
    )

import Ant.Icons as Icons
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html.Styled as Styled exposing (fromUnstyled, div, span, text)
import Html.Styled.Attributes exposing (css)
import UI.Typography exposing (commonTextStyles)






type alias ContainerOptions =
    { paddingTop : Style
    , paddingRight : Style
    , paddingBottom : Style
    , paddingLeft : Style
    , meta : ContainerMetaSection
    }


type Container msg
    = Container ContainerOptions (Styled.Html msg)


defaultContainerOptions : ContainerMetaSection -> ContainerOptions
defaultContainerOptions metaSection =
    { paddingTop = Css.paddingTop (px 10)
    , paddingRight = Css.paddingRight (px 10)
    , paddingBottom = Css.paddingBottom (px 10)
    , paddingLeft = Css.paddingLeft (px 10)
    , meta = metaSection
    }


container : ContainerMetaSection -> Styled.Html msg -> Container msg
container =
    Container << defaultContainerOptions


paddingTop : Float -> Container msg -> Container msg
paddingTop val (Container opts children) =
    let
        newOpts =
            { opts | paddingTop = Css.paddingTop (px val) }
    in
    Container newOpts children


paddingRight : Float -> Container msg -> Container msg
paddingRight val (Container opts children) =
    let
        newOpts =
            { opts | paddingRight = Css.paddingRight (px val) }
    in
    Container newOpts children

paddingBottom : Float -> Container msg -> Container msg
paddingBottom val (Container opts children) =
    let
        newOpts =
            { opts | paddingBottom = Css.paddingBottom (px val) }
    in
    Container newOpts children


paddingLeft : Float -> Container msg -> Container msg
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


demoBox : ContainerMetaSection -> Styled.Html msg -> Container msg
demoBox meta content =
    container meta content
        |> paddingBottom 50
        |> paddingTop 30
        |> paddingRight 24
        |> paddingLeft 24



toHtml : Container msg -> Styled.Html msg
toHtml (Container opts children) =
    let
        borderColor =
            hex "#f0f0f0"

        metaSectionContent =
            let
                metaSectionStyles = commonTextStyles ++
                    [ position relative
                    , borderBottom3 (px 1) solid borderColor
                    , borderRight3 (px 1) solid borderColor
                    , borderLeft3 (px 1) solid borderColor
                    ]

                commonIconStyles =
                    [ ("margin-right", "10px")
                    , ("margin-left", "10px")
                    ]

                opacityTransition =
                    transition
                        [ Css.Transitions.opacity 250 ]

                iconContainer icon extraStyles =
                    span
                        [ css
                            [ opacity inherit
                            , hover
                                [ opacity (num 1) ]
                            , opacityTransition
                            ]
                        ]
                        [ fromUnstyled <| icon <| extraStyles ++ commonIconStyles ]

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
                        [ iconContainer Icons.ellieLogo [ ("width", "12px") ]
                        , iconContainer Icons.copyToClipboard [ ("width", "16px") ]
                        , iconContainer Icons.codeOpenBrackets [ ("width", "17px") ]
                        ]
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
