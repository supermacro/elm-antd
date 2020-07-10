module Routes.TypographyComponent.TitleComponent exposing (example)

import Ant.Typography as Typography exposing (Level(..), title)
import Html exposing (Html, div)


example : Html msg
example =
    div [] <|
        List.map Typography.toHtml
            [ title "h1. Ant Design"
            , title "h2. Ant Design"
                |> Typography.level H2
            , title "h3. Ant Design"
                |> Typography.level H3
            , title "h4. Ant Design"
                |> Typography.level H4
            , title "h5. Ant Design"
                |> Typography.level H5
            ]
