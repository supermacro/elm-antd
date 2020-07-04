module Router exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Ant.Layout as Layout exposing (LayoutTree)
import Ant.Menu as Menu exposing (Menu)
import Browser
import Browser.Navigation as Nav
import Css
    exposing
        ( Style
        , alignItems
        , center
        , displayFlex
        , em
        , height
        , justifyContent
        , marginRight
        , none
        , paddingLeft
        , paddingRight
        , px
        , spaceBetween
        , textDecoration
        , width
        )
import Dict exposing (Dict)
import Html exposing (Html, a, div, header, nav, text)
import Html.Styled as Styled exposing (fromUnstyled, toUnstyled)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Routes.ButtonComponent as ButtonPage
import Routes.Home exposing (homePage)
import Routes.NotFound exposing (notFound)
import Routes.NotImplemented exposing (notImplemented)
import Routes.TooltipComponent as TooltipPage
import Routes.TypographyComponent as TypographyPage
import UI.Footer exposing (footer)
import UI.Icons
import UI.Typography exposing (logoText)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)
import Utils exposing (ComponentCategory(..))


type alias Route =
    String


type alias Model =
    { activeRoute : Route
    , buttonPageModel : ButtonPage.Model
    , typographyPageModel : TypographyPage.Model
    , tooltipPageModel : TooltipPage.Model
    }


type alias Href =
    String


type Msg
    = UrlChanged Url
    | MenuItemClicked Href
    | ButtonPageMessage ButtonPage.Msg
    | TooltipPageMessage TooltipPage.Msg
    | TypographyPageMessage TypographyPage.Msg


componentList : List ( Route, ComponentCategory, Model -> Styled.Html Msg )
componentList =
    let
        buttonPageView model =
            ButtonPage.route.view model.buttonPageModel
                |> Styled.map ButtonPageMessage

        typographyPageView model =
            TypographyPage.route.view model.typographyPageModel
                |> Styled.map TypographyPageMessage

        tooltipPageView model =
            TooltipPage.route.view model.tooltipPageModel
                |> Styled.map TooltipPageMessage
    in
    [ ( ButtonPage.route.title, ButtonPage.route.category, buttonPageView )
    , ( TypographyPage.route.title, TypographyPage.route.category, typographyPageView )
    , ( TooltipPage.route.title, TooltipPage.route.category, tooltipPageView )
    , ( "Breadcrumb", Navigation, \_ -> notImplemented "Breadcrumb" )
    ]


categoryToString : ComponentCategory -> String
categoryToString category =
    case category of
        General ->
            "General"

        Layout ->
            "Layout"

        Navigation ->
            "Navigation"

        DataEntry ->
            "Data Entry"

        DataDisplay ->
            "Data Display"

        Feedback ->
            "Feedback"

        Other ->
            "Other"


parser : Parser (Route -> a) a
parser =
    let
        homeParser =
            Parser.map "Home" Parser.top

        routeParsers =
            List.map
                (\( pageTitle, _, _ ) -> Parser.map pageTitle (s "components" </> s (String.toLower pageTitle)))
                componentList
    in
    oneOf <| homeParser :: routeParsers


fromUrl : Url -> Route
fromUrl =
    Maybe.withDefault "NotFound" << Parser.parse parser


init : Url -> ( Model, Cmd Msg )
init url =
    let
        route =
            fromUrl url
    in
    ( { activeRoute = route
      , buttonPageModel = ButtonPage.route.initialModel
      , typographyPageModel = TypographyPage.route.initialModel
      , tooltipPageModel = TooltipPage.route.initialModel
      }
    , Cmd.none
    )


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        UrlChanged url ->
            let
                newRoute =
                    fromUrl url
            in
            ( { model | activeRoute = newRoute }, Cmd.none )

        MenuItemClicked hrefString ->
            ( model, Nav.pushUrl navKey hrefString )

        ButtonPageMessage buttonPageMsg ->
            let
                ( buttonPageModel, buttonPageCmd ) =
                    ButtonPage.route.update buttonPageMsg model.buttonPageModel
            in
            ( { model
                | buttonPageModel = buttonPageModel
              }
            , Cmd.map ButtonPageMessage buttonPageCmd
            )

        TooltipPageMessage tooltipPageMessage ->
            let
                ( tooltipPageModel, tooltipPageCmd ) =
                    TooltipPage.route.update tooltipPageMessage model.tooltipPageModel
            in
            ( { model
                | tooltipPageModel = tooltipPageModel
              }
            , Cmd.map TooltipPageMessage tooltipPageCmd
            )

        TypographyPageMessage typographyPageMessage ->
            let
                ( typographyPageModel, typographyPageCmd ) =
                    TypographyPage.route.update typographyPageMessage model.typographyPageModel
            in
            ( { model
                | typographyPageModel = typographyPageModel
              }
            , Cmd.map TypographyPageMessage typographyPageCmd
            )


navBar : Styled.Html msg
navBar =
    let
        headerStyles =
            css
                [ displayFlex
                , height (px 64)
                , Css.boxShadow5 (px 0) (px 2) (px 8) (px 0) (Css.rgb 240 241 242)
                , justifyContent spaceBetween
                , paddingRight (em 2)
                ]

        verticalCenteringStyles : List Style
        verticalCenteringStyles =
            [ displayFlex, alignItems center ]
    in
    Styled.header [ headerStyles ]
        [ Styled.div
            [ css
                (verticalCenteringStyles
                    ++ [ width (px 266), paddingLeft (px 32) ]
                )
            ]
            [ Styled.a [ href "/", css (textDecoration none :: verticalCenteringStyles) ]
                [ Styled.img
                    [ alt "logo"
                    , src "https://github.com/gDelgado14/elm-antd/raw/master/logo.svg"
                    , css [ height (px 50), marginRight (px 10) ]
                    ]
                    []
                , logoText
                ]
            ]

        -- Search Bar Placeholder for Algolia Search Bar
        --, Styled.div [ css verticalCenteringStyles ]
        -- [ Styled.text "search coming soon ..."
        -- ]
        , Styled.nav [ css verticalCenteringStyles ]
            [ Styled.a [ href "https://github.com/supermacro/elm-antd" ] [ fromUnstyled UI.Icons.github ]
            ]
        ]


componentMenu : Route -> Html Msg
componentMenu activeRoute =
    let
        getList : Maybe (List Route) -> List Route
        getList =
            Maybe.withDefault []

        categoryDict : Dict String (List Route)
        categoryDict =
            List.foldl
                (\( pageTitle, componentCategory, _ ) categoryDictAccumulator ->
                    let
                        categoryString =
                            categoryToString componentCategory

                        categoryComponentNames =
                            getList <| Dict.get categoryString categoryDictAccumulator

                        updatedCategoryComponentNames =
                            pageTitle :: categoryComponentNames
                    in
                    Dict.insert categoryString updatedCategoryComponentNames categoryDictAccumulator
                )
                Dict.empty
                componentList

        addItemGroup : String -> List String -> Menu Msg -> Menu Msg
        addItemGroup categoryName componentNames currentMenu =
            let
                itemGroup =
                    Menu.initItemGroup categoryName <|
                        List.map
                            (\componentName ->
                                let
                                    menuItem =
                                        Menu.initMenuItem
                                            (MenuItemClicked <| "/components/" ++ String.toLower componentName)
                                            (text componentName)
                                in
                                if activeRoute == componentName then
                                    Menu.selected menuItem

                                else
                                    menuItem
                            )
                            componentNames
            in
            Menu.pushItemGroup itemGroup currentMenu

        menu : Menu Msg
        menu =
            Dict.foldl
                addItemGroup
                Menu.initMenu
                categoryDict
    in
    Menu.toHtml menu


getPageTitleAndContentView : Route -> ( Route, Model -> Styled.Html Msg )
getPageTitleAndContentView activeRoute =
    let
        notFoundPage =
            ( "404", \_ -> notFound )
    in
    if activeRoute == "Home" then
        ( "Welcome", \_ -> homePage )

    else
        List.filter
            (\( pageTitle, _, _ ) -> pageTitle == activeRoute)
            componentList
            |> List.map
                (\( pageTitle, _, content ) -> ( pageTitle, content ))
            |> List.head
            |> Maybe.withDefault notFoundPage


view : (Msg -> msg) -> Model -> Browser.Document msg
view toMsg model =
    let
        ( label, componentContentView ) =
            getPageTitleAndContentView model.activeRoute

        componentPageShell =
            Styled.div
                [ css
                    [ paddingRight (px 170)
                    , paddingLeft (px 64)
                    ]
                ]
                [ componentContentView model ]

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
                        (Layout.footer <| toUnstyled footer)
                    )
                )
    in
    { title = label ++ " - Elm Ant Design"
    , body = [ Html.map toMsg <| Layout.toHtml layout ]
    }
