module Routes.MenuComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text)
import Html.Styled.Attributes exposing (css)
import Routes.MenuComponent.HorizontalExample as HorizontalExample
import UI.Container as Container
import UI.Typography as Typography exposing
        ( codeText
        , documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)

type alias Model =
  { horizontalExample: Container.Model }

type DemoBox = HorizontalMenu

type Msg
  = DemoBoxMsg DemoBox Container.Msg
  | ExampleSourceCodeLoaded (List SourceCode)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    DemoBoxMsg demobox demoboxMsg ->
      case demobox of
        HorizontalMenu ->
          let
            (horizontalExampleModel, horizontalExampleCmd) =
              Container.update demoboxMsg model.horizontalExample
          in
            ({ model | horizontalExample = horizontalExampleModel}, horizontalExampleCmd)

    ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | horizontalExample = Container.setSourceCode examplesSourceCode model.horizontalExample
              }
            , Cmd.none
            )

route : DocumentationRoute Model Msg
route =
  { title = "Menu"
  , category = General
  , view = view , update = update
  , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
  , initialModel =
      { horizontalExample = Container.initModel "HorizontalExample.elm" }
  }

horizontalExample : Model -> Styled.Html Msg
horizontalExample model =
  let
    styledExample =
      fromUnstyled (HorizontalExample.example (DemoBoxMsg HorizontalMenu Container.ContentMsg))
        |> Styled.map (\_ -> Container.ContentMsg)

    metaInfo =
      { title = "Horizontal"
      , content = "This is a Horizontal Menu exmaple"
      , ellieDemo = "to be added"
      }

    styledDemoContents =
      div [ css [ displayFlex ]] [ styledExample ]
  in
    Container.demoBox metaInfo styledDemoContents
      |> Container.view model.horizontalExample
      |> Styled.map (DemoBoxMsg HorizontalMenu)

view : Model -> Styled.Html Msg
view model =
  div []
    [ div [] [ horizontalExample model ] ]