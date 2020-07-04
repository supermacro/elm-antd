module Routes.NotFound exposing (notFound)

{-| The 404 page
-}

import Html.Styled exposing (Html, div, text)
import UI.Typography exposing (documentationHeading, documentationText, documentationSubheading, SubHeadingOptions(..))
import UI.Footer exposing (pushDown)

notFound : Html msg
notFound =
    div
        []
        [ documentationHeading "Not Found"
        , documentationText <| text "Were you looking for something else?"
        , documentationSubheading WithoutAnchorLink "Early Development Notice"
        , documentationText <| text "Currently Elm Antd is in very early development with only a few components implemented, and bare-bones documentation."
        , documentationText <| text "Do you want to help out and make Elm Ant Design the most comprehensive and feature-full UI library in the universe?"
        , documentationText <| text "Great! Check out the issues page and the contributing guide at https://github.com/supermacro/elm-antd#contributing"
        , pushDown
        ]

