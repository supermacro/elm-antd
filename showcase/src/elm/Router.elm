module Router exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Ant.Layout as Layout exposing (LayoutTree)
import Ant.Menu as Menu exposing (Menu, ItemGroup)
import Browser
import Css exposing
    ( Style
    , alignItems
    , center
    , displayFlex
    , height
    , marginRight
    , paddingLeft
    , paddingRight
    , paddingTop
    , px
    , vw
    , width
    )
import Dict exposing (Dict)
import Html exposing (Html, a, div, li, text, ul, header, nav)
import Html.Styled as Styled exposing (fromUnstyled, toUnstyled)
import Html.Styled.Attributes exposing (css, href, src, alt)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)

import Routes.ButtonComponent as ButtonPage
import Routes.TypographyComponent as TypographyPage
import UI.Container as Container exposing (container)
import UI.Typography exposing (logoText)
import Utils exposing (ComponentCategory(..))

type alias Route =
    String


type alias Model =
    { activeRoute : Route
    }


type Msg
    = UrlChange Url
    | ButtonPageMessage
    | TypographyPageMessage


componentList : List ( Route, ComponentCategory )
componentList =
    [ ( ButtonPage.route.title, ButtonPage.route.category )
    , ( TypographyPage.route.title, TypographyPage.route.category )
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
                (\( pageTitle, _ ) -> Parser.map pageTitle (s "components" </> s (String.toLower pageTitle)))
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
    ( { activeRoute = route }
    , Cmd.none
    )


update : Msg -> Model -> Model
update msg model =
    case msg of
        UrlChange url ->
            let
                newRoute =
                    fromUrl url
            in
            { model | activeRoute = newRoute }

        _ -> model


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
            [ container (Styled.text "search coming soon ...")
                |> Container.noTopBorder
                |> Container.noRightBorder
                |> Container.noBottomBorder
                |> Container.paddingTop 0
                |> Container.paddingBottom 0
                |> Container.paddingLeft 16
                |> Container.toHtml
            ]
        , Styled.nav [ css verticalCenteringStyles ]
            [ Styled.a [ href "https://ant.design/docs/spec/introduce" ] [ Styled.text "Design" ]
            , Styled.a [ href "https://github.com/gDelgado14/elm-antd/blob/master/README.md" ] [ Styled.text "Docs" ]
            , Styled.a [ href "https://ant.design/docs/resources" ] [ Styled.text "Resources" ]
            , Styled.a [ href "https://github.com/gDelgado14/elm-antd" ] [ Styled.text "gh" ]
            ]
        ]



componentMenu : Route -> Html msg
componentMenu activeRoute =
    let
        getList : Maybe (List Route) -> List Route
        getList =
            Maybe.withDefault []

        categoryDict : Dict String (List Route)
        categoryDict =
            List.foldl
                (\( pageTitle, componentCategory ) categoryDictAccumulator ->
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

        addItemGroup : String -> List String -> Menu msg -> Menu msg
        addItemGroup categoryName componentNames currentMenu =
            let
                itemGroup =
                    Menu.initItemGroup categoryName <|
                        List.map 
                            (\componentName ->
                                let
                                    menuItem =
                                        Menu.initMenuItem
                                            ("/components/" ++ String.toLower componentName)
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

        menu : Menu msg
        menu =
            Dict.foldl
                addItemGroup
                Menu.initMenu
                categoryDict

    in
    Menu.view menu


view : (Msg -> msg) -> Model -> Browser.Document msg
view toMsg model =
    let
        ( label, componentContent ) =
            if model.activeRoute == ButtonPage.route.title then
                ( model.activeRoute
                , ButtonPage.route.view (toMsg ButtonPageMessage)
                    |> toUnstyled
                )

            else if model.activeRoute == TypographyPage.route.title then
                ( model.activeRoute
                , TypographyPage.route.view (toMsg TypographyPageMessage)
                    |> toUnstyled
                )

            else
                ( "404", div [] [ text "404 not found" ] )

        componentPageShell =
            let
                styledComponentContent =
                    fromUnstyled componentContent
            in
            Styled.div
                [ css
                    [ paddingRight (px 170)
                    , paddingLeft (px 64)
                    , width (vw 100)
                    ]
                ]
                [ styledComponentContent ]

        sidebar =
            Layout.sidebar (componentMenu model.activeRoute)
            |> Layout.sidebarWidth 266
            |> Layout.sidebarToTree

        layout : LayoutTree msg
        layout =
            Layout.layout2
                (Layout.header <| toUnstyled navBar)
                (Layout.layout2
                    sidebar
                    (Layout.content <| toUnstyled componentPageShell))
    in
    { title = label ++ " - Elm Ant Design"
    , body = [ Layout.toHtml layout ]
    }
