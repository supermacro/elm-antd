module Routes.DividerComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text)
import Html.Styled.Attributes exposing (css)
import Routes.DividerComponent.HorizontalExample as HorizontalExample
import Routes.DividerComponent.TextWithoutHeadingExample as TextWithoutHeadingExample
import Routes.DividerComponent.VerticalExample as VerticalExample
import Routes.DividerComponent.WithTitleExample as WithTitleExample
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
    { horizontalExample : Container.Model
    , textWithoutHeadingExample : Container.Model
    , withTitleExample : Container.Model
    , verticalExample : Container.Model
    }


type DemoBox
    = HorizontalExample
    | TextWithoutHeadingExample
    | WithTitleExample
    | VerticalExample


type Msg
    = DemoBoxMsg DemoBox Container.Msg
    | SourceCopiedToClipboard DemoBox
    | ExampleSourceCodeLoaded (List SourceCode)


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

                TextWithoutHeadingExample ->
                    let
                        ( textWithoutHeadingExampleModel, textWithoutHeadingExampleCmd ) =
                            Container.update demoboxMsg model.textWithoutHeadingExample
                    in
                    ( { model | textWithoutHeadingExample = textWithoutHeadingExampleModel }, textWithoutHeadingExampleCmd )

                WithTitleExample ->
                    let
                        ( withTitleExampleModel, withTitleExampleCmd ) =
                            Container.update demoboxMsg model.withTitleExample
                    in
                    ( { model | withTitleExample = withTitleExampleModel }, withTitleExampleCmd )

                VerticalExample ->
                    let
                        ( verticalExampleModel, verticalExampleCmd ) =
                            Container.update demoboxMsg model.verticalExample
                    in
                    ( { model | verticalExample = verticalExampleModel }, verticalExampleCmd )

        SourceCopiedToClipboard demobox ->
            ( model, Cmd.none )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | verticalExample = Container.setSourceCode examplesSourceCode model.verticalExample
                , withTitleExample = Container.setSourceCode examplesSourceCode model.withTitleExample
                , horizontalExample = Container.setSourceCode examplesSourceCode model.horizontalExample
                , textWithoutHeadingExample = Container.setSourceCode examplesSourceCode model.textWithoutHeadingExample
              }
            , Cmd.none
            )


route : DocumentationRoute Model Msg
route =
    { title = "Divider"
    , category = Layout
    , view = view
    , update = update
    , initialModel =
        { horizontalExample = Container.initModel "HorizontalExample.elm"
        , textWithoutHeadingExample = Container.initModel "TextWithoutHeadingExample.elm"
        , withTitleExample = Container.initModel "WithTitleExample.elm"
        , verticalExample = Container.initModel "VerticalExample.elm"
        }
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    }


horizontalExample : Model -> Styled.Html Msg
horizontalExample model =
    let
        metaInfo =
            { title = "Horizontal"
            , content = "Divider is \"horizontal\" by default. You can add text within Divider."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg HorizontalExample)
        model.horizontalExample
        HorizontalExample.example
        metaInfo


textWithoutHeadingExample : Model -> Styled.Html Msg
textWithoutHeadingExample model =
    let
        metaInfo =
            { title = "Text without heading style"
            , content = "You can use non-heading style of divider text by setting Plain textStyle"
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg TextWithoutHeadingExample)
        model.textWithoutHeadingExample
        TextWithoutHeadingExample.example
        metaInfo


withTitleExample : Model -> Styled.Html Msg
withTitleExample model =
    let
        metaInfo =
            { title = "Divider with title"
            , content = "Divider with inner title, use \"withOrientation\" to align it."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg WithTitleExample)
        model.withTitleExample
        WithTitleExample.example
        metaInfo


verticalExample : Model -> Styled.Html Msg
verticalExample model =
    let
        metaInfo =
            { title = "Vertical"
            , content = "Use \"withType Vertical\" make it vertical."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg VerticalExample)
        model.verticalExample
        VerticalExample.example
        metaInfo


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
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ] [ horizontalExample model ]
            , div [ css [ maxWidth (pct 45) ] ] [ withTitleExample model ]
            ]
        , div [ css [ displayFlex ] ]
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ] [ textWithoutHeadingExample model ]
            , div [ css [ maxWidth (pct 45) ] ] [ verticalExample model ]
            ]
        ]
