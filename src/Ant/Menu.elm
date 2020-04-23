module Ant.Menu exposing
    ( initMenuItem
    , selected
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


import Ant.Typography exposing (fontList)
import Ant.Typography.Text exposing (textColorRgba)
import Ant.Palette exposing (primaryColor)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html exposing (Html, div, text, span, ul, li)
import Html.Attributes exposing (style)
import Html.Styled as Styled exposing (toUnstyled, fromUnstyled)
import Html.Styled.Attributes exposing (css, href)

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

type alias Href = String
type MenuItem msg = MenuItem Href MenuItemState (Html msg) 


initMenuItem : Href -> Html msg -> MenuItem msg
initMenuItem hrefString = MenuItem hrefString defaultMenuItemState


selected : MenuItem msg -> MenuItem msg
selected (MenuItem hrefString currentState contents) =
    let
        newState = { currentState | selected = True }
    in
        MenuItem hrefString newState contents


type MenuContent msg
    = Item (MenuItem msg)
    | Sub (SubMenu msg)
    | Group (ItemGroup msg)


type Menu msg = Menu (List (MenuContent msg))





-------------------------------------------
-------------------------------------------
------ Menu Logic

initMenu : Menu msg
initMenu = Menu []

{-| push a menu item to the end of the menu
-}
pushItem : MenuItem msg -> Menu msg -> Menu msg
pushItem newMenuItem (Menu currentMenuList) =
    Menu (currentMenuList ++ [ Item newMenuItem ])


pushSubMenu : SubMenu msg -> Menu msg -> Menu msg
pushSubMenu subMenu (Menu currentMenuList) =
    Menu (currentMenuList ++ [ Sub subMenu ])
  

pushItemGroup : ItemGroup msg -> Menu msg -> Menu msg
pushItemGroup itemGroup (Menu currentMenuList) =
    Menu (currentMenuList ++ [ Group itemGroup ])




-------------------------------------------
-------------------------------------------
------ SubMenu Logic

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


pushItemToSubMenu : MenuItem msg -> SubMenu msg -> SubMenu msg
pushItemToSubMenu newMenuItem (SubMenu state currentMenuList) =
    SubMenu state (currentMenuList ++ [ SubMenuItem newMenuItem ])


pushSubMenuToSubMenu : SubMenu msg -> SubMenu msg -> SubMenu msg
pushSubMenuToSubMenu childSubMenu (SubMenu state currentMenuList) =
    SubMenu state (currentMenuList ++ [ NestedSubMenu childSubMenu ])


pushItemGroupToSubMenu : ItemGroup msg -> SubMenu msg -> SubMenu msg
pushItemGroupToSubMenu itemGroup (SubMenu state currentMenuList) =
    SubMenu state (currentMenuList ++ [ SubMenuGroup itemGroup ])







-------------------------------------------
-------------------------------------------
------ ItemGroup Logic

type alias ItemGroupTitle = String

type ItemGroup msg
    = ItemGroup ItemGroupTitle (List (MenuItem msg))


initItemGroup : ItemGroupTitle -> List (MenuItem msg) -> ItemGroup msg
initItemGroup =
    ItemGroup


pushItemToItemGroup : MenuItem msg -> ItemGroup msg -> ItemGroup msg
pushItemToItemGroup newItem (ItemGroup title currentItemGroupList) =
    ItemGroup title (currentItemGroupList ++ [ newItem ])











-------------------------------------------
-------------------------------------------
------ View Logic


menuItemColor : Style
menuItemColor =
    let
        { r, g, b, a } =
            textColorRgba
    in
    color (rgba r g b a)


viewMenuItem : MenuItem msg -> Html msg
viewMenuItem (MenuItem hrefString state itemContents) =
    let
        styledLinkedItemContens =
            Styled.a
                [ css
                    [ textDecoration none
                    , visited [ color (hex primaryColor) ]
                    ]
                , href hrefString
                ]
                [  styledMenuItem ]

        selectedItemStyles =
            if state.selected then
                batch
                    [ color (hex primaryColor)
                    , backgroundColor (hex "#e6f7ff")
                    , borderRight3 (px 3) solid (hex primaryColor)
                    ]
            else
                batch
                    [ menuItemColor
                    , hover
                        [ color (hex primaryColor) ]
                    ]

        styledMenuItem =
            Styled.li
                [ css
                    [ selectedItemStyles
                    , fontFamilies fontList
                    , fontSize (px 14)
                    , paddingLeft (px 40)
                    , paddingRight (px 16)
                    , marginTop (px 4)
                    , marginBottom (px 8)
                    , lineHeight (px 40)
                    , transition [ Css.Transitions.color 250 ]
                    ]
                ]
                [  fromUnstyled itemContents ]
    in
    toUnstyled styledLinkedItemContens



viewItemGroup : ItemGroup msg -> Html msg
viewItemGroup (ItemGroup title menuItems) =
    div []
        [ span [] [ text title ]
        , ul [] <|
            List.map viewMenuItem menuItems
        ]


viewSubMenuContent : SubMenuContent msg -> Html msg
viewSubMenuContent subMenuContent =
    case subMenuContent of
        SubMenuItem menuItem ->
            viewMenuItem menuItem

        SubMenuGroup itemGroup ->
            viewItemGroup itemGroup

        
        NestedSubMenu subMenu -> 
            viewSubMenu subMenu



viewSubMenu : SubMenu msg -> Html msg
viewSubMenu (SubMenu state subMenuContentList) =
    li []
        [ ul [] <|
            List.map viewSubMenuContent subMenuContentList
        ]



viewMenuContent : MenuContent msg -> Html msg
viewMenuContent menuContent =
    case menuContent of 
        Item menuItem ->
            viewMenuItem menuItem

        Sub subMenu ->
            viewSubMenu subMenu

        Group itemGroup ->
            viewItemGroup itemGroup
    


view : Menu msg -> Html msg
view (Menu menuContents) =
    ul
        [ style "border-right" "1px solid #f0f0f0"
        , style "height" "100%"
        ]
        (List.map viewMenuContent menuContents)
