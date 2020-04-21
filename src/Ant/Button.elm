module Ant.Button exposing (button, onClick, toHtml)

import Ant.Palette exposing (primaryColor, primaryColorFaded, primaryColorStrong)
import Css exposing (..)
import Html exposing (Html)
import Html.Styled as H exposing (text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events as Events



-- TODO:
-- animate click: https://webdevtrick.com/pure-css-click-effect/
-- https://old.reddit.com/r/css/comments/g5fho5/how_to_create_ants_button_onclick_box_shadow_fade/


type ButtonType
    = Primary
    | DefaultButton
    | Dashed
    | Link


type ButtonSize
    = Large
    | DefaultSize
    | Small


type alias Options msg =
    { type_ : ButtonType
    , size : ButtonSize
    , color : String
    , disabled : Bool
    , loading : Bool
    , primary : Bool
    , href : Maybe String
    , onClick : Maybe msg
    

    -- icon : Icon
    -- size : Size (Small, Medium, Large)
    -- etc etc
    }


defaultOptions : Options msg
defaultOptions =
    { type_ = Primary
    , size = DefaultSize
    , color = "#fff"
    , disabled = False
    , loading = False
    , primary = True
    , href = Nothing
    , onClick = Nothing
    }


type Button msg
    = Button (Options msg) String


button : String -> Button msg
button label =
    Button defaultOptions label


onClick : msg -> Button msg -> Button msg
onClick msg (Button opts label) =
  let
    newOpts = { opts | onClick = Just msg }
  in
    Button newOpts label


toHtml : Button msg -> Html msg
toHtml (Button options label) =
    let
        defaultAttributes =
            [ css
                [ borderRadius (px 2)
                , backgroundColor primaryColor
                , padding2 (px 4) (px 15)
                , border3 (px 2) solid primaryColor
                , color (hex "#fff")
                , fontSize (px 14)
                , height (px 34)
                , outline none
                , focus
                    [ backgroundColor primaryColorFaded
                    , borderColor primaryColorFaded
                    ]
                , hover
                    [ backgroundColor primaryColorFaded
                    , borderColor primaryColorFaded
                    ]
                , active
                    [ backgroundColor primaryColorStrong
                    , borderColor primaryColorStrong
                    ]
                ]
            ]
        
        attributes =
            case options.onClick of
                Just msg ->
                    Events.onClick msg :: defaultAttributes

                Nothing ->
                    defaultAttributes                

    in
    toUnstyled
        (H.button
            attributes
            [ H.span [] [ text label ] ]
        )
