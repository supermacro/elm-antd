module UI.Container exposing
    ( container
    , noBottomBorder
    , noLeftBorder
    , noRightBorder
    , noTopBorder
    , paddingTop
    , paddingRight
    , paddingBottom
    , paddingLeft
    , withMetaSection
    , toHtml
    )

import Css exposing (..)
import Html.Styled as Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import UI.Typography exposing (commonTextStyles)


type alias ContainerOptions =
    { paddingTop : Style
    , paddingRight : Style
    , paddingBottom : Style
    , paddingLeft : Style
    , showTopBorder : Bool
    , showRightBorder : Bool
    , showBottomBorder : Bool
    , showLeftBorder : Bool
    , meta : Maybe ContainerMetaSection
    }


type Container msg
    = Container ContainerOptions (Styled.Html msg)


defaultContainerOptions : ContainerOptions
defaultContainerOptions =
    { paddingTop = Css.paddingTop (px 10)
    , paddingRight = Css.paddingRight (px 10)
    , paddingBottom = Css.paddingBottom (px 10)
    , paddingLeft = Css.paddingLeft (px 10)
    , showTopBorder = True
    , showRightBorder = True
    , showBottomBorder = True
    , showLeftBorder = True
    , meta = Nothing
    }


container : Styled.Html msg -> Container msg
container =
    Container defaultContainerOptions


noTopBorder : Container msg -> Container msg
noTopBorder (Container opts children) =
    let
        newOpts =
            { opts | showTopBorder = False }
    in
    Container newOpts children


noRightBorder : Container msg -> Container msg
noRightBorder (Container opts children) =
    let
        newOpts =
            { opts | showRightBorder = False }
    in
    Container newOpts children


noBottomBorder : Container msg -> Container msg
noBottomBorder (Container opts children) =
    let
        newOpts =
            { opts | showBottomBorder = False }
    in
    Container newOpts children


noLeftBorder : Container msg -> Container msg
noLeftBorder (Container opts children) =
    let
        newOpts =
            { opts | showLeftBorder = False }
    in
    Container newOpts children


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
    }


withMetaSection : ContainerMetaSection -> Container msg -> Container msg
withMetaSection meta (Container opts children) =
    let
        newOpts =
            { opts | meta = Just meta }
    in
    Container newOpts children


-- withMetaSection : String -> Html msg -> Container msg -> Container msg
-- withMetaSection : sectionLabel content

toHtml : Container msg -> Styled.Html msg
toHtml (Container opts children) =
    let
        borderColor =
            hex "#f0f0f0"

        borderStyles =
            List.map
                (\( borderRule, enabled ) ->
                    if enabled then
                        borderRule (px 1) solid borderColor

                    else
                        borderRule (px 0) solid borderColor
                )
                [ ( borderTop3, opts.showTopBorder )
                , ( borderRight3, opts.showRightBorder )
                , ( borderBottom3, opts.showBottomBorder )
                , ( borderLeft3, opts.showLeftBorder )
                ]

        metaSectionContent =
            case opts.meta of
                Just { title, content } ->
                    [ div [ css commonTextStyles ]
                        [ div [ css [ fontWeight (int 500) ] ] [ text title ]
                        , text content
                        ]
                    ]

                Nothing -> []
    in
    div
        [ css
            (borderStyles
                ++ [ opts.paddingTop
                   , opts.paddingRight
                   , opts.paddingBottom
                   , opts.paddingLeft
                   ]
            )
        ]
        (children :: metaSectionContent)
