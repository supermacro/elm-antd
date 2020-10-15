module Routes.AlertComponent.DescriptionExample exposing (example)

import Ant.Alert exposing (Alert, AlertType(..), alert, toHtml, withDescription, withType)
import Ant.Space as Space exposing (space)
import Html exposing (Html, div)
import Html.Attributes exposing (style)


alerts : List (Alert msg)
alerts =
    [ alert "Success Text"
        |> withDescription "Success Description Success Description Success Description"
    , alert "Info Text"
        |> withType Info
        |> withDescription "Info Description Info Description Info Description Info Description"
    , alert "Warning Text"
        |> withType Warning
        |> withDescription "Warning Description Warning Description Warning Description Warning Description"
    , alert "Error Text"
        |> withType Error
        |> withDescription "Error Description Error Description Error Description Error Description"
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
