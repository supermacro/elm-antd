module Ant.Typography exposing (fontList, commonFontStyles, textSelectionStyles, headingColorRgba, title, toHtml)

import Css exposing (..)
import Html exposing (Html)
import Html.Styled as Styled exposing (toUnstyled)
import Html.Styled.Attributes exposing (css)

import Ant.Palette exposing (primaryColor)


fontList : List String
fontList =
    [ "-apple-system"
    , "BlinkMacSystemFont"
    , qt "Segoe UI"
    , "Roboto"
    , qt "Helvetica Neue"
    , "Arial"
    , qt "Noto Sans"
    , "sans-serif"
    , qt "Apple Color Emoji"
    , qt "Segoe UI Emoji"
    , qt "Segoe UI Symbol"
    , qt "Noto Color Emoji"
    ]


headingColorRgba : { r : Int, g : Int, b : Int, a : Float }
headingColorRgba =
    { r = 0
    , g = 0
    , b = 0
    , a = 0.85
    }


headingColor : Style
headingColor =
    let
        { r, g, b, a } =
            headingColorRgba
    in
    color (rgba r g b a)



textSelectionStyles : Style
textSelectionStyles =
    selection
        [ backgroundColor primaryColor
        , color (hex "#fff")
        ]


commonFontStyles : List Style
commonFontStyles =
    [ fontFamilies fontList
    , textSelectionStyles
    ]


type Level = H1 | H2 | H3 | H4

type alias TitleOptions =
    { level : Level
    }


type Title
    = Title TitleOptions String


title : String -> Title
title titleText =
    Title { level = H1 } titleText


toHtml : Title -> Html msg
toHtml (Title options value) =
    let
        heading = case options.level of
            H1 -> Styled.h1
            H2 -> Styled.h2
            H3 -> Styled.h3
            H4 -> Styled.h4
    in
    toUnstyled
        (heading
            [ css
                ([ fontSize (px 30)
                , headingColor
                , marginBottom (em 0.5)
                ] ++ commonFontStyles)
            ]
            [ Styled.text value ]
        )
        