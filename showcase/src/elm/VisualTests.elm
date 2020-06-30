module VisualTests exposing (main)

{-| This is the entrypoint for the application in "Visual Test" mode

This app is controlled via the URL:

  - <http://localhost:3000?component=SimpleButton>

-}

import Ant.Button as Btn exposing (ButtonType(..), button)
import Ant.Typography as Heading exposing (Level(..), title)
import Browser
import Browser.Navigation as Nav
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Url exposing (Url)
import Url.Parser as P exposing ((<?>), Parser, oneOf, parse)
import Url.Parser.Query as Query


type Model
    = Model Component


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


componentParser : Parser (RawComponent -> a) a
componentParser =
    P.map RawComponent (P.top <?> Query.string "component")


intoComponent : RawComponent -> Component
intoComponent (RawComponent maybeStr) =
    case maybeStr of
        Just str ->
            case str of
                "SimpleButton" ->
                    Button { type_ = Default, disabled = False }

                "PrimaryButton" ->
                    Button { type_ = Primary, disabled = False }

                "SimpleHeading" ->
                    Typography { level = H1 }

                "DashedButton" ->
                    Button { type_ = Dashed, disabled = False }

                _ ->
                    Button { type_ = Default, disabled = False }

        Nothing ->
            Button { type_ = Default, disabled = False }


getComponentFromUrl : Url -> Component
getComponentFromUrl url =
    let
        maybeRawComponent =
            parse componentParser url

        rawComponent =
            Maybe.withDefault (RawComponent <| Just "SimpleButton") maybeRawComponent
    in
    intoComponent rawComponent



-- URL -> Model
-- Model -> View


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url _ =
    ( Model <| getComponentFromUrl url, Cmd.none )


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


buildComponent : Model -> Html msg
buildComponent (Model component) =
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
view model =
    let
        content =
            buildComponent model
    in
    { title = "Visual Tests"
    , body = [ centerContents content ]
    }
