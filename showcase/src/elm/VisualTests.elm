module VisualTests exposing (main)

{-| This is the entrypoint for the application in "Visual Test" mode

This app is controlled via the URL:

  - <http://localhost:3000?component=SimpleButton>

Given a `component` query param, render the associated component

-}

import Ant.Button as Btn exposing (ButtonType(..), button)
import Ant.Typography as Heading exposing (Level(..), title)
import Browser
import Browser.Navigation as Nav
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Url exposing (Url)
import Url.Parser as P exposing ((<?>), Parser, parse)
import Url.Parser.Query as Query


type alias Model =
    { component : Component
    , label : String
    }


type Msg
    = UrlChanged Url
    | LinkClicked Browser.UrlRequest


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias ButtonConfig =
    { type_ : ButtonType
    , disabled : Bool
    }


type alias TypographyConfig =
    { level : Heading.Level }


type Component
    = Button ButtonConfig
    | Typography TypographyConfig


type RawComponent
    = RawComponent (Maybe String)


{-| Represents the set of components that are known and properly configured to be tested
-}
registeredComponents : List ( String, Component )
registeredComponents =
    [ ( "SimpleButton", Button { type_ = Default, disabled = False } )
    , ( "PrimaryButton", Button { type_ = Primary, disabled = False } )
    , ( "DashedButton", Button { type_ = Dashed, disabled = False } )
    , ( "TextButton", Button { type_ = Text, disabled = False } )
    , ( "LinkButton", Button { type_ = Link, disabled = False } )

    -- Headings
    , ( "SimpleHeading", Typography { level = H1 } )
    ]


getRegisteredComponentFromLabel : String -> Maybe ( String, Component )
getRegisteredComponentFromLabel searchString =
    List.filter (\( label, _ ) -> label == searchString) registeredComponents
        |> List.head


intoComponent : RawComponent -> Component
intoComponent (RawComponent maybeStr) =
    case maybeStr of
        Just componentQueryParamValue ->
            getRegisteredComponentFromLabel componentQueryParamValue
                |> Maybe.map (\( _, component ) -> component)
                |> Maybe.withDefault (Button { type_ = Default, disabled = False })

        Nothing ->
            Button { type_ = Default, disabled = False }


componentParser : Parser (RawComponent -> a) a
componentParser =
    P.map RawComponent (P.top <?> Query.string "component")


getComponentFromUrl : Url -> Model
getComponentFromUrl url =
    let
        maybeRawComponent =
            parse componentParser url

        rawComponent =
            Maybe.withDefault (RawComponent <| Just "SimpleButton") maybeRawComponent

        componentLabel =
            case rawComponent of
                RawComponent (Just componentQueryParamValue) ->
                    getRegisteredComponentFromLabel componentQueryParamValue
                        |> Maybe.map (\( label, _ ) -> label)
                        |> Maybe.withDefault "<<default>>"

                RawComponent Nothing ->
                    "<<default>>"
    in
    { component = intoComponent rawComponent
    , label = componentLabel
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url _ =
    ( getComponentFromUrl url, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


centerContents : Html msg -> Html msg
centerContents children =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        , style "height" "100%"
        ]
        [ children ]


buildComponent : Component -> Html msg
buildComponent component =
    case component of
        Button buttonConfig ->
            button "elm"
                |> Btn.withType buttonConfig.type_
                |> Btn.toHtml

        Typography typographyConfig ->
            title "elm"
                |> Heading.level typographyConfig.level
                |> Heading.toHtml


view : Model -> { title : String, body : List (Html msg) }
view { component, label } =
    let
        content =
            buildComponent component
    in
    { title = "Visual Tests - " ++ label
    , body = [ centerContents content ]
    }
