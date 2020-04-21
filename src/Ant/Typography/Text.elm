module Ant.Typography.Text exposing
    ( TextType(..)
    , text
    , code
    , textType
    , strong
    , toHtml
    )

import Ant.Typography exposing (fontList, textSelectionStyles)
import Css exposing (Style, border3, borderRadius, color, rgba, px, qt, solid, padding3)
import Html exposing (Html)
import Html.Styled as Styled exposing (text, toUnstyled)
import Html.Styled.Attributes exposing (css, disabled)


type TextType
    = Primary
    | Secondary
    | Warning
    | Danger


type alias TextOptions =
    { disabled : Bool
    , strong : Bool
    , type_ : TextType
    , code : Bool
    }


type Text
    = Text TextOptions String


textColor : Style
textColor =
    color (rgba 0 0 0 0.65)


defaultTextOptions : TextOptions
defaultTextOptions =
    { disabled = False
    , strong = False
    , type_ = Primary
    , code = False
    }


text : String -> Text
text value =
    Text defaultTextOptions value


textType : TextType -> Text -> Text
textType textType_ (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | type_ = textType_ }
    in
    Text newTextOptions value



code : Text -> Text
code (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | code = True }
    in
    Text newTextOptions value



strong : Text -> Text
strong (Text textOptions value) = 
    let
        strongTextOptions =
            { textOptions | strong = True }
    in
    Text strongTextOptions value



toHtml : Text -> Html msg
toHtml (Text opts value) =
    let
        codeFontList : List String
        codeFontList =
            [ qt "SFMono-Regular"
            , "Consolas"
            , qt "Liberation Mono"
            , "Menlo"
            , "Courier"
            , "monospace"
            ]

        fontWeight =
            if opts.strong then
                Css.fontWeight (Css.int 600)

            else
                Css.fontWeight Css.normal

        textStyles =
            if opts.code then
                Css.batch
                    [ Css.fontFamilies codeFontList
                    , Css.backgroundColor (rgba 0 0 0 0.06)
                    , padding3 (px 2.38) (px 4.76) (px 1.19)
                    , border3 (px 1) solid ((rgba 0 0 0 0.06))
                    , borderRadius (px 3)
                    , Css.fontSize (px 11.9)
                    , Css.lineHeight (px 18.7008)
                    ]
            else
                Css.batch
                    [ Css.fontFamilies fontList
                    , Css.lineHeight (px 22.001)
                    , Css.fontSize (px 14)
                    ]

    in
    toUnstyled
        (Styled.span
            [ css
                [ textSelectionStyles
                , textStyles
                , fontWeight
                , textColor
                ]
            , disabled opts.disabled
            ]
            [ Styled.text value ]
        )
