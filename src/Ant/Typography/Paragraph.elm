module Ant.Typography.Paragraph exposing
    ( paragraph
    )

{-| Simple spacing between paragraphs

@docs paragraph
-}

import Css exposing (marginBottom, px)
import Html exposing (Html)
import Html.Styled exposing (p, fromUnstyled, toUnstyled)
import Html.Styled.Attributes exposing (css)

{-| Evenly space out a set of children
-}
paragraph : List (Html a) -> Html a
paragraph children =
    toUnstyled 
        <| p [ css [ marginBottom (px 14) ] ]
            (List.map fromUnstyled children)
