module Routes.DividerComponent.WithTitleExample exposing (example)

import Ant.Divider as Divider
import Ant.Typography.Text as Text
import Html exposing (Html, text)
import Html exposing (Html, div, span)
import Html.Styled as H exposing (text, toUnstyled, fromUnstyled)


example : Html msg
example =
    let
      dividerCenter =
        Divider.divider
          |> Divider.withLabel "Center"
          |> Divider.withOrientation Divider.Center
          |> Divider.withTextStyle Divider.Heading
          |> Divider.toHtml

      dividerLeft =
        Divider.divider
          |> Divider.withLabel "Left"
          |> Divider.withOrientation Divider.Left
          |> Divider.withTextStyle Divider.Heading
          |> Divider.toHtml

      dividerRight =
        Divider.divider
          |> Divider.withLabel "Right"
          |> Divider.withOrientation Divider.Right
          |> Divider.withTextStyle Divider.Heading
          |> Divider.toHtml

      loremIpsum =
        Text.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo."
          |> Text.toHtml
          
    in
    div []
      [ loremIpsum
      , dividerCenter
      , loremIpsum
      , dividerLeft
      , loremIpsum
      , dividerRight
      , loremIpsum
      ]