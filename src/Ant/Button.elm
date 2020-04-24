module Ant.Button exposing
    ( button
    , onClick
    , toHtml
    , withType
    , ButtonType(..)
    )

import Ant.Palette exposing (primaryColor, primaryColorFaded, primaryColorStrong)
import Ant.Typography.Text exposing (textColorRgba)
import Css exposing (..)
import Css.Transitions exposing (transition)
import Html exposing (Html)
import Html.Styled as H exposing (text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events as Events



-- TODO:
-- animate click: https://webdevtrick.com/pure-css-click-effect/
-- https://old.reddit.com/r/css/comments/g5fho5/how_to_create_ants_button_onclick_box_shadow_fade/


type ButtonType
    = Primary
    | Default
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
    , href : Maybe String
    , onClick : Maybe msg
    

    -- icon : Icon
    -- size : Size (Small, Medium, Large)
    -- etc etc
    }


defaultOptions : Options msg
defaultOptions =
    { type_ = Default
    , size = DefaultSize
    , color = "#fff"
    , disabled = False
    , loading = False
    , href = Nothing
    , onClick = Nothing
    }


type Button msg
    = Button (Options msg) String


button : String -> Button msg
button label =
    Button defaultOptions label


withType : ButtonType -> Button msg -> Button msg
withType buttonType (Button options label) =
    let
        newOptions = { options | type_ = buttonType }
    in
        Button newOptions label


onClick : msg -> Button msg -> Button msg
onClick msg (Button opts label) =
  let
    newOpts = { opts | onClick = Just msg }
  in
    Button newOpts label


textColor : Color
textColor =
    let
        { r, g, b, a } = textColorRgba
    in
        rgba r g b a


toHtml : Button msg -> Html msg
toHtml (Button options label) =
    let
        transitionDuration = 350

        baseAttributes =
            [ borderRadius (px 2)
            , padding2 (px 4) (px 15)
            , borderWidth (px 1)
            , borderStyle solid
            , fontSize (px 14)
            , height (px 34)
            , outline none
            , Css.boxShadow5 (px 0) (px 2) (px 0) (px 0) (Css.rgba 0 0 0 0.016)
            ]

        defaultButtonAttributes =
            [ color textColor
            , backgroundColor (hex "#fff")
            , borderColor <| rgb 217 217 217
            , focus
                [ borderColor (hex primaryColorFaded)
                , color (hex primaryColorFaded)
                ]
            , hover
                [ borderColor (hex primaryColorFaded)
                , color (hex primaryColorFaded)
                ]
            , active
                [ borderColor (hex primaryColor)
                , color (hex primaryColor)
                ]
            , transition
                [ Css.Transitions.borderColor transitionDuration 
                , Css.Transitions.color transitionDuration
                ]
            ]

        primaryButtonAttributes =
            [ color (hex "#fff")
            , backgroundColor (hex primaryColor)
            , borderColor (hex primaryColor)
            , focus
                [ backgroundColor (hex primaryColorFaded)
                , borderColor (hex primaryColorFaded)
                ]
            , hover
                [ backgroundColor (hex primaryColorFaded)
                , borderColor (hex primaryColorFaded)
                ]
            , active
                [ backgroundColor (hex primaryColorStrong)
                , borderColor (hex primaryColorStrong)
                ]
            , transition
                [ Css.Transitions.backgroundColor transitionDuration
                , Css.Transitions.borderColor transitionDuration
                ]
            ]

        buttonTypeAttributes =
            case options.type_ of
                Default -> defaultButtonAttributes
                Primary -> primaryButtonAttributes
                _ -> []

        combinedButtonStyles =
            baseAttributes ++ buttonTypeAttributes

        attributes =
            case options.onClick of
                Just msg ->
                    [ Events.onClick msg, css combinedButtonStyles ]

                Nothing ->
                    [ css combinedButtonStyles ]

    in
    toUnstyled
        (H.button
            attributes
            [ H.span [] [ text label ] ]
        )
