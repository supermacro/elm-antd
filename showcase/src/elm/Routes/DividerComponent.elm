module Routes.DividerComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text)
import Html.Styled.Attributes exposing (css)
import Routes.DividerComponent.HorizontalExample as HorizontalExample
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


horizontalExampleStr : String
horizontalExampleStr =
    """"""

type alias Model =
    { horizontalExample : Container.Model
    }


type DemoBox
    = HorizontalExample


type Msg
    = DemoBoxMsg DemoBox Container.Msg
    | SourceCopiedToClipboard DemoBox


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DemoBoxMsg demobox demoboxMsg ->
            case demobox of
                HorizontalExample ->
                    let
                        ( horizontalExampleModel, horizontalExampleCdm ) =
                            Container.update demoboxMsg model.horizontalExample
                    in
                    ( { model | horizontalExample = horizontalExampleModel }, horizontalExampleCdm )
        SourceCopiedToClipboard demobox ->
            ( model, Cmd.none )


route : DocumentationRoute Model Msg
route =
    { title = "Divider"
    , category = Layout
    , view = view
    , update = update
    , initialModel =
        { horizontalExample = { sourceCodeVisible = False, sourceCode = horizontalExampleStr }
        }
    }


horizontalExample : Model -> Styled.Html Msg
horizontalExample model =
    let
        styledHorizontalExampleContents =
            fromUnstyled HorizontalExample.example

        metaInfo =
            { title = "Type"
            , content = "There are \"primary\", \"default\", \"dashed\", \"text\" and \"link\" buttons in Elm Antd."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = horizontalExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledHorizontalExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.horizontalExample
        |> Styled.map (DemoBoxMsg HorizontalExample)

view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading "Divider"
        , documentationText <| text "A divider line separates different content."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "Divide sections of article."
            , text "Divide inline text and links such as the operation column of table."
            , text "Dashed button: used for adding action commonly."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div [ css [ displayFlex ] ]
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ] [ ]
            , div [ css [ maxWidth (pct 45) ] ] [ ]
            ]
        ]
