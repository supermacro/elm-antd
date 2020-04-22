module Routes.TypographyComponent exposing (route)

import Ant.Typography as Typography
import Ant.Typography.Text as Text exposing (text)
import Html exposing (Html, br, div)
import Typography exposing (documentationText)
import Utils exposing (ComponentCategory(..), DocumentationRoute, createRoute)


route : DocumentationRoute msg
route = createRoute
    { title = "Typography"
    , category = General
    , view = view
    }


view : msg -> Html msg
view _ =
    let
        textComponent =
            text "Ant Design"
                |> Text.toHtml

        codeComponent =
            text "Ant Design"
                |> Text.code
                |> Text.toHtml
    in
    div []
        [ Typography.title "Typography"
            |> Typography.toHtml
        , documentationText <| Html.text "Basic text writing, including headings, body text, lists, and more."
        , textComponent
        , br [] []
        , codeComponent
        ]
