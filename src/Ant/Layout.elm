module Ant.Layout exposing
    ( layout
    , layout2
    , sidebar
    , Sidebar
    , sidebarWidth
    , sidebarToTree
    , header
    , content
    , footer
    , toHtml
    , LayoutTree
    )

{-| Primitives for creating typical page layouts

From: https://ant.design/components/layout/

# Introduction

Each of the primitives below creates a `LayoutTree` that represents that shape of your layout.

This module allows for 2-column and 3-column layouts.

This module defines a recursive LayoutTree data structure, which allows for layouts of large depth and complexity.

@docs LayoutTree

## Primitives

The following primitives take some content (as `Html msg`) and returns to you a `LayoutTree` that you can continue appending to

Example:

    sidebar =
        Layout.sidebar (componentMenu model.activeRoute)
        |> Layout.sidebarWidth 300
        |> Layout.sidebarToTree

    layout : LayoutTree Msg
    layout =
        Layout.layout2
            (Layout.header <| toUnstyled navBar)
            (Layout.layout2
                sidebar
                (Layout.layout2
                    (Layout.content <| toUnstyled componentPageShell)
                    (Layout.footer <| toUnstyled footer))
            )


@docs header, content, footer, layout, layout2

## Customizeable Primitives

The following primitives do not return a `LayoutTree` immediately. Rather, they return an intermediary data structure that you can then customize further before converting it into a `LayoutTree` node that can be appended to your main `LayoutTree`

@docs Sidebar, sidebar, sidebarWidth, sidebarToTree


## Other

@docs toHtml

-}


import Css exposing (width, px)
import Html exposing (Html, Attribute, div, aside)
import Html.Styled as Styled exposing (toUnstyled, fromUnstyled)
import Html.Attributes exposing (style)
import Html.Styled.Attributes exposing (css)


type Header msg = Header (Html msg)
type Content msg = Content (Html msg)
type Footer msg = Footer (Html msg)

{-| Create a header node in your LayoutTree

This node will be rendered horizontally at the top of your layout tree
-}
header : Html msg -> LayoutTree msg
header = HeaderNode << Header


{-| Create a content node in your LayoutTree

This node will be rendered beneath a header (if a header is provided), but above the footer (if a footer is provided)
-}
content : Html msg -> LayoutTree msg
content = ContentNode << Content


{-| Create a footer node in your LayoutTree

This node will be rendered beneath all other nodes in your LayoutTree, just as you would expect from a footer.
-}
footer : Html msg -> LayoutTree msg
footer = FooterNode << Footer




-------------------------------------------
-------------------------------------------
------ Sidebar

type alias CollapseOptions =
    { collapsed : Bool
    }

type alias SidebarOptions =
    { collapseOptions : Maybe CollapseOptions
    , width : Float
    }


defaultSidebarOptions : SidebarOptions
defaultSidebarOptions =
    { collapseOptions = Nothing
    , width = 200
    }


{-| A sidebar
-}
type Sidebar msg = Sidebar SidebarOptions (Html msg)


{-| Create a customizeable sidebar

In order to append the sidebar to your LayoutTree, you must call `sidebarToTree`

    sideBar innerNodes
        |> sidebarWidth 40
        |> sidebarToTree
-}
sidebar : Html msg -> Sidebar msg
sidebar = Sidebar defaultSidebarOptions


{-| Customize the width (in pixels) of the sidebar
-}
sidebarWidth : Float -> Sidebar msg -> Sidebar msg
sidebarWidth width (Sidebar opts sidebarContent) =
    let
        newOpts = { opts | width = width }
    in
        Sidebar newOpts sidebarContent


{-| Convert a `Sidebar` into a `LayoutTree` node so that you may append it to a `LayoutTree`
-}
sidebarToTree : Sidebar msg -> LayoutTree msg
sidebarToTree = SideBarNode


-------------------------------------------
-------------------------------------------
------ General Layout Types and fns

{-| The various kinds of nodes represented by a LayoutTree
-}
type LayoutTree msg
    = SideBarNode (Sidebar msg)
    | HeaderNode (Header msg)
    | ContentNode (Content msg)
    | FooterNode (Footer msg)
    | LayoutTree2 (LayoutTree msg) (LayoutTree msg)
    | LayoutTree3 (LayoutTree msg) (LayoutTree msg) (LayoutTree msg) 


{-| Generate a three-column layout from three LayoutTree's (see example above)
-}
layout : LayoutTree msg -> LayoutTree msg -> LayoutTree msg -> LayoutTree msg
layout firstSibling secondSibling thirdSibling =
    LayoutTree3 firstSibling secondSibling thirdSibling


{-| Generate a two-column layout from two LayoutTree's (see example above)
-}
layout2 : LayoutTree msg -> LayoutTree msg -> LayoutTree msg
layout2 firstSibling secondSibling =
    LayoutTree2 firstSibling secondSibling


sideBarToHtml : Sidebar msg -> Html msg
sideBarToHtml (Sidebar opts sidebarContent) =
    let
        styledAside = 
            Styled.aside
                [ css [ width (px opts.width) ]
                ]
                [ fromUnstyled sidebarContent ]
    in
    toUnstyled styledAside



headerToHtml : Header msg -> Html msg
headerToHtml (Header headerContent) =
    headerContent


contentToHtml : Content msg -> Html msg
contentToHtml (Content contentValue) =
    contentValue


footerToHtml : Footer msg -> Html msg
footerToHtml (Footer footerContent) =
    footerContent


getDisplayStyle : LayoutTree msg -> Attribute msg
getDisplayStyle tree =
    case tree of
        LayoutTree2 (SideBarNode _) _ -> style "display" "flex"
        LayoutTree2 _ (SideBarNode _) -> style "display" "flex"
        LayoutTree3 (SideBarNode _) _ _ -> style "display" "flex"
        LayoutTree3 _ (SideBarNode _) _ -> style "display" "flex"
        _ -> style "display" "block"


{-| Convert your layout tree into good old `Html msg`
-}
toHtml : LayoutTree msg -> Html msg
toHtml tree =
    let
        containerStyles =
            [ getDisplayStyle tree
            , style "height" "100%"
            , style "width" "100%"
            ]
    in
    case tree of
        HeaderNode headerNode -> headerToHtml headerNode
        
        SideBarNode sidebarNode -> sideBarToHtml sidebarNode
        
        ContentNode contentNode -> contentToHtml contentNode
        
        FooterNode footerNode -> footerToHtml footerNode

        LayoutTree2 left right ->
            div
                containerStyles
                [ toHtml left, toHtml right ]

        LayoutTree3 left middle right ->
            div
                containerStyles
                [ toHtml left, toHtml middle, toHtml right ]
