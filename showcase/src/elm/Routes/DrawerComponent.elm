module Routes.DrawerComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, marginRight, maxWidth, pct, px)
import Html.Styled as Styled exposing (div, fromUnstyled, span, text)
import Html.Styled.Attributes exposing (css)
import Routes.DrawerComponent.BasicExample as BasicExample
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

basicExampleStr : String
basicExampleStr =
  """module Routes.DrawerComponent.SimpleExample exposing (example)"""

type alias Model = 
  { basicExample : Container.Model BasicExample.Msg BasicExample.Model }

type DemoBox
  = BasicDrawer (Container.Msg BasicExample.Msg)

type Msg
  = DemoBoxMsg DemoBox 

update : Msg -> Model -> (Model, Cmd msg)
update msg model = 
  case msg of
      DemoBoxMsg demobox ->
          case demobox of
              BasicDrawer demoboxMsg ->
                let
                    (basicExampleModel, basicExampleCmd) =
                      Container.update demoboxMsg model.basicExample
                  in
                  ( { model | basicExample = basicExampleModel }, basicExampleCmd )


route : DocumentationRoute Model Msg
route =
    { title = "Drawer"
    , category = Feedback
    , view = view
    , update = update
    , initialModel =
        { basicExample =
            { sourceCodeVisible = False
            , sourceCode = basicExampleStr
            , demoModel = BasicExample.initialModel
            , demoUpdate = BasicExample.update
            }
        }
    }

basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        styledBasicExampleContents = 
            BasicExample.example model.basicExample.demoModel
                |> fromUnstyled
                |> Styled.map Container.ContentMsg

        metaInfo =
            { title = "Basic"
            , content = "Basic drawer."
            , ellieDemo = "https://ellie-app.com/9jQvNFNtj8Fa1"
            , sourceCode = basicExampleStr
            }

        styledDemoContents =
            div [ css [ displayFlex ] ] [ styledBasicExampleContents ]
    in
    Container.demoBox metaInfo styledDemoContents
        |> Container.view model.basicExample
        |> Styled.map (DemoBoxMsg << BasicDrawer)

view : Model -> Styled.Html Msg
view model = 
  div []
    [ documentationHeading "Drawer"
    , documentationText <| text "A panel which slides in from the edge of the screen."
    , documentationSubheading Typography.WithAnchorLink "When To Use"
    , documentationText <| text "A Drawer is a panel that is typically overlaid on top of a page and slides in from the side. It contains a set of information or actions. Since the user can interact with the Drawer without leaving the current page, tasks can be achieved more efficiently within the same context." 
    , documentationUnorderedList
        [ text "Use a Form to create or edit a set of information."
        , text "Processing subtasks. When subtasks are too heavy for a Popover and we still want to keep the subtasks in the context of the main task, Drawer comes very handy."
        , text "When the same Form is needed in multiple places."
        ]
    , documentationSubheading Typography.WithoutAnchorLink "Examples"
    , div [ css [ displayFlex ] ]
            [ div [ css [ maxWidth (pct 45), marginRight (px 13) ] ] [ basicExample model ]
            , div [ css [ maxWidth (pct 45) ] ] [  ]
            ]
    ]
