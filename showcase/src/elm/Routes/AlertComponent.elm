module Routes.AlertComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px, width)
import Html.Styled as Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Routes.AlertComponent.BasicExample as BasicExample
import Routes.AlertComponent.CloseableExample as CloseableExample
import Routes.AlertComponent.TypeExample as TypeExample
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
    { basicExample : Container.Model () Never
    , typeExample : Container.Model () Never
    , closeableExample : Container.Model CloseableExample.Model CloseableExample.Msg
    }


type DemoBox
    = Basic (Container.Msg Never)
    | Type (Container.Msg Never)
    | Closeable (Container.Msg CloseableExample.Msg)


type Msg
    = DemoBoxMsg DemoBox
    | SourceCopiedToClipboard DemoBox
    | ExampleSourceCodeLoaded (List SourceCode)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demobox ->
            case demobox of
                Basic demoboxMsg ->
                    let
                        ( basicExampleModel, basicExampleCmd ) =
                            Container.update (DemoBoxMsg << Basic) demoboxMsg model.basicExample
                    in
                    ( { model | basicExample = basicExampleModel }, basicExampleCmd )

                Type demoboxMsg ->
                    let
                        ( typeExampleModel, typeExampleCmd ) =
                            Container.update (DemoBoxMsg << Type) demoboxMsg model.typeExample
                    in
                    ( { model | typeExample = typeExampleModel }, typeExampleCmd )

                Closeable demoboxMsg ->
                    let
                        ( closeableExampleModel, closeableExampleCmd ) =
                            Container.update (DemoBoxMsg << Closeable) demoboxMsg model.closeableExample
                    in
                    ( { model | closeableExample = closeableExampleModel }, closeableExampleCmd )

        SourceCopiedToClipboard demobox ->
            ( model, Cmd.none )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode examplesSourceCode model.basicExample
                , typeExample = Container.setSourceCode examplesSourceCode model.typeExample
                , closeableExample = Container.setSourceCode examplesSourceCode model.closeableExample
              }
            , Cmd.none
            )


route : DocumentationRoute Model Msg
route =
    { title = "Alert"
    , category = Feedback
    , view = view
    , update = update
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    , initialModel =
        { basicExample = Container.initModel "BasicExample.elm"
        , typeExample = Container.initModel "TypeExample.elm"
        , closeableExample =
            Container.initStatefulModel "CloseableExample.elm" CloseableExample.init CloseableExample.update
        }
    }


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "The simplest usage for short messages."
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            }

        demoBox =
            Container.createDemoBox
                Basic
                model.basicExample
                (\_ -> BasicExample.example)
                metaInfo
    in
    Styled.map DemoBoxMsg demoBox


typeExample : Model -> Styled.Html Msg
typeExample model =
    let
        metaInfo =
            { title = "More Types"
            , content = "There are 4 types of Alert: Success, Info, Warning, Error"
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            }

        demoBox =
            Container.createDemoBox
                Type
                model.typeExample
                (\_ -> TypeExample.example)
                metaInfo
    in
    Styled.map DemoBoxMsg demoBox


closeableExample : Model -> Styled.Html Msg
closeableExample model =
    let
        metaInfo =
            { title = "Closeable (work in progress)"
            , content = "To show close button. Learn more about issues with the animation: https://discourse.elm-lang.org/t/fold-animation-in-elm-css/6284/3"
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            }

        demoBox =
            Container.createDemoBox
                Closeable
                model.closeableExample
                CloseableExample.view
                metaInfo
    in
    Styled.map DemoBoxMsg demoBox


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading "Alert"
        , documentationText <| text "Alert component for feedback."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "When you need to show alert messages to users."
            , text "When you need a persistent static container which is closable by user actions."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div [ css [ displayFlex ] ]
            [ div
                [ css [ width (pct 45), marginRight (px 13) ] ]
                [ basicExample model
                , closeableExample model
                ]
            , div [ css [ maxWidth (pct 45) ] ] [ typeExample model ]
            ]
        ]
