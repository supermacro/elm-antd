module Routes.InputComponent exposing (Model, Msg, route)

import Css exposing (..)
import Html.Styled as Styled exposing (div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css)
import Routes.InputComponent.BasicExample as BasicExample
import Routes.InputComponent.PasswordExample as PasswordExample
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
    "Input"


type alias Model =
    { basicExample : Container.Model BasicExample.Model BasicExample.Msg
    , passwordExample : Container.Model PasswordExample.Model PasswordExample.Msg
    , version : Maybe String
    }


type DemoBox
    = Basic (Container.Msg BasicExample.Msg)
    | Password (Container.Msg PasswordExample.Msg)


type Msg
    = DemoBoxMsg DemoBox
    | ExampleSourceCodeLoaded (List SourceCode)


route : DocumentationRoute Model Msg
route =
    { title = title
    , category = DataEntry
    , view = view
    , update = update
    , initialModel =
        \v ->
            { basicExample =
                Container.initStatefulModel
                    "BasicExample.elm"
                    BasicExample.init
                    BasicExample.update
            , passwordExample =
                Container.initStatefulModel
                    "PasswordExample.elm"
                    PasswordExample.init
                    PasswordExample.update
            , version = v
            }
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demoBox ->
            case demoBox of
                Basic basicExampleMsg ->
                    let
                        ( basicModel, basicCmd ) =
                            Container.update (DemoBoxMsg << Basic) basicExampleMsg model.basicExample
                    in
                    ( { model | basicExample = basicModel }, basicCmd )

                Password passwordExampleMsg ->
                    let
                        ( passwordModel, passwordCmd ) =
                            Container.update (DemoBoxMsg << Password) passwordExampleMsg model.passwordExample
                    in
                    ( { model | passwordExample = passwordModel }, passwordCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode model.version examplesSourceCode model.basicExample
                , passwordExample = Container.setSourceCode model.version examplesSourceCode model.passwordExample
              }
            , Cmd.none
            )


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "Basic usage example."
            , ellieDemo = "https://ellie-app.com/9mjyZ2xHwN9a1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << Basic)
        model.basicExample
        BasicExample.example
        metaInfo


passwordExample : Model -> Styled.Html Msg
passwordExample model =
    let
        metaInfo =
            { title = "Password field"
            , content = "Input type of password."
            , ellieDemo = "https://ellie-app.com/9mjyZ2xHwN9a1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << Password)
        model.passwordExample
        PasswordExample.example
        metaInfo


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading title
        , documentationText <| text "A basic widget for getting the user input is a text field. Keyboard and mouse can be used for providing or changing data."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationUnorderedList
            [ text "A user input in a form field is needed."
            , text "A search input is required."
            ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div [ css [ displayFlex ] ]
            [ div
                [ css [ width (pct 45), marginRight (px 13) ] ]
                [ basicExample model ]
            , div
                [ css [ width (pct 100), maxWidth (pct 45) ] ]
                [ passwordExample model ]
            ]
        ]
