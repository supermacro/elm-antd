module Routes.ButtonComponent exposing (Model, Msg, route)

import Css exposing (displayFlex)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text)
import Html.Styled.Attributes exposing (css)
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
import Utils exposing (ComponentCategory(..), DocumentationRoute)


typeExampleStr : String
typeExampleStr =
    """module Routes.ButtonComponent.TypeExample exposing (example)

import Ant.Button as Btn exposing (button, toHtml, ButtonType(..))
import Ant.Space as Space exposing (SpaceDirection(..))
import Html exposing (Html)

horizontalSpace : List (Html msg) -> Html msg
horizontalSpace =
    Space.toHtml << Space.direction Horizontal << Space.space


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
    horizontalSpace
            [ primaryButton
            , defaultButotn
            ]

"""


type alias Model =
    { typeExample : Container.Model
    , iconExample : Container.Model
    }


type DemoBox
    = ButtonType
    | ButtonWithIcon


type Msg
    = DemoBoxMsg DemoBox Container.Msg
    | SourceCopiedToClipboard DemoBox


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

                ButtonWithIcon ->
                    let
                        ( iconExampleModel, iconExampleCmd ) =
                            Container.update demoboxMsg model.iconExample
                    in
                    ( { model | iconExample = iconExampleModel }, iconExampleCmd )

        SourceCopiedToClipboard demobox ->
            ( model, Cmd.none )


route : DocumentationRoute Model Msg
route =
    { title = "Button"
    , category = General
    , view = view
    , update = update
    , initialModel =
        { typeExample = { sourceCodeVisible = False, sourceCode = typeExampleStr }
        , iconExample = { sourceCodeVisible = False, sourceCode = "" }
        }
    }


typeExample : Model -> Styled.Html Msg
typeExample model =
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
        |> Container.view model.typeExample
        |> Styled.map (DemoBoxMsg ButtonType)


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
        , div []
            [ div [] [ typeExample model ], div [] [] ]
        ]
