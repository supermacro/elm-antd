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
    , MenuMode(..)
    )


import Ant.Typography exposing (fontList)
import Ant.Typography.Text as Text exposing (textColorRgba)
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


type MenuMode = Vertical | Horizontal | Inline

type alias MenuConfig =
    { mode : MenuMode
    , verticalOrInlineCollapsed : Bool
    }


defaultMenuConfig : MenuConfig
defaultMenuConfig =
    { mode = Vertical
    , verticalOrInlineCollapsed = False
    }


type MenuContent msg
    = Item (MenuItem msg)
    | Sub (SubMenu msg)
    | Group (ItemGroup msg)


type Menu msg = Menu MenuConfig (List (MenuContent msg))





-------------------------------------------
-------------------------------------------
------ Menu Logic

initMenu : Menu msg
initMenu = Menu defaultMenuConfig []

{-| push a menu item to the end of the menu
-}
pushItem : MenuItem msg -> Menu msg -> Menu msg
pushItem newMenuItem (Menu config currentMenuList) =
    Menu config (currentMenuList ++ [ Item newMenuItem ])


pushSubMenu : SubMenu msg -> Menu msg -> Menu msg
pushSubMenu subMenu (Menu config currentMenuList) =
    Menu config (currentMenuList ++ [ Sub subMenu ])
  

pushItemGroup : ItemGroup msg -> Menu msg -> Menu msg
pushItemGroup itemGroup (Menu config currentMenuList) =
    Menu config (currentMenuList ++ [ Group itemGroup ])




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


viewMenuItem : MenuItem msg -> Styled.Html msg
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
    styledLinkedItemContens



viewItemGroup : ItemGroup msg -> Styled.Html msg
viewItemGroup (ItemGroup title menuItems) =
    let
        itemGroupLabel =
            fromUnstyled
                (Text.text title
                |> Text.textType Text.Secondary
                |> Text.toHtml)
    in
    Styled.div []
        [ Styled.div
            [ css
                [ padding4 (px 8) (px 16) (px 8) (px 32) ]
            ]
            [ itemGroupLabel ]
        , Styled.ul [] <|
            List.map viewMenuItem menuItems
        ]


viewSubMenuContent : SubMenuContent msg -> Styled.Html msg
viewSubMenuContent subMenuContent =
    case subMenuContent of
        SubMenuItem menuItem ->
            viewMenuItem menuItem

        SubMenuGroup itemGroup ->
            viewItemGroup itemGroup
        
        NestedSubMenu subMenu -> 
            viewSubMenu subMenu



viewSubMenu : SubMenu msg -> Styled.Html msg
viewSubMenu (SubMenu state subMenuContentList) =
    Styled.li []
        [ Styled.ul [] <|
            List.map viewSubMenuContent subMenuContentList
        ]



viewMenuContent : MenuContent msg -> Styled.Html msg
viewMenuContent menuContent =
    case menuContent of 
        Item menuItem ->
            viewMenuItem menuItem

        Sub subMenu ->
            viewSubMenu subMenu

        Group itemGroup ->
            viewItemGroup itemGroup
    


view : Menu msg -> Html msg
view (Menu config menuContents) =
    ul
        [ style "border-right" "1px solid #f0f0f0"
        , style "height" "100%"
        ]
        (List.map (toUnstyled << viewMenuContent) menuContents)
