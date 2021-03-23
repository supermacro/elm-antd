module Routes.ModalComponent exposing (Model, Msg, route)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Routes.ModalComponent.BasicExample as BasicExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( codeText
        , documentationHeading
        , documentationSubheading
        , documentationText
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)


type alias Model =
    { basicExample : Container.Model BasicExample.Model BasicExample.Msg
    }


type DemoBox
    = Basic (Container.Msg BasicExample.Msg)


type Msg
    = DemoBoxMsg DemoBox
    | ExampleSourceCodeLoaded (List SourceCode)


route : DocumentationRoute Model Msg
route =
    { title = "Modal"
    , update = update
    , category = Feedback
    , view = view
    , initialModel =
        { basicExample =
            Container.initStatefulModel
                "BasicExample.elm"
                BasicExample.init
                BasicExample.update
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

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode examplesSourceCode model.basicExample
              }
            , Cmd.none
            )


basicExample : Model -> Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "Basic Modal"
            , ellieDemo = "https://ellie-app.com/9mjDjrRz2dBa1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg << Basic)
        model.basicExample
        BasicExample.view
        metaInfo


view : Model -> Html Msg
view model =
    div []
        [ documentationHeading "Modal Component"
        , documentationText <| text "Modal dialogs."
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationText <|
            div []
                [ text "When requiring users to interact with the application, but without jumping to a new page and interrupting the user's workflow, you can use"
                , codeText "Modal"
                , text "to create a new floating layer over the current page to get user feedback or display information."
                ]
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div [ css [ displayFlex ] ]
            [ div
                [ css
                    [ maxWidth (pct 45)
                    , marginRight (px 13)
                    , width (px 300)
                    ]
                ]
                [ basicExample model ]
            ]
        ]
