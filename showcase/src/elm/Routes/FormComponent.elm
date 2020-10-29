module Routes.FormComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px, width)
import Html.Styled as Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Routes.FormComponent.BasicExample as BasicExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( codeText
        , documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)


type alias Model =
    { basicExample : Container.Model BasicExample.Model BasicExample.Msg
    }


type DemoBox
    = BasicExample (Container.Msg BasicExample.Msg)


type Msg
    = DemoBoxMsg DemoBox
    | ExampleSourceCodeLoaded (List SourceCode)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demoboxMsg ->
            case demoboxMsg of
                BasicExample basicExampleMsg ->
                    let
                        ( newSimpleExampleModel, simpleExampleCmd ) =
                            Container.update (DemoBoxMsg << BasicExample) basicExampleMsg model.basicExample
                    in
                    ( { model | basicExample = newSimpleExampleModel }, simpleExampleCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode examplesSourceCode model.basicExample
              }
            , Cmd.none
            )


route : DocumentationRoute Model Msg
route =
    { title = "Form"
    , category = DataEntry
    , view = view
    , update = update
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    , initialModel =
        { basicExample =
            Container.initStatefulModel "BasicExample.elm" BasicExample.init BasicExample.update
        }
    }


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "Basic usage of checkbox."
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << BasicExample)
        model.basicExample
        BasicExample.example
        metaInfo


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading "Form"
        , documentationText <| text "Composable form component that is built on top of a fork of the excellent 'hecrj/composable-form' library. If you're familiar with composable-form already, then you'll feel right at home!"
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "When building Forms of any size; whether they include only a single input, or several inputs that are dependent on each other."
            , text "When you need to validate fields in certain rules."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div [ css [ displayFlex ] ]
            [ div [ css [ width (pct 100) ] ]
                [ basicExample model
                ]
            ]
        ]
