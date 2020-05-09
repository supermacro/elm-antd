module Routes.TooltipComponent exposing (route, Model, Msg)

import Css exposing (displayFlex)
import Html.Styled as Styled exposing (div, text, fromUnstyled)
import Html.Styled.Attributes exposing (css)

import Routes.TooltipComponent.BasicExample as BasicExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( documentationHeading
        , documentationText
        , documentationSubheading
        , documentationUnorderedList
        )

import Utils exposing (ComponentCategory(..), DocumentationRoute)


title : String
title = "Tooltip"

type alias Model =
    { basicExampleSourceCodeVisible : Bool
    , placementExampleSourceCodeVisible : Bool
    }

type DemoBox
    = BasicDemo
    | PlacementDemo


type Msg = DemoBoxMsg DemoBox Container.Msg


route : DocumentationRoute Model Msg
route =
    { title = title
    , category = DataDisplay
    , view = view
    , update = update
    , initialModel =
        { basicExampleSourceCodeVisible = False
        , placementExampleSourceCodeVisible = False
        }
    }


update : Msg -> Model -> Model
update (DemoBoxMsg demobox demoboxMsg) model =
    case demobox of
        BasicDemo ->
            let
                { sourceCodeVisible } =
                    Container.update demoboxMsg { sourceCodeVisible = model.basicExampleSourceCodeVisible }
            in
                { model | basicExampleSourceCodeVisible = sourceCodeVisible }
        PlacementDemo ->
            let
                { sourceCodeVisible } =
                    Container.update demoboxMsg { sourceCodeVisible = model.placementExampleSourceCodeVisible }
            in
                { model | placementExampleSourceCodeVisible = sourceCodeVisible }


basicExampleStr : String
basicExampleStr = """module Routes.TooltipComponent.BasicExample exposing (example)

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
basicExample { basicExampleSourceCodeVisible } =
    let
        styledTypeExampleContents =
            fromUnstyled BasicExample.example

        metaInfo = 
            { title = "Basic"
            , content = "The simplest usage."
            , ellieDemo = "https://ellie-app.com/8LbFzfR449Za1"
            , sourceCode = basicExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledTypeExampleContents ]

    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view { sourceCodeVisible = basicExampleSourceCodeVisible }
        |> Styled.map (DemoBoxMsg BasicDemo)


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
            [ div [] [ basicExample model ], div [] [ ] ]
        ]
