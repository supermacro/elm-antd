module UI.Footer exposing (footer)

import Css exposing (..)
import Html.Styled as Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import UI.Typography exposing (commonTextStyles)


footerStyles : List Css.Style
footerStyles =
    commonTextStyles
        ++ [ height (px 100)
           , color (hex "#fff")
           , backgroundColor (hex "#000")
           , marginTop (px 100)
           , paddingTop (px 50)
           , paddingRight (px 50)
           , paddingLeft (px 50)
           , textAlign center
           ]


footer : Styled.Html msg
footer =
    Styled.footer [ css footerStyles ]
        [ div [] [ text "Made with ❤ by supermacro (and you?)" ] ]
