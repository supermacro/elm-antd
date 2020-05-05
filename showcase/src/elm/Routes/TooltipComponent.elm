module Routes.TooltipComponent exposing (route, Model)

import Html.Styled as Styled exposing (div, span, text, fromUnstyled)

import UI.Typography exposing
        ( documentationHeading
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
        [ documentationHeading title ]
        