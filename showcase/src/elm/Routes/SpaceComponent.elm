module Routes.SpaceComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, maxWidth, pct)
import Html.Styled as Styled exposing (div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css)
import Routes.SpaceComponent.BasicExample as BasicExample
import Routes.SpaceComponent.VerticalAndSpacingExample as VerticalAndSpacingExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)


title : String
title =
    "Space"


type alias StatelessDemo =
    Container.Model () Never


type alias Model =
    { basicExample : StatelessDemo
    , verticalAndSpacingExample : StatelessDemo
    , version : Maybe String
    }


type DemoBox
    = Basic
    | VertWithSpacing


type Msg
    = DemoBoxMsg DemoBox (Container.Msg Never)
    | ExampleSourceCodeLoaded (List SourceCode)


route : DocumentationRoute Model Msg
route =
    { title = title
    , category = Layout
    , view = view
    , update = update
    , initialModel =
        \v ->
            { basicExample =
                Container.initModel "BasicExample.elm"
            , verticalAndSpacingExample =
                Container.initModel "VerticalAndSpacingExample.elm"
            , version = v
            }
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demoBox demoboxMsg ->
            case demoBox of
                Basic ->
                    let
                        ( basicModel, basicCmd ) =
                            Container.update (DemoBoxMsg Basic) demoboxMsg model.basicExample
                    in
                    ( { model | basicExample = basicModel }, basicCmd )

                VertWithSpacing ->
                    let
                        ( verticalAndSpacingModel, verticalAndSpacingCmd ) =
                            Container.update (DemoBoxMsg VertWithSpacing) demoboxMsg model.verticalAndSpacingExample
                    in
                    ( { model | verticalAndSpacingExample = verticalAndSpacingModel }, verticalAndSpacingCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode model.version examplesSourceCode model.basicExample
                , verticalAndSpacingExample = Container.setSourceCode model.version examplesSourceCode model.verticalAndSpacingExample
              }
            , Cmd.none
            )


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "Basic usage example. Default direction is horizontal."
            , ellieDemo = "https://ellie-app.com/9mjyZ2xHwN9a1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg Basic)
        model.basicExample
        (\_ -> BasicExample.example)
        metaInfo


verticalAndSpacingExample : Model -> Styled.Html Msg
verticalAndSpacingExample model =
    let
        metaInfo =
            { title = "Vertical and Spacing"
            , content = "Using vertical direction and a mixture of medium and large spacing."
            , ellieDemo = "https://ellie-app.com/9mjyZ2xHwN9a1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg VertWithSpacing)
        model.verticalAndSpacingExample
        (\_ -> VerticalAndSpacingExample.example)
        metaInfo


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading title
        , documentationText <| text "Set Component Spacing"
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationText <| text "To avoid components clinging together and to create unified spacing between components."
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div []
            [ div [ css [ maxWidth (pct 45) ] ] [ basicExample model ]
            , div [ css [ maxWidth (pct 45) ] ] [ verticalAndSpacingExample model ]
            ]
        ]
