module Ant.Layout exposing
    ( layout
    , layout2
    , sidebar
    , sidebarWidth
    , sidebarToTree
    , header
    , content
    , footer
    , toHtml
    , LayoutTree
    , Header
    , Content
    , Footer
    )


import Css exposing (width, px)
import Html exposing (Html, Attribute, div, aside)
import Html.Styled as Styled exposing (toUnstyled, fromUnstyled)
import Html.Attributes exposing (style)
import Html.Styled.Attributes exposing (css)


type Header msg = Header (Html msg)
type Content msg = Content (Html msg)
type Footer msg = Footer (Html msg)

header : Html msg -> LayoutTree msg
header = HeaderNode << Header


content : Html msg -> LayoutTree msg
content = ContentNode << Content


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


type Sidebar msg = Sidebar SidebarOptions (Html msg)


sidebar : Html msg -> Sidebar msg
sidebar = Sidebar defaultSidebarOptions

sidebarWidth : Float -> Sidebar msg -> Sidebar msg
sidebarWidth width (Sidebar opts sidebarContent) =
    let
        newOpts = { opts | width = width }
    in
        Sidebar newOpts sidebarContent


sidebarToTree : Sidebar msg -> LayoutTree msg
sidebarToTree = SideBarNode


-------------------------------------------
-------------------------------------------
------ General Layout Types and fns

type LayoutTree msg
    = SideBarNode (Sidebar msg)
    | HeaderNode (Header msg)
    | ContentNode (Content msg)
    | FooterNode (Footer msg)
    | LayoutTree2 (LayoutTree msg) (LayoutTree msg)
    | LayoutTree3 (LayoutTree msg) (LayoutTree msg) (LayoutTree msg) 


layout : LayoutTree msg -> LayoutTree msg -> LayoutTree msg -> LayoutTree msg
layout firstSibling secondSibling thirdSibling =
    LayoutTree3 firstSibling secondSibling thirdSibling


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
