module Ant.Typography.Paragraph exposing
    ( paragraph
    )

import Css exposing (marginBottom, px)
import Html exposing (Html)
import Html.Styled exposing (p, fromUnstyled, toUnstyled)
import Html.Styled.Attributes exposing (css)

paragraph : List (Html a) -> Html a
paragraph children =
    toUnstyled 
        <| p [ css [ marginBottom (px 14) ] ]
            (List.map fromUnstyled children)

