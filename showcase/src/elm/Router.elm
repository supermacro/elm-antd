module Router exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Ant.Css
import Ant.Layout as Layout exposing (LayoutTree)
import Ant.Menu as Menu exposing (Menu)
import Ant.Theme exposing (createTheme)
import Base64
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
import Http
import Routes.AlertComponent as AlertPage
import Routes.ButtonComponent as ButtonPage
import Routes.DividerComponent as DividerPage
import Routes.Home exposing (homePage)
import Routes.InputComponent as InputPage
import Routes.NotFound exposing (notFound)
import Routes.NotImplemented exposing (notImplemented)
import Routes.SpaceComponent as SpacePage
import Routes.TooltipComponent as TooltipPage
import Routes.TypographyComponent as TypographyPage
import Task
import UI.Footer as Footer exposing (footer)
import UI.Icons
import UI.Typography exposing (logoText)
import UI.Utils exposing (colorToInt)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)
import Utils exposing (ComponentCategory(..), Flags, RawSourceCode, SourceCode)


type alias CommitHash =
    Maybe String


type alias Route =
    String


type alias Model =
    { activeRoute : Route

    -- Contains state around which pages
    -- already have their example code loaded
    -- into memory
    , examplesFetched : List Route

    -- This is used to fetch source code from a particular commit
    -- Locally, this value will be Nothing / null
    -- and files will be fetched from the file system
    --
    -- You'll need to be running the file-server locally
    , commitHash : CommitHash
    , fileServerUrl : String
    , footer : Footer.Model

    -- sub models for each page
    , alertPageModel : AlertPage.Model
    , buttonPageModel : ButtonPage.Model
    , dividerPageModel : DividerPage.Model
    , inputPageModel : InputPage.Model
    , spacePageModel : SpacePage.Model
    , typographyPageModel : TypographyPage.Model
    , tooltipPageModel : TooltipPage.Model
    }


type alias Href =
    String


type Msg
    = UrlChanged Url
    | MenuItemClicked Href
    | AlertPageMessage AlertPage.Msg
    | ButtonPageMessage ButtonPage.Msg
    | DividerPageMessage DividerPage.Msg
    | InputPageMessage InputPage.Msg
    | SpacePageMessage SpacePage.Msg
    | TooltipPageMessage TooltipPage.Msg
    | TypographyPageMessage TypographyPage.Msg
      -- represents the outcome of having asynchronously fetched
      -- the source code of the examples for a particular component page
    | ComponentPageReceivedExamples Route (Result Http.Error (List RawSourceCode))
    | FooterMessage Footer.Msg


type alias Component =
    { route : Route
    , category : ComponentCategory
    , view : Model -> Styled.Html Msg
    , saveExampleSourceCode : List SourceCode -> Cmd Msg
    }


unimplementedComponents : List Component
unimplementedComponents =
    let
        createUnimplementedComponentRoute ( componentName, category ) =
            { route = componentName
            , category = category
            , view = \_ -> notImplemented componentName
            , saveExampleSourceCode = \_ -> Cmd.none
            }
    in
    List.map createUnimplementedComponentRoute
        [ ( "Grid", Layout )
        , ( "Affix", Navigation )
        , ( "Breadcrumb", Navigation )
        , ( "Dropdown", Navigation )
        , ( "Pagination", Navigation )
        , ( "PageHeader", Navigation )
        , ( "Steps", Navigation )
        , ( "AutoComplete", DataEntry )
        , ( "Checkbox", DataEntry )
        , ( "Cascader", DataEntry )
        , ( "DatePicker", DataEntry )
        , ( "Form", DataEntry )
        , ( "InputNumber", DataEntry )
        , ( "Mentions", DataEntry )
        , ( "Rate", DataEntry )
        , ( "Radio", DataEntry )
        , ( "Switch", DataEntry )
        , ( "Slider", DataEntry )
        , ( "Select", DataEntry )
        , ( "TreeSelect", DataEntry )
        , ( "Transfer", DataEntry )
        , ( "TimePicker", DataEntry )
        , ( "Upload", DataEntry )
        , ( "Avatar", DataDisplay )
        , ( "Badge", DataDisplay )
        , ( "Comment", DataDisplay )
        , ( "Collapse", DataDisplay )
        , ( "Carousel", DataDisplay )
        , ( "Card", DataDisplay )
        , ( "Calendar", DataDisplay )
        , ( "Descriptions", DataDisplay )
        , ( "Empty", DataDisplay )
        , ( "List", DataDisplay )
        , ( "Popover", DataDisplay )
        , ( "Statistic", DataDisplay )
        , ( "Tree", DataDisplay )
        , ( "Timeline", DataDisplay )
        , ( "Tag", DataDisplay )
        , ( "Tabs", DataDisplay )
        , ( "Table", DataDisplay )
        , ( "Drawer", Feedback )
        , ( "Modal", Feedback )
        , ( "Message", Feedback )
        , ( "Notification", Feedback )
        , ( "Progress", Feedback )
        , ( "Popconfirm", Feedback )
        , ( "Result", Feedback )
        , ( "Spin", Feedback )
        , ( "Skeleton", Feedback )
        , ( "Anchor", Other )
        , ( "BackTop", Other )
        , ( "ConfigProvider", Other )
        ]


triggerSaveExampleSourceCode : (msg -> Msg) -> (List SourceCode -> msg) -> List SourceCode -> Cmd Msg
triggerSaveExampleSourceCode tagger subMsgTagger examplesSourceCode =
    let
        subMsg =
            subMsgTagger examplesSourceCode

        task =
            Task.succeed subMsg
    in
    Task.perform tagger task


componentList : List Component
componentList =
    let
        alertPageView model =
            AlertPage.route.view model.alertPageModel
                |> Styled.map AlertPageMessage

        buttonPageView model =
            ButtonPage.route.view model.buttonPageModel
                |> Styled.map ButtonPageMessage

        dividerPageView model =
            DividerPage.route.view model.dividerPageModel
                |> Styled.map DividerPageMessage

        inputPageView model =
            InputPage.route.view model.inputPageModel
                |> Styled.map InputPageMessage

        spacePageView model =
            SpacePage.route.view model.spacePageModel
                |> Styled.map SpacePageMessage

        typographyPageView model =
            TypographyPage.route.view model.typographyPageModel
                |> Styled.map TypographyPageMessage

        tooltipPageView model =
            TooltipPage.route.view model.tooltipPageModel
                |> Styled.map TooltipPageMessage
    in
    [ { route = ButtonPage.route.title
      , category = ButtonPage.route.category
      , view = buttonPageView
      , saveExampleSourceCode =
            triggerSaveExampleSourceCode ButtonPageMessage ButtonPage.route.saveExampleSourceCodeToModel
      }
    , { route = AlertPage.route.title
      , category = AlertPage.route.category
      , view = alertPageView
      , saveExampleSourceCode =
            triggerSaveExampleSourceCode AlertPageMessage AlertPage.route.saveExampleSourceCodeToModel
      }
    , { route = DividerPage.route.title
      , category = DividerPage.route.category
      , view = dividerPageView
      , saveExampleSourceCode =
            triggerSaveExampleSourceCode DividerPageMessage DividerPage.route.saveExampleSourceCodeToModel
      }
    , { route = InputPage.route.title
      , category = InputPage.route.category
      , view = inputPageView
      , saveExampleSourceCode =
            triggerSaveExampleSourceCode InputPageMessage InputPage.route.saveExampleSourceCodeToModel
      }
    , { route = SpacePage.route.title
      , category = SpacePage.route.category
      , view = spacePageView
      , saveExampleSourceCode =
            triggerSaveExampleSourceCode SpacePageMessage SpacePage.route.saveExampleSourceCodeToModel
      }
    , { route = TypographyPage.route.title
      , category = TypographyPage.route.category
      , view = typographyPageView
      , saveExampleSourceCode =
            triggerSaveExampleSourceCode TypographyPageMessage TypographyPage.route.saveExampleSourceCodeToModel
      }
    , { route = TooltipPage.route.title
      , category = TooltipPage.route.category
      , view = tooltipPageView
      , saveExampleSourceCode =
            triggerSaveExampleSourceCode TooltipPageMessage TooltipPage.route.saveExampleSourceCodeToModel
      }
    ]
        ++ unimplementedComponents


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
                (\{ route } -> Parser.map route (s "components" </> s (String.toLower route)))
                componentList
    in
    oneOf <| homeParser :: routeParsers


fromUrl : Url -> Route
fromUrl =
    Maybe.withDefault "NotFound" << Parser.parse parser


fetchComponentExamples : Model -> Route -> Cmd Msg
fetchComponentExamples { commitHash, fileServerUrl, examplesFetched } routeName =
    let
        tagger =
            ComponentPageReceivedExamples routeName

        fileFetcher =
            Utils.fetchComponentExamples fileServerUrl commitHash

        shouldFetchExamples =
            (not <| List.member routeName examplesFetched)
                && (not <|
                        List.member routeName <|
                            List.map (\{ route } -> route) unimplementedComponents
                   )
    in
    if shouldFetchExamples then
        fileFetcher routeName tagger

    else
        Cmd.none


init : Url -> Flags -> ( Model, Cmd Msg )
init url { commitHash, fileServerUrl } =
    let
        route =
            fromUrl url

        model =
            { activeRoute = route
            , examplesFetched = []
            , commitHash = commitHash
            , fileServerUrl = fileServerUrl
            , footer = Footer.initialModel
            , alertPageModel = AlertPage.route.initialModel
            , buttonPageModel = ButtonPage.route.initialModel
            , dividerPageModel = DividerPage.route.initialModel
            , inputPageModel = InputPage.route.initialModel
            , spacePageModel = SpacePage.route.initialModel
            , typographyPageModel = TypographyPage.route.initialModel
            , tooltipPageModel = TooltipPage.route.initialModel
            }
    in
    ( model
    , fetchComponentExamples model route
    )


updateComponentModelWithExampleSourceFiles : Route -> List SourceCode -> Cmd Msg
updateComponentModelWithExampleSourceFiles routeName sourceCodeList =
    componentList
        |> List.filter (\{ route } -> route == routeName)
        |> List.head
        |> Maybe.map (\{ saveExampleSourceCode } -> saveExampleSourceCode sourceCodeList)
        |> Maybe.withDefault Cmd.none


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        UrlChanged url ->
            let
                newRoute =
                    fromUrl url
            in
            ( { model | activeRoute = newRoute }
            , fetchComponentExamples model newRoute
            )

        MenuItemClicked hrefString ->
            ( model, Nav.pushUrl navKey hrefString )

        FooterMessage footerMsg ->
            ( { model | footer = Footer.update footerMsg model.footer }
            , Cmd.none
            )

        ComponentPageReceivedExamples routeName fetchResult ->
            let
                decodeFileContents : List RawSourceCode -> Result String (List SourceCode)
                decodeFileContents rawFiles =
                    rawFiles
                        |> List.map
                            (\{ fileName, base64File } -> { fileName = fileName, result = Base64.decode base64File })
                        |> List.foldl
                            (\{ fileName, result } fileContentsResult ->
                                case ( fileContentsResult, result ) of
                                    ( Ok sourceCodeList, Ok sourceCode ) ->
                                        Ok <| { fileName = fileName, fileContents = sourceCode } :: sourceCodeList

                                    ( Ok _, Err reason ) ->
                                        Err <| "[" ++ fileName ++ "] - " ++ reason

                                    ( Err reason, _ ) ->
                                        Err reason
                            )
                            (Ok [])

                decodedFileListResult =
                    fetchResult
                        |> Result.mapError (\_ -> "http error")
                        |> Result.andThen decodeFileContents
            in
            case decodedFileListResult of
                Ok decodedFileList ->
                    ( { model | examplesFetched = routeName :: model.examplesFetched }
                    , updateComponentModelWithExampleSourceFiles routeName decodedFileList
                    )

                -- TODO: do some sort of error logging
                Err e ->
                    ( model, Cmd.none )

        AlertPageMessage alertPageMsg ->
            let
                ( alertPageModel, alertPageCmd ) =
                    AlertPage.route.update alertPageMsg model.alertPageModel
            in
            ( { model | alertPageModel = alertPageModel }
            , Cmd.map AlertPageMessage alertPageCmd
            )

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

        DividerPageMessage dividerPageMsg ->
            let
                ( dividerPageModel, dividerPageCmd ) =
                    DividerPage.route.update dividerPageMsg model.dividerPageModel
            in
            ( { model
                | dividerPageModel = dividerPageModel
              }
            , Cmd.map DividerPageMessage dividerPageCmd
            )

        InputPageMessage inputPageMsg ->
            let
                ( inputPageModel, inputPageCmd ) =
                    InputPage.route.update inputPageMsg model.inputPageModel
            in
            ( { model
                | inputPageModel = inputPageModel
              }
            , Cmd.map InputPageMessage inputPageCmd
            )

        SpacePageMessage spacePageMsg ->
            let
                ( spacePageModel, spacePageCmd ) =
                    SpacePage.route.update spacePageMsg model.spacePageModel
            in
            ( { model
                | spacePageModel = spacePageModel
              }
            , Cmd.map SpacePageMessage spacePageCmd
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
                    , src "https://github.com/supermacro/elm-antd/raw/master/logo.svg"
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
                (\{ route, category } categoryDictAccumulator ->
                    let
                        categoryString =
                            categoryToString category

                        categoryComponentNames =
                            getList <| Dict.get categoryString categoryDictAccumulator

                        updatedCategoryComponentNames =
                            route :: categoryComponentNames
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
    toUnstyled <|
        Styled.div
            [ css
                [ height (Css.vh 100)
                , Css.overflowY Css.scroll
                , Css.position Css.sticky
                , Css.top Css.zero
                ]
            ]
            [ fromUnstyled <| Menu.toHtml menu ]


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
            (\{ route } -> route == activeRoute)
            componentList
            |> List.map
                (\component -> ( component.route, component.view ))
            |> List.head
            |> Maybe.withDefault notFoundPage


view : (Msg -> msg) -> Model -> Browser.Document msg
view toMsg model =
    let
        currentThemePrimaryColor =
            model.footer.color

        theme =
            createTheme currentThemePrimaryColor

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
                        (Layout.footer <| toUnstyled <| Styled.map FooterMessage <| footer model.footer)
                    )
                )
    in
    { title = label ++ " - Elm Ant Design"
    , body =
        [ Ant.Css.createThemedStyles theme
        , Html.map toMsg <| Layout.toHtml layout
        ]
    }
