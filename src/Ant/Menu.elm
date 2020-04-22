module Ant.Menu exposing
    ( menuItem
    , initMenu
    , initSubMenu
    , initItemGroup
    , pushItem
    , pushSubMenu
    , pushItemGroup
    , pushItemToSubMenu
    , pushItemGroupToSubMenu
    , pushSubMenuToSubMenu
    , pushItemToItemGroup
    , view
    , Menu
    , SubMenu
    , ItemGroup
    , MenuItemState
    , defaultMenuItemState
    , defaultSubMenuState
    )


import Html exposing (Html, div, text)

type alias MenuItemState =
    { selected : Bool
    , disabled : Bool
    , title : Maybe String
    }

defaultMenuItemState : MenuItemState
defaultMenuItemState =
    { selected = False
    , disabled = False
    , title = Nothing
    }

type MenuItem msg = MenuItem MenuItemState (Html msg) 


menuItem : Html msg -> MenuItem msg
menuItem = MenuItem defaultMenuItemState


type MenuContent msg
    = Item (MenuItem msg)
    | Sub (SubMenu msg)
    | Group (ItemGroup msg)


type Menu msg = Menu (List (MenuContent msg))


initMenu : Menu msg
initMenu = Menu []

{-| push a menu item to the end of the menu
-}
pushItem : MenuItemState -> Html msg -> Menu msg -> Menu msg
pushItem itemState item (Menu currentMenuList) =
    let
        newMenuItem = MenuItem itemState item
    in
        Menu (currentMenuList ++ [ Item newMenuItem ])


pushSubMenu : SubMenu msg -> Menu msg -> Menu msg
pushSubMenu subMenu (Menu currentMenuList) =
    Menu (currentMenuList ++ [ Sub subMenu ])
  

pushItemGroup : ItemGroup msg -> Menu msg -> Menu msg
pushItemGroup itemGroup (Menu currentMenuList) =
    Menu (currentMenuList ++ [ Group itemGroup ])


-------------------------------------------
-------------------------------------------
------ SubMenu

type alias SubMenuState =
    { opened : Bool
    , disabled : Bool
    , title : Maybe String
    }

defaultSubMenuState : SubMenuState
defaultSubMenuState =
    { opened = False
    , disabled = False
    , title = Nothing
    }


type SubMenuContent msg
    = SubMenuItem (MenuItem msg)
    | SubMenuGroup (ItemGroup msg)
    | NestedSubMenu (SubMenu msg)

type SubMenu msg = SubMenu SubMenuState (List (SubMenuContent msg))

initSubMenu : SubMenu msg
initSubMenu = SubMenu defaultSubMenuState []


pushItemToSubMenu : MenuItemState -> Html msg -> SubMenu msg -> SubMenu msg
pushItemToSubMenu itemState itemContents (SubMenu state currentMenuList) =
    let 
        newMenuItem = MenuItem itemState itemContents
    in
        SubMenu state (currentMenuList ++ [ SubMenuItem newMenuItem ])


pushSubMenuToSubMenu : SubMenu msg -> SubMenu msg -> SubMenu msg
pushSubMenuToSubMenu childSubMenu (SubMenu state currentMenuList) =
    SubMenu state (currentMenuList ++ [ NestedSubMenu childSubMenu ])


pushItemGroupToSubMenu : ItemGroup msg -> SubMenu msg -> SubMenu msg
pushItemGroupToSubMenu itemGroup (SubMenu state currentMenuList) =
    SubMenu state (currentMenuList ++ [ SubMenuGroup itemGroup ])


-------------------------------------------
-------------------------------------------
------ ItemGroup

type alias ItemGroupTitle = String

type ItemGroup msg
    = ItemGroup ItemGroupTitle (List (MenuItem msg))


initItemGroup : ItemGroupTitle -> List (MenuItem msg) -> ItemGroup msg
initItemGroup =
    ItemGroup


pushItemToItemGroup : MenuItem msg -> ItemGroup msg -> ItemGroup msg
pushItemToItemGroup newItem (ItemGroup title currentItemGroupList) =
    ItemGroup title (currentItemGroupList ++ [ newItem ])


view : Menu msg -> Html msg
view (Menu menuContents) =
    div [] [ text "tree" ]

