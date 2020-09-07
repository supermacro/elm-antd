module Routes.ButtonComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html as H
import Html.Styled as Styled exposing (div, fromUnstyled, span, text)
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
    { typeExample : Container.Model
    , disabledExample : Container.Model
    , iconExample : Container.Model
    }


type DemoBox
    = ButtonType
    | DisabledButton
    | IconButton


type Msg
    = DemoBoxMsg DemoBox Container.Msg
    | SourceCopiedToClipboard DemoBox
    | ExampleSourceCodeLoaded (List SourceCode)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DemoBoxMsg demobox demoboxMsg ->
            case demobox of
                ButtonType ->
                    let
                        ( typeExampleModel, typeExampleCmd ) =
                            Container.update demoboxMsg model.typeExample
                    in
                    ( { model | typeExample = typeExampleModel }, typeExampleCmd )

                DisabledButton ->
                    let
                        ( disabledExampleModel, disabledExampleCmd ) =
                            Container.update demoboxMsg model.disabledExample
                    in
                    ( { model | disabledExample = disabledExampleModel }, disabledExampleCmd )

                IconButton ->
                    let
                        ( iconExampleModel, iconExampleCmd ) =
                            Container.update demoboxMsg model.iconExample
                    in
                    ( { model | iconExample = iconExampleModel }, iconExampleCmd )

        SourceCopiedToClipboard demobox ->
            ( model, Cmd.none )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | typeExample = Container.setSourceCode examplesSourceCode model.typeExample
                , disabledExample = Container.setSourceCode examplesSourceCode model.disabledExample
                , iconExample = Container.setSourceCode examplesSourceCode model.iconExample
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
        { typeExample = Container.initModel "TypeExample.elm"
        , disabledExample = Container.initModel "DisabledExample.elm"
        , iconExample = Container.initModel "IconExample.elm"
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
        (DemoBoxMsg ButtonType)
        model.typeExample
        TypeExample.example
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
        (DemoBoxMsg DisabledButton)
        model.disabledExample
        DisabledExample.example
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
        (DemoBoxMsg IconButton)
        model.iconExample
        IconExample.example
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
