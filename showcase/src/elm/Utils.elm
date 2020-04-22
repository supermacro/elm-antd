module Utils exposing ( ComponentCategory(..), DocumentationRoute, createRoute )

import Html exposing (Html)

type ComponentCategory
    = General
    | Layout
    | Navigation
    | DataEntry
    | DataDisplay
    | Feedback
    | Other


type alias RouteTitle = String

type alias DocumentationRoute msg =
    { title : RouteTitle
    , category : ComponentCategory
    , view : msg -> Html msg
    }

createRoute :
    { title : RouteTitle
    , category : ComponentCategory
    , view : msg -> Html msg
    }
    -> DocumentationRoute msg
createRoute { title, category, view } = DocumentationRoute title category view
