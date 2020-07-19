module Routes.TypographyComponent exposing (Model, Msg, route)

import Ant.Typography.Text exposing (text)
import Css exposing (displayFlex)
import Html.Styled as Styled exposing (br, div, fromUnstyled)
import Html.Styled.Attributes exposing (css)
import Routes.TypographyComponent.BasicExample as BasicExample
import Routes.TypographyComponent.TextExample as TextExample
import Routes.TypographyComponent.TitleComponent as TitleComponentExample
import UI.Container as Container
import UI.Typography exposing (SubHeadingOptions(..), documentationHeading, documentationSubheading, documentationText, documentationUnorderedList)
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)


type alias Model =
    { basicExample : Container.Model
    , titleExample : Container.Model
    , textExample : Container.Model
    }


route : DocumentationRoute Model Msg
route =
    { title = "Typography"
    , category = General
    , view = view
    , initialModel =
        { basicExample = Container.initModel "BasicExample.elm"
        , titleExample = Container.initModel "TextExample.elm"
        , textExample = Container.initModel "TitleComponent.elm"
        }
    , update = update
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    }


type DemoBox
    = Basic
    | TitleComponent
    | TextComponent


type Msg
    = DemoBoxMsg DemoBox Container.Msg
    | ExampleSourceCodeLoaded (List SourceCode)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DemoBoxMsg demobox demoboxMsg ->
            case demobox of
                Basic ->
                    let
                        ( basicExampleModel, basicExampleCmd ) =
                            Container.update demoboxMsg model.basicExample
                    in
                    ( { model | basicExample = basicExampleModel }, basicExampleCmd )

                TitleComponent ->
                    let
                        ( titleExampleModel, titleExampleCmd ) =
                            Container.update demoboxMsg model.titleExample
                    in
                    ( { model | titleExample = titleExampleModel }, titleExampleCmd )

                TextComponent ->
                    let
                        ( textExampleModel, textExampleCmd ) =
                            Container.update demoboxMsg model.textExample
                    in
                    ( { model | textExample = textExampleModel }, textExampleCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model |
                    basicExample = Container.setSourceCode examplesSourceCode model.basicExample
                ,   textExample = Container.setSourceCode examplesSourceCode model.textExample
                ,   titleExample = Container.setSourceCode examplesSourceCode model.titleExample
              }
            , Cmd.none
            )





basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        styledBasicExampleContents =
            fromUnstyled BasicExample.example

        metaInfo =
            { title = "Basic"
            , content = "A document sample"
            , ellieDemo = "https://ellie-app.com/9mHk3JkJXSza1"
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledBasicExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.basicExample
        |> Styled.map (DemoBoxMsg Basic)



titleComponentExample : Model -> Styled.Html Msg
titleComponentExample model =
    let
        styledTitleExampleContents =
            fromUnstyled TitleComponentExample.example

        metaInfo =
            { title = "Title Component"
            , content = "Display the various levels for titles"
            , ellieDemo = "https://ellie-app.com/9mHmQ7FdJsSa1"
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledTitleExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.titleExample
        |> Styled.map (DemoBoxMsg TitleComponent)



textComponentExample : Model -> Styled.Html Msg
textComponentExample model =
    let
        styledTextExampleContents =
            fromUnstyled TextExample.example

        metaInfo =
            { title = "Text and Link Component"
            , content = "Provides multiple types of text and link."
            , ellieDemo = "https://ellie-app.com/9mHyDsVVZk6a1"
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledTextExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.textExample
        |> Styled.map (DemoBoxMsg TextComponent)


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
