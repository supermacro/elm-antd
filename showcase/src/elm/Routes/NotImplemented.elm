module Routes.NotImplemented exposing (notImplemented)

import Html.Styled exposing (Html, div, span, text)
import UI.Footer exposing (pushDown)
import UI.Typography exposing (SubHeadingOptions(..), documentationHeading, documentationSubheading, documentationText, internalLink, link)
import Utils exposing (intoKebabCase)


notImplemented : String -> Html msg
notImplemented componentName =
    let
        antdUrl =
            "https://ant.design/components/" ++ intoKebabCase componentName
    in
    div
        []
        [ documentationHeading componentName
        , documentationText <| text <| "Unfortunately, " ++ componentName ++ " is not yet implemented. But it could be ;)"
        , documentationText <|
            span []
                [ text "Check out the contributing guide at "
                , link "https://github.com/supermacro/elm-antd#contributing" "github"
                ]
        , documentationText <|
            span []
                [ text "Don't feel like you have to implement all the functionality of Ant's "
                , link antdUrl (componentName ++ " component.")
                , text " Start small. Maybe only implement the minimal set of functionality that you need. And others can then extend off of your work :)"
                ]
        , documentationSubheading WithoutAnchorLink "Currently Implemented Components"
        , documentationText <|
            span []
                [ text "For a list of currently implemented components, check out the "
                , internalLink "/" "home page."
                ]
        , pushDown
        ]
