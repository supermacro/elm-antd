module Routes.SpaceComponent.BasicExample exposing (example)

import Html exposing (Html)
import Ant.Space as Space exposing (space)
import Ant.Button as Button exposing (button)


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
        |> Space.direction Space.Horizontal
        |> Space.toHtml
