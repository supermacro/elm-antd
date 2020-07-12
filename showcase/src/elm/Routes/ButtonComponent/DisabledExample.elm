module Routes.ButtonComponent.DisabledExample exposing (example)

import Ant.Button exposing (Button, ButtonType(..), button, disabled, onClick, toHtml, withType)
import Ant.Space as Space exposing (space)
import Html exposing (Html, div)


type Msg
    = Clicked


row : List (Button msg) -> Html msg
row buttons =
    List.map toHtml buttons
    |> space
    |> Space.direction Space.Horizontal
    |> Space.toHtml


baseButton : String -> Button Msg
baseButton label =
    button label
    |> onClick Clicked


primaryButton : String -> Button Msg
primaryButton label =
    baseButton label
    |> withType Primary


dashedButton : String -> Button Msg
dashedButton label =
    baseButton label
    |> withType Dashed


textButton : String -> Button Msg
textButton label =
    baseButton label
    |> withType Text


example : Html Msg
example =
    let
        primaryExample =
            row
                [ primaryButton "Primary"
                , primaryButton "Primary (disabled)" |> disabled True
                ]

        defaultExample =
            row
                [ baseButton "Default"
                , baseButton "Default (disabled)" |> disabled True
                ]

        dashedExample =
            row
                [ dashedButton "Dashed"
                , dashedButton "Dashed (disabled)" |> disabled True
                ]

        textExample =
            row
                [ textButton "Text"
                , textButton "Text (disabled)" |> disabled True
                ]

        examples =
            [ primaryExample
            , defaultExample
            , dashedExample
            , textExample
            ]
    in
    space examples
        |> Space.toHtml

