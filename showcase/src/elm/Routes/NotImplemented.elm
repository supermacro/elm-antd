module Routes.NotImplemented exposing (notImplemented)

import Html.Styled exposing (Html, div, text)
import UI.Typography exposing (documentationHeading, documentationText, SubHeadingOptions(..))
import UI.Footer exposing (pushDown)

notImplemented : String -> Html msg
notImplemented componentName =
    div
        []
        [ documentationHeading componentName
        , documentationText <| text <| "Unfortunately, " ++ componentName ++ " is not yet implemented. But it could be ;)"
        , documentationText <| text "Check out the issues page and the contributing guide at https://github.com/supermacro/elm-antd#contributing"
        , pushDown
        ]
        

