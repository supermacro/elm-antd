module Routes.TypographyComponent exposing (route)

import Ant.Typography as Typography
import Ant.Typography.Text as Text exposing (text)
import Html.Styled as Styled exposing (br, div, fromUnstyled)
import UI.Typography exposing (documentationText)
import Utils exposing (ComponentCategory(..), DocumentationRoute)


route : DocumentationRoute msg
route =
    { title = "Typography"
    , category = General
    , view = view
    }


view : msg -> Styled.Html msg
view _ =
    let
        textComponent =
            text "Ant Design"
                |> Text.toHtml
                |> fromUnstyled

        codeComponent =
            text "Ant Design"
                |> Text.code
                |> Text.toHtml
                |> fromUnstyled
    in
    div []
        [ Typography.title "Typography"
            |> Typography.toHtml
        , documentationText <| Styled.text "Basic text writing, including headings, body text, lists, and more."
        , textComponent
        , br [] []
        , codeComponent
        ]
