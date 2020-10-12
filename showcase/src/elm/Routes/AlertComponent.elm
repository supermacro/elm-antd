module Routes.AlertComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px, width)
import Html.Styled as Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Routes.AlertComponent.BasicExample as BasicExample
import Routes.AlertComponent.CloseableExample as CloseableExample
import Routes.AlertComponent.DescriptionExample as DescriptionExample
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
    , descriptionExample : Container.Model () Never
    , typeExample : Container.Model () Never
    , closeableExample : Container.Model CloseableExample.Model CloseableExample.Msg
    }


type DemoBox
    = Basic (Container.Msg Never)
    | Type (Container.Msg Never)
    | Description (Container.Msg Never)
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

                Description demoboxMsg ->
                    let
                        ( descriptionExampleModel, descriptionExampleCmd ) =
                            Container.update (DemoBoxMsg << Description) demoboxMsg model.descriptionExample
                    in
                    ( { model | descriptionExample = descriptionExampleModel }, descriptionExampleCmd )

        SourceCopiedToClipboard demobox ->
            ( model, Cmd.none )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode examplesSourceCode model.basicExample
                , typeExample = Container.setSourceCode examplesSourceCode model.typeExample
                , closeableExample = Container.setSourceCode examplesSourceCode model.closeableExample
                , descriptionExample = Container.setSourceCode examplesSourceCode model.descriptionExample
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
        , descriptionExample = Container.initModel "DescriptionExample.elm"
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


descriptionExample : Model -> Styled.Html Msg
descriptionExample model =
    let
        metaInfo =
            { title = "Description"
            , content = "Additional description for alert message."
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            }

        demoBox =
            Container.createDemoBox
                Description
                model.typeExample
                (\_ -> DescriptionExample.example)
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
                ]
            , div
                [ css [ maxWidth (pct 45) ] ]
                [ typeExample model, descriptionExample model ]
            ]
        ]
