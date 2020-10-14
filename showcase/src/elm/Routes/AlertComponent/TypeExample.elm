module Routes.AlertComponent.TypeExample exposing (example)

import Ant.Alert exposing (Alert, AlertType(..), alert, toHtml, withType)
import Ant.Space as Space exposing (space)
import Html exposing (Html, div)
import Html.Attributes exposing (style)


alerts : List (Alert msg)
alerts =
    [ alert "Success Text"
    , alert "Info Text"
        |> withType Info
    , alert "Warning Text"
        |> withType Warning
    , alert "Error Text"
        |> withType Error
    ]


spacedOutAlerts : Html msg
spacedOutAlerts =
    List.map toHtml alerts
        |> space
        |> Space.direction Space.Vertical
        |> Space.withSize Space.Medium
        |> Space.toHtml


example : Html msg
example =
    div
        [ style "width" "100%"
        ]
        [ spacedOutAlerts ]
