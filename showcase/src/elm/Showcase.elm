module Showcase exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, div, text)
import Url

import Router

type alias Model =
  { navKey : Nav.Key
  , router : Router.Model
  }


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


init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  let
    (routerModel, routerCmd) = Router.init url
  in
  ( { navKey = key
    , router = routerModel
    }
  , Cmd.map RouterMsg routerCmd
  )


type Msg
  = UrlChanged Url.Url
  | LinkClicked Browser.UrlRequest
  | RouterMsg Router.Msg

-- model -> Document msg
view : Model -> Browser.Document Msg
view model =
  Router.view RouterMsg model.router


updateRouter : Router.Msg -> Model -> ( Model, Cmd Msg )
updateRouter routerMsg model =
  let
    newRouterModel = Router.update routerMsg model.router
  in
    ( { model | router =  newRouterModel }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    RouterMsg routerMsg ->
      updateRouter routerMsg model

    UrlChanged url ->
      updateRouter (Router.UrlChange url) model

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
