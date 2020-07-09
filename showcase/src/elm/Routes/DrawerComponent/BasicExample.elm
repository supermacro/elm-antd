module Routes.DrawerComponent.BasicExample exposing (example, initialModel, Model, Msg, update)

import Ant.Button exposing (ButtonType(..), button, onClick, toHtml, withType)
import Ant.Drawer as Drawer exposing (collapsed, withPlacement)
import Html exposing (Html, div, text)

type Msg = ToggleDrawerOpen

type alias Model =
    { drawerCollapsed : Bool }

initialModel : Model
initialModel =
    { drawerCollapsed = True }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleDrawerOpen ->
            { model | drawerCollapsed = not model.drawerCollapsed }

example : Model -> Html Msg
example { drawerCollapsed } =
    let
        drawerToggleButton =
            button "toggle drawer"
                |> withType Primary
                |> onClick ToggleDrawerOpen
                |> toHtml

        content = text "Hello, world"

        footer = 
            button "submit"
                |> withType Primary
                |> onClick ToggleDrawerOpen
                |> toHtml

        drawer =
            Drawer.drawer content
                |> collapsed drawerCollapsed
                |> withPlacement Drawer.Right
                |> Drawer.withFooter footer
                |> Drawer.onClickOutside (ToggleDrawerOpen)
                |> Drawer.withHeader (Drawer.Title "Basic Drawer")
                |> Drawer.toHtml
    in
    div [] [ drawerToggleButton, drawer ]
    
