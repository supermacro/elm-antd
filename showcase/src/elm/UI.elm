module UI exposing
    ( container
    , noBottomBorder
    , noLeftBorder
    , noRightBorder
    , noTopBorder
    , paddingTop
    , paddingRight
    , paddingBottom
    , paddingLeft
    , toHtml
    )

import Css exposing (Style, borderBottom3, borderLeft3, borderRight3, borderTop3, hex, px, solid)
import Html.Styled as Styled exposing (div)
import Html.Styled.Attributes exposing (css)


type alias ContainerOptions =
    { paddingTop : Style
    , paddingRight : Style
    , paddingBottom : Style
    , paddingLeft : Style
    , showTopBorder : Bool
    , showRightBorder : Bool
    , showBottomBorder : Bool
    , showLeftBorder : Bool
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
        [ children ]
