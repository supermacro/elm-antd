module Routes.Home exposing (homePage)

{-| This module represents the Home / Landing page content when a user visits the root path of the URL
-}

import Html.Styled exposing (Html, div, text)
import UI.Footer exposing (pushDown)
import UI.Typography exposing (SubHeadingOptions(..), codeText, documentationHeading, documentationSubheading, documentationText)


homePage : Html msg
homePage =
    div
        []
        [ documentationHeading "Elm Ant Design"
        , documentationText <| text "Welcome to the home of ambitious Elm applications!"
        , documentationSubheading WithoutAnchorLink "Getting started"
        , documentationText <| codeText "elm install supermacro/elm-antd"
        , documentationSubheading WithoutAnchorLink "Early Development Notice"
        , documentationText <| text "Currently Elm Antd is in very early development with only a few components implemented, and bare-bones documentation."
        , documentationText <| text "Do you want to help out and make Elm Ant Design the most comprehensive and feature-full UI library in the universe?"
        , documentationText <| text "Great! Check out the issues page and the contributing guide at https://github.com/supermacro/elm-antd#contributing"
        , pushDown
        ]
