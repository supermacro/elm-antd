module Routes.ButtonComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text)
import Html.Styled.Attributes exposing (css)
import Routes.ButtonComponent.DisabledExample as DisabledExample
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

import Ant.Button as Btn exposing (ButtonType(..), button, toHtml)
import Ant.Space as Space exposing (SpaceDirection(..))
import Html exposing (Html, div, span)
import Html.Attributes exposing (style)


withSpace : Html msg -> Html msg
withSpace element =
    span
        [ style "margin-bottom" "13px"
        , style "display" "inline-block"
        , style "margin-right" "13px"
        ]
        [ element ]


example : Html msg
example =
    let
        primaryButton =
            button "Primary Button"
                |> Btn.withType Primary
                |> toHtml
                |> withSpace

        defaultButton =
            button "Default Button"
                |> Btn.withType Default
                |> toHtml
                |> withSpace

        dashedButton =
            button "Dashed Button"
                |> Btn.withType Dashed
                |> toHtml
                |> withSpace

        textButton =
            button "Text Button"
                |> Btn.withType Text
                |> toHtml
                |> withSpace

        linkButton =
            button "Link Button"
                |> Btn.withType Link
                |> toHtml
                |> withSpace
    in
    div []
        [ primaryButton
        , defaultButton
        , dashedButton
        , textButton
        , linkButton
        ]"""


disabledExampleStr : String
disabledExampleStr =
    """module Routes.ButtonComponent.DisabledExample exposing (example)

import Ant.Button exposing (ButtonType(..), button, disabled, onClick, toHtml, withType)
import Html exposing (Html)

type Msg = Clicked

example : Html Msg
example =
    button "Primary (disabled)"
        |> withType Primary
        |> onClick Clicked
        -- It won't emit a Clicked event now
        |> disabled True
        |> toHtml
"""


type alias Model =
    { typeExample : Container.Model
    , iconExample : Container.Model
    , disabledExample : Container.Model
    }


type DemoBox
    = ButtonType
    | ButtonWithIcon
    | DisabledButton


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

                DisabledButton ->
                    let
                        ( disabledExampleModel, disabledExampleCmd ) =
                            Container.update demoboxMsg model.disabledExample
                    in
                    ( { model | disabledExample = disabledExampleModel }, disabledExampleCmd )

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
        , disabledExample = { sourceCodeVisible = False, sourceCode = disabledExampleStr }
        }
    }


typeExample : Model -> Styled.Html Msg
typeExample model =
    let
        styledTypeExampleContents =
            fromUnstyled TypeExample.example

        metaInfo =
            { title = "Type"
            , content = "There are \"primary\", \"default\", \"dashed\", \"text\" and \"link\" buttons in Elm Antd."
            , ellieDemo = "https://ellie-app.com/9mhLFFTMgzTa1"
            , sourceCode = typeExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledTypeExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.typeExample
        |> Styled.map (DemoBoxMsg ButtonType)


disabledExample : Model -> Styled.Html Msg
disabledExample model =
    let
        styledDisabledExampleContents =
            fromUnstyled DisabledExample.example
                |> Styled.map (\_ -> Container.ContentMsg)

        metaInfo =
            { title = "Disabled"
            , content = "You can disable any button"
            , ellieDemo = "https://ellie-app.com/9mj25Y2hXXya1"
            , sourceCode = disabledExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledDisabledExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.disabledExample
        |> Styled.map (DemoBoxMsg DisabledButton)


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
            , div [ css [ maxWidth (pct 45) ] ] [ disabledExample model ]
            ]
        ]
