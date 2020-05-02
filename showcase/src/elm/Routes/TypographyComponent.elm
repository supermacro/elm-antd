module Routes.TypographyComponent exposing (route, Model)

import Ant.Typography as Typography
import Ant.Typography.Text as Text exposing (text)
import Html.Styled as Styled exposing (br, div, fromUnstyled)
import UI.Typography exposing (documentationText)
import Utils exposing (ComponentCategory(..), DocumentationRoute)


type alias Model = ()

route : DocumentationRoute Model Never
route =
    { title = "Typography"
    , category = General
    , view = view
    , initialModel = ()
    , update = \_ _ -> ()
    }


view : model -> Styled.Html Never
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
