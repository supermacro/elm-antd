module Ant.Typography.Text exposing
    ( TextType(..)
    , Text
    , text
    , code
    , keyboard
    , textType
    , strong
    , toHtml
    , listToHtml
    , disabled
    , underlined
    , lineThrough
    , highlighted
    , textColorRgba
    )

import Ant.Palette exposing (warningColor, dangerColor)
import Ant.Typography exposing (fontList, textSelectionStyles)
import Css exposing (..)
import Html exposing (Html)
import Html.Styled as Styled exposing (text, toUnstyled)
import Html.Styled.Attributes as A exposing (css)


type TextType
    = Primary
    | Secondary
    | Warning
    | Danger


type BorderStyle = Code | Keyboard | None


type alias TextOptions =
    { disabled : Bool
    , highlighted : Bool
    , underlined : Bool
    , lineThrough : Bool
    , strong : Bool
    , type_ : TextType
    , borderStyle : BorderStyle
    }


type Text
    = Text TextOptions String

textColorRgba : { r : Int, g : Int, b : Int, a : Float }
textColorRgba =
    { r = 0
    , g = 0
    , b = 0
    , a = 0.65
    }


defaultTextOptions : TextOptions
defaultTextOptions =
    { disabled = False
    , highlighted = False
    , strong = False
    , type_ = Primary
    , underlined = False
    , lineThrough = False
    , borderStyle = None
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
            { textOptions | borderStyle = Code }
    in
    Text newTextOptions value


keyboard : Text -> Text
keyboard (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | borderStyle = Keyboard }
    in
    Text newTextOptions value


underlined : Bool -> Text -> Text
underlined underlined_ (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | underlined = underlined_ }
    in
    Text newTextOptions value
    

    
lineThrough : Bool -> Text -> Text
lineThrough lineThrough_ (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | lineThrough = lineThrough_ }
    in
    Text newTextOptions value


strong : Text -> Text
strong (Text textOptions value) = 
    let
        strongTextOptions =
            { textOptions | strong = True }
    in
    Text strongTextOptions value


disabled : Bool -> Text -> Text
disabled disabled_ (Text textOptions value) =
    let
        newOptions =
            { textOptions | disabled = disabled_ }
    in
    Text newOptions value


highlighted : Bool -> Text -> Text
highlighted highlighted_ (Text textOptions value) =
    let
        newOptions =
            { textOptions | highlighted = highlighted_ }
    in
    Text newOptions value


listToHtml : List Text -> Html msg
listToHtml =
    Html.span [] <<
        List.map toHtml


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

        textColor =
            case (opts.type_, opts.disabled) of
                (_, True) ->
                    let
                        { r, g, b } = textColorRgba
                    in
                        color (rgba r g b 0.25)
                
                (Primary, _) ->
                    let
                        { r, g, b, a } = textColorRgba
                    in
                    color (rgba r g b a)
                
                (Secondary, _) ->
                    let
                        { r, g, b } = textColorRgba
                    in 
                        color (rgba r g b 0.45)

                (Warning, _) ->
                    color (hex warningColor)

                (Danger, _) -> 
                    color (hex dangerColor)

        backgroundStyles =
            if opts.highlighted then
                Css.batch
                    [ color (hex "#000")
                    , backgroundColor (hex "#ffe58f")
                    ]
            else
                Css.batch []

        cursorStyles =
            if opts.disabled then
                Css.batch
                    [ property "user-select" "none"
                    , cursor notAllowed
                    ]
            else
                cursor inherit

        underlineStyles =
            if opts.underlined then
                textDecorationLine underline
            else if opts.lineThrough then
                textDecorationLine Css.lineThrough
            else
                textDecorationLine inherit
        
        borderStyles =
            case opts.borderStyle of
                Code ->
                    Css.batch
                        [ Css.fontFamilies codeFontList
                        , Css.backgroundColor (rgba 150 150 150 0.1)
                        , padding3 (px 2.38) (px 4.76) (px 1.19)
                        , marginLeft (px 2.3)
                        , marginRight (px 2.3)
                        , border3 (px 1) solid ((rgba 0 0 0 0.06))
                        , borderRadius (px 3)
                        , Css.fontSize (px 11.9)
                        , Css.lineHeight (px 18.7008)
                        ]
                
                Keyboard ->
                    Css.batch
                        [ Css.fontFamilies codeFontList
                        , Css.backgroundColor (rgba 150 150 150 0.06)
                        , padding3 (px 2.38) (px 4.76) (px 1.19)
                        , marginLeft (px 2.3)
                        , marginRight (px 2.3)
                        , border3 (px 1) solid ((rgba 0 0 0 0.06))
                        , borderRadius (px 3)
                        , Css.fontSize (px 12.6)
                        , Css.lineHeight (px 18.7008)
                        ]

                None ->
                    Css.batch
                        [ Css.fontFamilies fontList
                        , Css.lineHeight (px 18)
                        , Css.fontSize (px 14)
                        ]
                

    in
    toUnstyled
        (Styled.span
            [ css
                [ textSelectionStyles
                , borderStyles
                , fontWeight
                , cursorStyles
                , textColor
                , underlineStyles
                , backgroundStyles
                , maxWidth fitContent
                ]
            , A.disabled opts.disabled
            ]
            [ Styled.text value ]
        )
