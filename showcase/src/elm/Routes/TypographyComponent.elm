module Routes.TypographyComponent exposing (Model, Msg, route)

import Ant.Typography.Text as Text exposing (text)
import Css exposing (displayFlex)
import Html.Styled as Styled exposing (br, div, fromUnstyled)
import Html.Styled.Attributes exposing (css)
import Routes.TypographyComponent.BasicExample as BasicExample
import Routes.TypographyComponent.TextExample as TextExample
import Routes.TypographyComponent.TitleComponent as TitleComponentExample
import UI.Container as Container
import UI.Typography exposing (SubHeadingOptions(..), documentationHeading, documentationSubheading, documentationText, documentationUnorderedList)
import Utils exposing (ComponentCategory(..), DocumentationRoute)


type alias Model =
    { basicExample : Container.Model Never ()
    , titleExample : Container.Model Never ()
    , textExample : Container.Model Never ()
    }


route : DocumentationRoute Model Msg
route =
    { title = "Typography"
    , category = General
    , view = view
    , initialModel =
        { basicExample = Container.simpleModel { sourceCodeVisible = False, sourceCode = basicExampleStr }
        , titleExample = Container.simpleModel { sourceCodeVisible = False, sourceCode = titleComponentStr }
        , textExample = Container.simpleModel { sourceCodeVisible = False, sourceCode = texComponentStr }
        }
    , update = update
    }


type DemoBox
    = Basic
    | TitleComponent
    | TextComponent


type Msg
    = DemoBoxMsg DemoBox (Container.Msg Never)


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


basicExampleStr : String
basicExampleStr =
    """module Routes.TypographyComponent.BasicExample exposing (example)

import Ant.Typography as Typography exposing (title, Level(..))
import Ant.Typography.Text as Text exposing (text, Text)
import Ant.Typography.Paragraph exposing (paragraph)
import Html exposing (Html, div, ul, li)


codeText : String -> Text
codeText =
    Text.code << text

example : Html msg
example =
    div []
        [ title "Introduction" |> Typography.toHtml
        , paragraph
            [ text "In the process of internal desktop applications development, many different ..."
                |> Text.toHtml
            ]
        , paragraph
            [ text "After massive project practice and summaries, Ant Design, a design language for background applications, ..."
                |> Text.toHtml
            , text "uniform the user interface specs for internal background projects, lower the unnecessary cost of ..."
                |> Text.strong
                |> Text.toHtml
            ]
        , title "Guidelines and Resources"
            |> Typography.level H2
            |> Typography.toHtml
        , paragraph
            [ text "We supply a series of design principles, practical patterns and high quality design resources "
                |> Text.toHtml
            , [ text "(", codeText "Sketch", text "and", codeText "Axure", text ")" ]
                |> Text.listToHtml
            , text ", to help people create their product prototypes beautifully and efficiently."
                |> Text.toHtml
            ]
        ]
"""


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        styledBasicExampleContents =
            fromUnstyled BasicExample.example

        metaInfo =
            { title = "Basic"
            , content = "A document sample"
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = basicExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledBasicExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.basicExample
        |> Styled.map (DemoBoxMsg Basic)


titleComponentStr : String
titleComponentStr =
    """module Routes.TypographyComponent.TitleComponent exposing (example)

import Ant.Typography as Typography exposing (title, Level(..))
import Html exposing (Html, div)


example : Html msg
example =
    div []
        <| List.map Typography.toHtml
            [ title "h1. Ant Design"
            , title "h2. Ant Design"
                |> Typography.level H2
            , title "h3. Ant Design"
                |> Typography.level H3
            , title "h4. Ant Design"
                |> Typography.level H4
            ]

"""


titleComponentExample : Model -> Styled.Html Msg
titleComponentExample model =
    let
        styledTitleExampleContents =
            fromUnstyled TitleComponentExample.example

        metaInfo =
            { title = "Title Component"
            , content = "Display the various levels for titles"
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = titleComponentStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledTitleExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.titleExample
        |> Styled.map (DemoBoxMsg TitleComponent)


texComponentStr : String
texComponentStr =
    """module Routes.TypographyComponent.TextExample exposing (example)

import Ant.Typography.Text as Text exposing (text, TextType(..))
import Ant.Space as Space exposing (space)
import Html exposing (Html)


verticalAlign : List (Html msg) -> Html msg
verticalAlign =
    Space.toHtml << space

example : Html msg
example =
    verticalAlign <| List.map Text.toHtml
        [ text "Ant Design"
        , text "Ant Design"
            |> Text.textType Secondary
        , text "Ant Design"
            |> Text.textType Warning
        , text "Ant Design"
            |> Text.textType Danger
        ]

"""


textComponentExample : Model -> Styled.Html Msg
textComponentExample model =
    let
        styledTextExampleContents =
            fromUnstyled TextExample.example

        metaInfo =
            { title = "Text and Link Component"
            , content = "Provides multiple types of text and link."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = texComponentStr
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
