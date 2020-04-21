module Ant.Button exposing (button)

import Ant.Palette exposing (primaryColor, primaryColorFaded, primaryColorStrong)
import Css exposing (..)
import Html exposing (Html)
import Html.Styled as H exposing (text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)


button : msg -> Html msg
button msg =
    toUnstyled
        (H.button
            [ onClick msg
            , css
                [ borderRadius (px 2)
                , backgroundColor primaryColor
                , padding2 (px 4) (px 15)
                , border3 (px 2) solid primaryColor
                , color (hex "#fff")
                , fontSize (px 14)
                , height (px 34)
                , outline none
                , focus
                    [ backgroundColor primaryColorFaded
                    , borderColor primaryColorFaded
                    ]
                , hover
                    [ backgroundColor primaryColorFaded
                    , borderColor primaryColorFaded
                    ]
                , active
                    [ backgroundColor primaryColorStrong
                    , borderColor primaryColorStrong
                    ]
                ]
            ]
            [ H.span [] [ text "Primary" ] ]
        )
