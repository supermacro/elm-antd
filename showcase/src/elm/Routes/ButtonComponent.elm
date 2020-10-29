module Routes.ButtonComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html as H
import Html.Styled as Styled exposing (div, span, text)
import Html.Styled.Attributes exposing (css)
import Routes.ButtonComponent.DisabledExample as DisabledExample
import Routes.ButtonComponent.IconExample as IconExample
import Routes.ButtonComponent.TypeExample as TypeExample
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
    { typeExample : Container.Model () Never
    , disabledExample : Container.Model () DisabledExample.Msg
    , iconExample : Container.Model () IconExample.Msg
    , version : String 
    }


type DemoBox
    = ButtonType (Container.Msg Never)
    | DisabledButton (Container.Msg DisabledExample.Msg)
    | IconButton (Container.Msg IconExample.Msg)


type Msg
    = DemoBoxMsg DemoBox
    | ExampleSourceCodeLoaded (List SourceCode)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demobox ->
            case demobox of
                ButtonType demoboxMsg ->
                    let
                        ( typeExampleModel, typeExampleCmd ) =
                            Container.update (DemoBoxMsg << ButtonType) demoboxMsg model.typeExample
                    in
                    ( { model | typeExample = typeExampleModel }, typeExampleCmd )

                DisabledButton demoboxMsg ->
                    let
                        ( disabledExampleModel, disabledExampleCmd ) =
                            Container.update (DemoBoxMsg << DisabledButton) demoboxMsg model.disabledExample
                    in
                    ( { model | disabledExample = disabledExampleModel }, disabledExampleCmd )

                IconButton demoboxMsg ->
                    let
                        ( iconExampleModel, iconExampleCmd ) =
                            Container.update (DemoBoxMsg << IconButton) demoboxMsg model.iconExample
                    in
                    ( { model | iconExample = iconExampleModel }, iconExampleCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | typeExample = Container.setSourceCode model.version examplesSourceCode model.typeExample
                , disabledExample = Container.setSourceCode model.version examplesSourceCode model.disabledExample
                , iconExample = Container.setSourceCode model.version examplesSourceCode model.iconExample
              }
            , Cmd.none
            )


route : DocumentationRoute Model Msg
route =
    { title = "Button"
    , category = General
    , view = view
    , update = update
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    , initialModel =
        \v -> { typeExample = Container.initModel "TypeExample.elm"
        , iconExample =
            Container.initStatefulModel
                "IconExample.elm"
                ()
                (\_ _ -> ( (), Cmd.none ))
        , disabledExample =
            Container.initStatefulModel
                "DisabledExample.elm"
                ()
                (\_ _ -> ( (), Cmd.none ))
            , version = v
        }
    }


typeExample : Model -> Styled.Html Msg
typeExample model =
    let
        metaInfo =
            { title = "Type"
            , content = "There are \"primary\", \"default\", \"dashed\", \"text\" and \"link\" buttons in Elm Antd."
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << ButtonType)
        model.typeExample
        (\_ -> TypeExample.example)
        metaInfo


disabledExample : Model -> Styled.Html Msg
disabledExample model =
    let
        metaInfo =
            { title = "Disabled"
            , content = "You can disable any button"
            , ellieDemo = "https://ellie-app.com/9mjF8c8DLyTa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << DisabledButton)
        model.disabledExample
        (\_ -> DisabledExample.example)
        metaInfo


iconExample : Model -> Styled.Html Msg
iconExample model =
    let
        metaInfo =
            { title = "Icon"
            , content = "Button components can contain an Icon"
            , ellieDemo = "https://ellie-app.com/9mjF8c8DLyTa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << IconButton)
        model.iconExample
        (\_ -> IconExample.example)
        metaInfo


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading "Button"
        , documentationText <| text "To trigger an operation."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationText <| text "A button means an operation (or a series of operations). Clicking a button will trigger corresponding business logic."
        , documentationText <| text "In Ant Design we provide 4 types of button."
        , documentationUnorderedList
            [ text "Primary button: indicate the main action, one primary button at most in one section."
            , text "Default button: indicate a series of actions without priority."
            , text "Dashed button: used for adding action commonly."
            ]
        , documentationText <| text "And 4 other properties additionally."
        , documentationUnorderedList
            [ span []
                [ codeText "danger"
                , text ": used for actions of risk, like deletion or authorization."
                ]
            , span []
                [ codeText "ghost"
                , text ": used in situations with complex background, home pages usually."
                ]
            , span []
                [ codeText "disabled"
                , text ": when actions are not available."
                ]
            , span []
                [ codeText "loading"
                , text ": add loading spinner in button, avoiding multiple submits too."
                ]
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div [ css [ displayFlex ] ]
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ] [ typeExample model ]
            , div [ css [ maxWidth (pct 45) ] ]
                [ iconExample model
                , disabledExample model
                ]
            ]
        ]
