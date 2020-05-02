module Routes.ButtonComponent exposing (route, Model, Msg)

import Ant.Typography.Text as Text
import Css exposing (displayFlex)
import Html.Styled as Styled exposing (div, span, text, fromUnstyled)
import Html.Styled.Attributes exposing (css)
import Routes.ButtonComponent.TypeExample as TypeExample
import UI.Container as Container
import UI.Typography
    exposing
        ( documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute)



typeExampleStr : String
typeExampleStr = """module Routes.ButtonComponent.TypeExample exposing (example)

import Ant.Button as Btn exposing (button, toHtml, ButtonType(..))
import Ant.Space as Space
import Html exposing (Html)

example : Html msg
example =
    let
        primaryButton =
            button "Primary"
            |> Btn.withType Primary
            |> toHtml

        defaultButotn =
            button "Default"
            |> Btn.withType Default
            |> toHtml
    
    in
    Space.toHtml <|
        Space.space
            [ primaryButton
            , defaultButotn
            ]
"""


type alias Model =
    { typeExampleSourceCodeVisible : Bool
    , iconExampleSourceCodeVisible : Bool
    }


type DemoBox
    = ButtonType
    | ButtonWithIcon


type Msg = DemoBoxMsg DemoBox Container.Msg

update : Msg -> Model -> Model
update (DemoBoxMsg demobox demoboxMsg) model =
    case demobox of
        ButtonType ->
            let
                { sourceCodeVisible } =
                    Container.update demoboxMsg { sourceCodeVisible = model.typeExampleSourceCodeVisible }
            in
                { model | typeExampleSourceCodeVisible = sourceCodeVisible }
        ButtonWithIcon ->
            let
                { sourceCodeVisible } =
                    Container.update demoboxMsg { sourceCodeVisible = model.iconExampleSourceCodeVisible }
            in
                { model | iconExampleSourceCodeVisible = sourceCodeVisible }


route : DocumentationRoute Model Msg
route =
    { title = "Button"
    , category = General
    , view = view
    , update = update
    , initialModel =
        { typeExampleSourceCodeVisible = False
        , iconExampleSourceCodeVisible = False
        }
    }


codeText : String -> Styled.Html msg
codeText value =
    Text.text value
        |> Text.code
        |> Text.toHtml
        |> fromUnstyled


typeExample : Model -> Styled.Html Msg
typeExample { typeExampleSourceCodeVisible } =
    let
        styledTypeExampleContents =
            fromUnstyled TypeExample.example

        metaInfo = 
            { title = "Type"
            , content = "There are \"primary\", \"default\", \"dashed\" and \"link\" buttons in Elm Antd."
            , ellieDemo = "https://ellie-app.com/8LbFzfR449Za1"
            , sourceCode = typeExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledTypeExampleContents ]

    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view { sourceCodeVisible = typeExampleSourceCodeVisible }
        |> Styled.map (DemoBoxMsg ButtonType)



view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading "Button"
        , documentationText <| text "To trigger an operation."
        , documentationSubheading "When To Use" True
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
        , documentationSubheading "Examples" False
        , div []
            [ div [] [ typeExample model ], div [] [ ] ]
        ]
