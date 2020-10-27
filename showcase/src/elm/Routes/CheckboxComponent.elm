module Routes.CheckboxComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html.Styled as Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Routes.CheckboxComponent.BasicExample as BasicExample
import Routes.CheckboxComponent.ControlledExample as ControlledExample
import Routes.CheckboxComponent.DisabledExample as DisabledExample
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
    , disabledExample : Container.Model () Never
    , controlledExample : Container.Model ControlledExample.Model ControlledExample.Msg
    , version : String 
    }


type DemoBox
    = BasicExample (Container.Msg BasicExample.Msg)
    | DisabledExample (Container.Msg Never)
    | ControlledExample (Container.Msg ControlledExample.Msg)


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

                ControlledExample controlledExampleMsg ->
                    let
                        ( newControlledExampleModel, controlledExampleCmd ) =
                            Container.update (DemoBoxMsg << ControlledExample) controlledExampleMsg model.controlledExample
                    in
                    ( { model | controlledExample = newControlledExampleModel }, controlledExampleCmd )

                DisabledExample disabledExampleMsg ->
                    let
                        ( newDisabledExampleModel, disabledExampleCmd ) =
                            Container.update (DemoBoxMsg << DisabledExample) disabledExampleMsg model.disabledExample
                    in
                    ( { model | disabledExample = newDisabledExampleModel }, disabledExampleCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode model.version examplesSourceCode model.basicExample
                , disabledExample = Container.setSourceCode model.version examplesSourceCode model.disabledExample
                , controlledExample = Container.setSourceCode model.version examplesSourceCode model.controlledExample
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
        \v -> { basicExample =
            Container.initStatefulModel "BasicExample.elm" BasicExample.init BasicExample.update
        , controlledExample =
            Container.initStatefulModel "ControlledExample.elm" ControlledExample.init ControlledExample.update
        , disabledExample =
            Container.initModel "DisabledExample.elm"
            , version = v
        }
    }


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "Basic usage of checkbox."
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            , version = model.version
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << BasicExample)
        model.basicExample
        BasicExample.example
        metaInfo


controlledExample : Model -> Styled.Html Msg
controlledExample model =
    let
        metaInfo =
            { title = "Controlled Checkbox"
            , content = "Communicated with other components."
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            , version = model.version
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << ControlledExample)
        model.controlledExample
        ControlledExample.example
        metaInfo


disabledExample : Model -> Styled.Html Msg
disabledExample model =
    let
        metaInfo =
            { title = "Disabled"
            , content = "Disabled checkbox."
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            , version = model.version
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << DisabledExample)
        model.disabledExample
        (\_ -> DisabledExample.example)
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
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ]
                [ basicExample model
                , controlledExample model
                ]
            , div [ css [ maxWidth (pct 45) ] ]
                [ disabledExample model ]
            ]
        ]
