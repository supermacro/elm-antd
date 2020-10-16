module Routes.CheckboxComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html.Styled as Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Routes.CheckboxComponent.BasicExample as BasicExample
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
        DemoBoxMsg (BasicExample demoBoxMsg) ->
            let
                ( newSimpleExampleModel, simpleExampleCmd ) =
                    Container.update (DemoBoxMsg << BasicExample) demoBoxMsg model.basicExample
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
    { title = "Checkbox"
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
        [ documentationHeading "Checkbox"
        , documentationText <| text "Checkbox component."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "Used for selecting multiple values from several options."
            , text "If you use only one checkbox, it is the same as using Switch to toggle between two states. The difference is that Switch will trigger the state change directly, but Checkbox just marks the state as changed and this needs to be submitted."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div [ css [ displayFlex ] ]
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ] [ basicExample model ]
            , div [ css [ maxWidth (pct 45) ] ]
                []
            ]
        ]
