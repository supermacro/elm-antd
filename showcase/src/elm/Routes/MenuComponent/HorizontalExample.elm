module Routes.MenuComponent.HorizontalExample exposing (example)

import Ant.Menu as Menu
import Ant.Space exposing (SpaceDirection(..))
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (style)

example : msg -> Html msg
example msg =
  let
    menuItem1 =
      Menu.initMenuItem msg <| text "Menu Item 1"

    horizontalExample =
      Menu.initMenu
        |> Menu.pushItem menuItem1
        |> Menu.toHtml
  in
    div []
      [ horizontalExample ]