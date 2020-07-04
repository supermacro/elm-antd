module Routes.NotImplemented exposing (notImplemented)

import Html.Styled exposing (Html, div, span, text)
import UI.Footer exposing (pushDown)
import UI.Typography exposing (SubHeadingOptions(..), documentationHeading, documentationText, link)


notImplemented : String -> Html msg
notImplemented componentName =
    div
        []
        [ documentationHeading componentName
        , documentationText <| text <| "Unfortunately, " ++ componentName ++ " is not yet implemented. But it could be ;)"
        , documentationText <|
            span []
                [ text "Check out the contributing guide at "
                , link "https://github.com/supermacro/elm-antd#contributing" "github"
                ]
        , pushDown
        ]
