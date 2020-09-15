module Ant.Internals.Typography exposing
    ( commonFontStyles
    , fontList
    , headingColorRgba
    , textColorRgba
    , textSelectionStyles
    )

import Ant.Internals.Palette exposing (primaryColor)
import Css exposing (..)


fontList : List String
fontList =
    [ "-apple-system"
    , "system-ui"
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


textSelectionStyles : Style
textSelectionStyles =
    selection
        [ backgroundColor (hex primaryColor)
        , color (hex "#fff")
        ]


commonFontStyles : List Style
commonFontStyles =
    [ fontFamilies fontList
    , textSelectionStyles
    ]


headingColorRgba : { r : Int, g : Int, b : Int, a : Float }
headingColorRgba =
    { r = 0
    , g = 0
    , b = 0
    , a = 0.85
    }


textColorRgba : { r : Int, g : Int, b : Int, a : Float }
textColorRgba =
    { r = 0
    , g = 0
    , b = 0
    , a = 0.65
    }
