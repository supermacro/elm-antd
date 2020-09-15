module Routes.ButtonComponent.IconExample exposing (example, Msg)

import Ant.Button exposing (Button, ButtonType(..), button, onClick, toHtml, withIcon, withType)
import Ant.Icons as Icon exposing (searchOutlined)
import Ant.Space as Space exposing (space)
import Html exposing (Html, div)
import Html.Attributes exposing (style)


type Msg
    = Clicked


row : Button msg -> Html msg
row btn =
    div [ style "max-width" "130px" ] [ toHtml btn ]


baseButton : String -> Button Msg
baseButton label =
    button label
        |> onClick Clicked
        |> withIcon searchOutlined


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
            row <| primaryButton "Search"

        defaultExample =
            row <| baseButton "Search"

        dashedExample =
            row <| dashedButton "Search"

        textExample =
            row <| textButton "Text"

        examples =
            [ primaryExample
            , defaultExample
            , dashedExample
            , textExample
            ]
    in
    space examples
        |> Space.toHtml
