module Routes.ButtonComponent.TypeExample exposing (example)

import Ant.Button as Btn exposing (ButtonType(..), button, toHtml)
import Ant.Space exposing (SpaceDirection(..))
import Html exposing (Html, div, span)
import Html.Attributes exposing (style)


withSpace : Html msg -> Html msg
withSpace element =
    span
        [ style "margin-bottom" "13px"
        , style "display" "inline-block"
        , style "margin-right" "13px"
        ]
        [ element ]


example : Html msg
example =
    let
        primaryButton =
            button "Primary Button"
                |> Btn.withType Primary
                |> toHtml
                |> withSpace

        defaultButton =
            button "Default Button"
                |> Btn.withType Default
                |> toHtml
                |> withSpace

        dashedButton =
            button "Dashed Button"
                |> Btn.withType Dashed
                |> toHtml
                |> withSpace

        textButton =
            button "Text Button"
                |> Btn.withType Text
                |> toHtml
                |> withSpace

        linkButton =
            button "Link Button"
                |> Btn.withType Link
                |> toHtml
                |> withSpace
    in
    div []
        [ primaryButton
        , defaultButton
        , dashedButton
        , textButton
        , linkButton
        ]
