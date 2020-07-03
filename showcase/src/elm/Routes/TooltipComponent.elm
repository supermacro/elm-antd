module Routes.TooltipComponent exposing (Model, Msg, route)

import Css exposing (displayFlex)
import Html.Styled as Styled exposing (div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css)
import Routes.TooltipComponent.BasicExample as BasicExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute)


title : String
title =
    "Tooltip"


type alias Model =
    { basicExample : Container.Model
    , placementExample : Container.Model
    }


type DemoBox
    = Basic
    | Placement


type Msg
    = DemoBoxMsg DemoBox Container.Msg


route : DocumentationRoute Model Msg
route =
    { title = title
    , category = DataDisplay
    , view = view
    , update = update
    , initialModel =
        { basicExample = { sourceCodeVisible = False, sourceCode = basicExampleStr }
        , placementExample = { sourceCodeVisible = False, sourceCode = "" }
        }
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update (DemoBoxMsg demobox demoboxMsg) model =
    case demobox of
        Basic ->
            let
                ( basicModel, basicCmd ) =
                    Container.update demoboxMsg model.basicExample
            in
            ( { model | basicExample = basicModel }, basicCmd )

        Placement ->
            let
                ( placementModel, placementCmd ) =
                    Container.update demoboxMsg model.placementExample
            in
            ( { model | placementExample = placementModel }, placementCmd )


basicExampleStr : String
basicExampleStr =
    """module Routes.TooltipComponent.BasicExample exposing (example)

import Ant.Tooltip as Tooltip exposing (tooltip)
import Ant.Typography.Text as Text
import Html exposing (Html, text)

example : Html msg
example =
    Text.text "Tooltip will show on mouse enter."
    |> Text.toHtml
    |> tooltip "prompt text"
    |> Tooltip.toHtml

"""


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        styledTypeExampleContents =
            fromUnstyled BasicExample.example

        metaInfo =
            { title = "Basic"
            , content = "The simplest usage."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = basicExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledTypeExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.basicExample
        |> Styled.map (DemoBoxMsg Basic)


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading title
        , documentationText <| text "A simple text popup tip."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "The tip is shown on mouse enter, and is hidden on mouse leave. The Tooltip doesn't support complex text or operations."
            , text "To provide an explanation of a button/text/operation. It's often used instead of the html title attribute."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div []
            [ div [] [ basicExample model ], div [] [] ]
        ]
