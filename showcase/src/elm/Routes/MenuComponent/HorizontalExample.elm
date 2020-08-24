module Routes.MenuComponent.HorizontalExample exposing (example)

import Ant.Menu as Menu exposing (defaultSubMenuState)
import Ant.Space exposing (SpaceDirection(..))
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (style)


example : msg -> Html msg
example msg =
    let
        menuItem1 =
            Menu.initMenuItem msg (text "Navigation One")
                |> Menu.selected

        menuItem2 =
            Menu.initMenuItem msg (text "Navigation Two")
                |> Menu.disabled

        groupOneItems =
            [ Menu.initMenuItem msg (text "Option 1")
            , Menu.initMenuItem msg (text "Option 2")
            ]

        groupTwoItems =
            [ Menu.initMenuItem msg (text "Option 3")
            , Menu.initMenuItem msg (text "Option 4")
            ]

        groupOne =
            Menu.initItemGroup "Group 1" groupOneItems

        groupTwo =
            Menu.initItemGroup "Group 2" groupTwoItems

        subMenu =
            Menu.initSubMenu
                { defaultSubMenuState
                    | title = Just "Navigation 3 - Submenu"
                    , opened = False
                }
                |> Menu.pushItemGroupToSubMenu groupOne
                |> Menu.pushItemGroupToSubMenu groupTwo

        horizontalExample =
            Menu.initMenu
                |> Menu.pushItem menuItem1
                |> Menu.pushItem menuItem2
                |> Menu.pushSubMenu subMenu
                |> Menu.mode Menu.Horizontal
                |> Menu.toHtml
    in
    div []
        [ horizontalExample ]
