module Routes.DrawerComponent.BasicExample exposing (example)

import Ant.Button as Btn exposing (ButtonType(..), button, toHtml)
import Ant.Drawer as Drawer exposing (collapsed, withPlacement)
import Ant.Typography.Text as Text
import Html exposing (Html)
import Css exposing (..)
import Html.Styled as H exposing (text, toUnstyled)

example : Html msg
example =
    Drawer.drawer content
        |> collapsed False
        |> withPlacement Drawer.Right
        |> Drawer.withHeader (Drawer.Title "Basic Drawer")
        |> Drawer.toHtml

content : Html msg
content =
  Text.text "Some content..."
      |> Text.toHtml