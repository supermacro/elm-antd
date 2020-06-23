module Routes.TypographyComponent.BasicExample exposing (example)

import Ant.Typography as Typography exposing (title, Level(..))
import Ant.Typography.Text as Text exposing (text, Text)
import Ant.Typography.Paragraph exposing (paragraph)
import Html exposing (Html, div)


codeText : String -> Text
codeText =
    Text.code << text

example : Html msg
example =
    div []
        [ title "Introduction" |> Typography.toHtml
        , paragraph
            [ text "In the process of internal desktop applications development, many different design specs and implementations would be involved, which might cause designers and developers difficulties and duplication and reduce the efficiency of development."
                |> Text.toHtml
            ]
        , paragraph
            [ text "After massive project practice and summaries, Ant Design, a design language for background applications, is refined by Ant UED Team, which aims to "
                |> Text.toHtml
            , text "uniform the user interface specs for internal background projects, lower the unnecessary cost of design differences and implementation and liberate the resources of design and front-end development."
                |> Text.strong
                |> Text.toHtml
            ]
        , title "Guidelines and Resources"
            |> Typography.level H2
            |> Typography.toHtml
        , paragraph
            [ text "We supply a series of design principles, practical patterns and high quality design resources "
                |> Text.toHtml
            , [ text "(", codeText "Sketch", text "and", codeText "Axure", text ")" ]
                |> Text.listToHtml
            , text ", to help people create their product prototypes beautifully and efficiently."
                |> Text.toHtml
            ]
        ]
