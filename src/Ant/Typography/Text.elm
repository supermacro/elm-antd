module Ant.Typography.Text exposing
    ( TextType(..)
    , text
    , textType
    , strong
    , toHtml
    )

import Ant.Typography exposing (commonFontStyles)
import Css exposing (Style, color, rgba)
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
    }


text : String -> Text
text label =
    Text defaultTextOptions label


textType : TextType -> Text -> Text
textType textType_ (Text textOptions label) =
    let
        secondaryTextOptions =
            { textOptions | type_ = textType_ }
    in
    Text secondaryTextOptions label



strong : Text -> Text
strong (Text textOptions label) = 
    let
        strongTextOptions =
            { textOptions | strong = True }
    in
    Text strongTextOptions label



toHtml : Text -> Html msg
toHtml (Text opts label) =
    let
        fontWeight =
            if opts.strong then
                Css.fontWeight (Css.int 600)

            else
                Css.fontWeight Css.normal
    in
    toUnstyled
        (Styled.span
            [ css (commonFontStyles ++ [ textColor, fontWeight ])
            , disabled opts.disabled
            ]
            [ Styled.text label ]
        )
