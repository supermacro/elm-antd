module Routes.Home exposing (homePage)

{-| This module represents the Home / Landing page content when a user visits the root path of the URL
-}

import Html.Styled exposing (Html, div, span, text)
import UI.Footer exposing (pushDown)
import UI.Typography exposing (SubHeadingOptions(..), codeText, documentationHeading, documentationSubheading, documentationText, documentationUnorderedList, internalLink, link)


homePage : Html msg
homePage =
    div
        []
        [ documentationHeading "Elm Ant Design"
        , documentationText <| text "Welcome to the home of ambitious Elm applications!"
        , documentationSubheading WithoutAnchorLink "Getting started"
        , documentationText <| codeText "elm install supermacro/elm-antd"
        , documentationSubheading WithoutAnchorLink "API Docs"
        , link "https://package.elm-lang.org/packages/supermacro/elm-antd/latest/" "package.elm-lange.org"
        , documentationSubheading WithoutAnchorLink "Currently Implemented Components"
        , documentationUnorderedList
            [ internalLink "/components/button" "Button"
            , internalLink "/components/tooltip" "Tooltip"
            , internalLink "/components/typography" "Typography"
            , link "https://github.com/supermacro/elm-antd/issues/26" "Icon"
            , link "https://github.com/supermacro/elm-antd/issues/23" "Layout"
            , link "https://github.com/supermacro/elm-antd/issues/25" "Menu"
            , link "https://github.com/supermacro/elm-antd/issues/24" "Space"
            ]
        , documentationSubheading WithoutAnchorLink "Early Development Notice"
        , documentationText <| text "Currently Elm Antd is in very early development with only a few components implemented, and bare-bones documentation."
        , documentationText <| text "Do you want to help out and make Elm Ant Design the most comprehensive and feature-full UI library in the universe?"
        , documentationText <|
            span []
                [ text "Great! Check out the issues page and the contributing guide at "
                , link "https://github.com/supermacro/elm-antd#contributing" "github"
                ]
        , pushDown
        ]
