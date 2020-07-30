module Routes.MenuComponent.HorizontalExample exposing (example)

import Ant.Menu as Menu
import Ant.Space exposing (SpaceDirection(..))
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (style)

example : msg -> Html msg
example msg =
  let
    menuItem1 =
      Menu.initMenuItem msg <| text "Navigation One"

    menuItem2 =
      Menu.initMenuItem msg (text "Navigation Two")
        |> Menu.disabled

    horizontalExample =
      Menu.initMenu
        |> Menu.pushItem menuItem1
        |> Menu.pushItem menuItem2
        |> Menu.mode Menu.Horizontal
        |> Menu.toHtml
  in
    div []
      [ horizontalExample ]