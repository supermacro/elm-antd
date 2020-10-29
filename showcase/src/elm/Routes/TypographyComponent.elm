module Routes.TypographyComponent exposing (Model, Msg, route)

import Ant.Typography.Text exposing (text)
import Css exposing (displayFlex)
import Html.Styled as Styled exposing (br, div, fromUnstyled)
import Html.Styled.Attributes exposing (css)
import Routes.TypographyComponent.BasicExample as BasicExample
import Routes.TypographyComponent.TextExample as TextExample
import Routes.TypographyComponent.TitleComponent as TitleExample
import UI.Container as Container
import UI.Typography exposing (SubHeadingOptions(..), documentationHeading, documentationSubheading, documentationText, documentationUnorderedList)
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)


type alias StatelessDemo =
    Container.Model () Never


type alias Model =
    { basicExample : StatelessDemo
    , titleExample : StatelessDemo
    , textExample : StatelessDemo
    , version : String
    }


route : DocumentationRoute Model Msg
route =
    { title = "Typography"
    , category = General
    , view = view
    , initialModel =
        \v ->
            { basicExample = Container.initModel "BasicExample.elm"
            , titleExample = Container.initModel "TextExample.elm"
            , textExample = Container.initModel "TitleComponent.elm"
            , version = v
            }
    , update = update
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    }


type DemoBox
    = Basic
    | TitleComponent
    | TextComponent


type Msg
    = DemoBoxMsg DemoBox (Container.Msg Never)
    | ExampleSourceCodeLoaded (List SourceCode)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demobox demoboxMsg ->
            case demobox of
                Basic ->
                    let
                        ( basicExampleModel, basicExampleCmd ) =
                            Container.update (DemoBoxMsg Basic) demoboxMsg model.basicExample
                    in
                    ( { model | basicExample = basicExampleModel }, basicExampleCmd )

                TitleComponent ->
                    let
                        ( titleExampleModel, titleExampleCmd ) =
                            Container.update (DemoBoxMsg TitleComponent) demoboxMsg model.titleExample
                    in
                    ( { model | titleExample = titleExampleModel }, titleExampleCmd )

                TextComponent ->
                    let
                        ( textExampleModel, textExampleCmd ) =
                            Container.update (DemoBoxMsg TextComponent) demoboxMsg model.textExample
                    in
                    ( { model | textExample = textExampleModel }, textExampleCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode model.version examplesSourceCode model.basicExample
                , textExample = Container.setSourceCode model.version examplesSourceCode model.textExample
                , titleExample = Container.setSourceCode model.version examplesSourceCode model.titleExample
              }
            , Cmd.none
            )


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "A document sample"
            , ellieDemo = "https://ellie-app.com/9mHk3JkJXSza1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg Basic)
        model.basicExample
        (\_ -> BasicExample.example)
        metaInfo


titleComponentExample : Model -> Styled.Html Msg
titleComponentExample model =
    let
        metaInfo =
            { title = "Title Component"
            , content = "Display the various levels for titles"
            , ellieDemo = "https://ellie-app.com/9mHmQ7FdJsSa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg TitleComponent)
        model.titleExample
        (\_ -> TitleExample.example)
        metaInfo


textComponentExample : Model -> Styled.Html Msg
textComponentExample model =
    let
        metaInfo =
            { title = "Text and Link Component"
            , content = "Provides multiple types of text and link."
            , ellieDemo = "https://ellie-app.com/9mHyDsVVZk6a1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg TextComponent)
        model.textExample
        (\_ -> TextExample.example)
        metaInfo


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading "Typography"
        , documentationText <| Styled.text "Basic text writing, including headings, body text, lists, and more."
        , documentationSubheading WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ Styled.text "When you need to display a title or paragraph contents in Articles/Blogs/Notes."
            , Styled.text "When you need copyable/editable/ellipsis texts."
            ]
        , documentationSubheading WithoutAnchorLink "Examples"
        , basicExample model
        , titleComponentExample model
        , textComponentExample model
        ]
