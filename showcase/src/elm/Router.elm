module Router exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Browser
import Css exposing (paddingLeft, paddingRight, px, vw, width)
import Dict exposing (Dict)
import Html as Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (style)
import Html.Styled as Styled exposing (fromUnstyled, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Routes.ButtonComponent as ButtonPage
import Routes.TypographyComponent as TypographyPage
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)
import Utils exposing (ComponentCategory(..), styleSheet)


type alias Route =
    String


type alias Model =
    { activeRoute : Route
    }


type Msg
    = UrlChange Url
    | ButtonPageMessage ButtonPage.Msg


componentList : List ( Route, ComponentCategory )
componentList =
    [ ( ButtonPage.title, ButtonPage.category )
    , ( TypographyPage.title, TypographyPage.category )
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

        ButtonPageMessage buttonPageMsg ->
            model


navBar : Route -> Html msg
navBar activeRoute =
    let
        styles =
            styleSheet
                [ ( "width", "266px" )
                ]

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

        viewCategoryList : String -> List String -> Html msg
        viewCategoryList categoryName componentNames =
            let
                componenentList =
                    List.map (\componentName -> li [] [ text componentName ]) componentNames
            in
            div [] [ text categoryName, ul [] componenentList ]

        navList : List (Html msg)
        navList =
            Dict.foldl (\categoryName componentNames navListAccumulator -> List.append navListAccumulator [ viewCategoryList categoryName componentNames ]) [] categoryDict
    in
    div styles navList


view : (Msg -> msg) -> Model -> Browser.Document msg
view toMsg model =
    let
        ( label, componentContent ) =
            if model.activeRoute == ButtonPage.title then
                ButtonPage.view
                    |> Tuple.mapSecond (Html.map ButtonPageMessage)
                    |> Tuple.mapSecond (Html.map toMsg)

            else if model.activeRoute == TypographyPage.title then
                TypographyPage.view

            else
                ( "404", div [] [ text "404 not found" ] )

        componentPageShell =
            let
                styledComponentContent =
                    fromUnstyled componentContent
            in
            Styled.div [ css [ paddingRight (px 170), paddingLeft (px 64), width (vw 100) ] ] [ styledComponentContent ]
    in
    { title = label ++ " - Elm Ant Design"
    , body =
        [ div []
            [ div [] [ text "navbar" ]
            , div [ style "display" "flex" ]
                [ navBar model.activeRoute
                , toUnstyled componentPageShell
                ]
            ]
        ]
    }
