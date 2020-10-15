module Routes.SpaceComponent.BasicExample exposing (example)

import Ant.Button as Button exposing (button)
import Ant.Space as Space exposing (space)
import Html exposing (Html)


example : Html msg
example =
    let
        button1 =
            button "Button 1"
                |> Button.withType Button.Primary
                |> Button.toHtml

        button2 =
            button "Button 2"
                |> Button.withType Button.Dashed
                |> Button.toHtml

        button3 =
            button "Button 3"
                |> Button.disabled True
                |> Button.toHtml
    in
    space [ button1, button2, button3 ]
        |> Space.toHtml
