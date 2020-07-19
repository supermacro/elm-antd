module Showcase exposing (main)

import Browser
import Browser.Navigation as Nav
import Router
import Url
import Utils exposing (Flags)


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | RouterMsg Router.Msg


type alias Model =
    { navKey : Nav.Key
    , router : Router.Model
    }


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( routerModel, routerCmd ) =
            Router.init url flags
    in
    ( { navKey = key
      , router = routerModel
      }
    , Cmd.map RouterMsg routerCmd
    )


view : Model -> Browser.Document Msg
view model =
    Router.view RouterMsg model.router


updateRouter : Nav.Key -> Router.Msg -> Model -> ( Model, Cmd Msg )
updateRouter navKey routerMsg model =
    let
        ( newRouterModel, routerCommand ) =
            Router.update navKey routerMsg model.router
    in
    ( { model | router = newRouterModel }, Cmd.map RouterMsg routerCommand )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouterMsg routerMsg ->
            updateRouter model.navKey routerMsg model

        UrlChanged url ->
            updateRouter model.navKey (Router.UrlChanged url) model

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey <| Url.toString url
                    )

                -- leaving the app!
                Browser.External urlStr ->
                    ( model
                    , Nav.load urlStr
                    )
