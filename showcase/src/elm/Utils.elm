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

type alias DocumentationRoute model msg =
    { title : RouteTitle
    , update : msg -> model -> model
    , category : ComponentCategory
    , view : model -> Styled.Html msg
    , initialModel : model
    }
