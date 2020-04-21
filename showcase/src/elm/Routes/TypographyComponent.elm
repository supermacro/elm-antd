module Routes.TypographyComponent exposing (category, title, view)

import Ant.Typography as Typography
import Ant.Typography.Text as Text exposing (strong, text)
import Html exposing (Html, div)
import Utils exposing (ComponentCategory(..), documentationText)


type alias Title =
    String


title : Title
title =
    "Typography"


category : ComponentCategory
category =
    General


view : ( Title, Html msg )
view =
    let
        textComponent =
            text "Ant Design"
                |> Text.toHtml
    in
    ( title
    , div []
        [ Typography.title "Typography"
          |> Typography.toHtml
        , documentationText <| Html.text "Basic text writing, including headings, body text, lists, and more."
        , textComponent
        ]
    )
