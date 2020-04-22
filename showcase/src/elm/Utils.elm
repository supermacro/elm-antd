module Utils exposing ( ComponentCategory(..), DocumentationRoute )

import Html.Styled as Styled

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
    , view : msg -> Styled.Html msg
    }
