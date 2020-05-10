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
import Css exposing
    ( Style
    , alignItems
    , center
    , displayFlex
    , height
    , marginRight
    , paddingLeft
    , paddingRight
    , px
    , width
    )
import Dict exposing (Dict)
import Html exposing (Html, a, div, text, header, nav)
import Html.Styled as Styled exposing (toUnstyled)
import Html.Styled.Attributes exposing (css, href, src, alt)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)

import Routes.ButtonComponent as ButtonPage
import Routes.TypographyComponent as TypographyPage
import Routes.TooltipComponent as TooltipPage
import UI.Typography exposing (logoText)
import UI.Footer exposing (footer)
import Utils exposing (ComponentCategory(..))

type alias Route =
    String


type alias Model =
    { activeRoute : Route
    , buttonPageModel : ButtonPage.Model
    , typographyPageModel : TypographyPage.Model
    , tooltipPageModel : TooltipPage.Model
    }


type alias Href = String

type Msg
    = UrlChanged Url
    | MenuItemClicked Href
    | ButtonPageMessage ButtonPage.Msg
    | TooltipPageMessage TooltipPage.Msg
    | TypographyPageMessage


componentList : List ( Route, ComponentCategory, Model -> Styled.Html Msg )
componentList =
    let
        buttonPageView model =
            ButtonPage.route.view model.buttonPageModel
                |> Styled.map ButtonPageMessage
        
        typographyPageView model = 
            TypographyPage.route.view model.typographyPageModel
                |> Styled.map never

        tooltipPageView model =
            TooltipPage.route.view model.tooltipPageModel
                |> Styled.map TooltipPageMessage
    in
    [ ( ButtonPage.route.title, ButtonPage.route.category, buttonPageView )
    , ( TypographyPage.route.title, TypographyPage.route.category, typographyPageView )
    , ( TooltipPage.route.title, TooltipPage.route.category, tooltipPageView )
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
        routeParsers =
            List.map
                (\( pageTitle, _, _ ) -> Parser.map pageTitle (s "components" </> s (String.toLower pageTitle)))
                componentList
    in
    oneOf routeParsers


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
                (buttonPageModel, buttonPageCmd) =
                    ButtonPage.route.update buttonPageMsg model.buttonPageModel

            in
            ( { model |
                buttonPageModel = buttonPageModel
              }
            , Cmd.map ButtonPageMessage buttonPageCmd
            )

        TooltipPageMessage tooltipPageMessage ->
            let
                (tooltipPageModel, tooltipPageCmd ) =
                    TooltipPage.route.update tooltipPageMessage model.tooltipPageModel
            in
            ( { model |
                tooltipPageModel =  tooltipPageModel
              }
            , Cmd.map TooltipPageMessage tooltipPageCmd
            )

        TypographyPageMessage ->
            ( model, Cmd.none )
            

navBar : Styled.Html msg
navBar =
    let
        headerStyles =
            css
                [ displayFlex
                , height (px 64)
                , Css.boxShadow5 (px 0) (px 2) (px 8) (px 0) (Css.rgb 240 241 242)
                ]     

        verticalCenteringStyles : List Style
        verticalCenteringStyles =
            [ displayFlex, alignItems center ]
    in
    Styled.header [ headerStyles ]
        [ Styled.div
            [ css
                (verticalCenteringStyles ++
                    [ width (px 266), paddingLeft (px 32)]
                )
            ]
            [ Styled.img
                [ alt "logo"
                , src "https://github.com/gDelgado14/elm-antd/raw/master/logo.svg"
                , css [ height (px 50), marginRight (px 10) ]
                ] []
            , logoText
            ]
        -- Search Bar Placeholder for Algolia Search Bar
        , Styled.div [ css verticalCenteringStyles ]
            [ Styled.text "search coming soon ..."
            ]
        , Styled.nav [ css verticalCenteringStyles ]
            [ Styled.a [ href "https://ant.design/docs/spec/introduce" ] [ Styled.text "Design" ]
            , Styled.a [ href "https://github.com/gDelgado14/elm-antd/blob/master/README.md" ] [ Styled.text "Docs" ]
            , Styled.a [ href "https://ant.design/docs/resources" ] [ Styled.text "Resources" ]
            , Styled.a [ href "https://github.com/gDelgado14/elm-antd" ] [ Styled.text "gh" ]
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
    Menu.view menu



getPageTitleAndContentView : Route -> ( Route, Model -> Styled.Html Msg )
getPageTitleAndContentView activeRoute =
    let
        notFoundPage = 
            ( "404", \_ -> Styled.div [] [ Styled.text "404 not found" ] )
    in
    List.filter
        (\(pageTitle, _, _) -> pageTitle == activeRoute)
        componentList
    |> List.map
        (\(pageTitle, _, content) -> (pageTitle, content))
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
                        (Layout.footer <| toUnstyled footer))
                )

    in
    { title = label ++ " - Elm Ant Design"
    , body = [ Html.map toMsg <| Layout.toHtml layout ]
    }
