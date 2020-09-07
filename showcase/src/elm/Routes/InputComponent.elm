module Routes.InputComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, maxWidth, pct)
import Html.Styled as Styled exposing (div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css)
import Routes.InputComponent.BasicExample as BasicExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)


title : String
title =
    "Input"


type alias Model =
    { basicExample : Container.Model
    }


type DemoBox
    = Basic


type Msg
    = DemoBoxMsg DemoBox Container.Msg
    | ExampleSourceCodeLoaded (List SourceCode)


route : DocumentationRoute Model Msg
route =
    { title = title
    , category = DataEntry
    , view = view
    , update = update
    , initialModel =
        { basicExample = Container.initModel "BasicExample.elm"
        }
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demoBox demoboxMsg ->
            case demoBox of
                Basic ->
                    let
                        ( basicModel, basicCmd ) =
                            Container.update demoboxMsg model.basicExample
                    in
                    ( { model | basicExample = basicModel }, basicCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode examplesSourceCode model.basicExample
              }
            , Cmd.none
            )


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "Basic usage example."
            , ellieDemo = "https://ellie-app.com/9mjyZ2xHwN9a1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg Basic)
        model.basicExample
        BasicExample.example
        metaInfo


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading title
        , documentationText <| text "A basic widget for getting the user input is a text field. Keyboard and mouse can be used for providing or changing data."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "A user input in a form field is needed."
            , text "A search input is required."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div []
            [ div [ css [ maxWidth (pct 45) ] ] [ basicExample model ]
            , div [] []
            ]
        ]
