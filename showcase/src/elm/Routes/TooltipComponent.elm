module Routes.TooltipComponent exposing (route, Model)

import Html.Styled as Styled exposing (div, text)

import UI.Typography as Typography
    exposing
        ( documentationHeading
        , documentationText
        , documentationSubheading
        )

import Utils exposing (ComponentCategory(..), DocumentationRoute)


title : String
title = "Tooltip"

type alias Model = ()


route : DocumentationRoute Model Never
route =
    { title = title
    , category = DataDisplay
    , view = view
    , update = \_ m -> m
    , initialModel = ()
    }

view : Model -> Styled.Html Never
view _ =
    div []
        [ documentationHeading title
        , documentationText <| text "A simple text popup tip."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        ]
        