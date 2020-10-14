module Routes.SpaceComponent.VerticalAndSpacingExample exposing (example)

import Ant.Alert as Alert exposing (alert)
import Ant.Button as Button exposing (button)
import Ant.Space as Space exposing (space)
import Html exposing (Html)


example : Html msg
example =
    let
        spacingTop =
            List.map Alert.toHtml
                [ alert "Alerts"
                , alert "With Spacing"
                    |> Alert.withType Alert.Warning
                , alert "Set to Large"
                    |> Alert.withType Alert.Error
                ]
                |> space
                |> Space.direction Space.Horizontal
                |> Space.withSize Space.Large
                |> Space.toHtml

        button2 =
            List.map Alert.toHtml
                [ alert "Alerts"
                , alert "With Spacing"
                    |> Alert.withType Alert.Warning
                , alert "Set to Medium"
                    |> Alert.withType Alert.Error
                ]
                |> space
                |> Space.direction Space.Horizontal
                |> Space.withSize Space.Medium
                |> Space.toHtml
    in
    space [ spacingTop, button2 ]
        |> Space.direction Space.Vertical
        |> Space.toHtml
