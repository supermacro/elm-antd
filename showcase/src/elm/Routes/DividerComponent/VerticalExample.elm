module Routes.DividerComponent.VerticalExample exposing (example)

import Ant.Divider as Divider
import Ant.Typography.Text as Text
import Html exposing (Html, text)
import Html exposing (Html, div, span)
import Css exposing (..)
import Html.Attributes exposing (style)
import Html.Styled as H exposing (text, toUnstyled, fromUnstyled)


example : Html msg
example =
    let
      dividerVertical = 
        Divider.divider
          |> Divider.withType Divider.Vertical
          |> Divider.toHtml
      text =
        Text.text "Text"
          |> Text.toHtml
          
    in
    div [ style "display" "flex" ]
      [ text
      , dividerVertical
      , text
      , dividerVertical
      , text
      ]