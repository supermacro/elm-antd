module Ant.Button exposing
    ( Button
    , button, onClick, ButtonType(..), withType, withIcon, ButtonSize(..), disabled
    , toHtml
    )

{-| Button component

@docs Button


# Customizing the Button

@docs button, onClick, ButtonType, withType, withIcon, ButtonSize, disabled

@docs toHtml

-}

{-
   A NOTE TO DEVELOPERS.

   This component is themable.

   See styles at src/Ant/Button/Css.elm
-}

import Ant.Css.Common exposing (..)
import Ant.Icons as Icon exposing (Icon)
import Ant.Theme exposing (Theme, defaultTheme)
import Css exposing (..)
import Html exposing (Html)
import Html.Styled as H exposing (fromUnstyled, text, toUnstyled)
import Html.Styled.Attributes as A exposing (css)
import Html.Styled.Events as Events


{-| The type of the button
-}
type ButtonType
    = Primary
    | Default
    | Dashed
    | Text
    | Link


{-| Determines the size of the button
-}
type ButtonSize
    = Large
    | DefaultSize
    | Small


type alias Options msg =
    { type_ : ButtonType
    , size : ButtonSize
    , disabled : Bool
    , loading : Bool
    , href : Maybe String
    , onClick : Maybe msg
    , icon : Maybe (Icon msg)
    , theme : Theme

    -- size : Size (Small, Medium, Large)
    -- etc etc
    }


defaultOptions : Options msg
defaultOptions =
    { type_ = Default
    , size = DefaultSize
    , disabled = False
    , loading = False
    , href = Nothing
    , onClick = Nothing
    , icon = Nothing
    , theme = defaultTheme
    }


{-| Represents a button component
-}
type Button msg
    = Button (Options msg) String


{-| Create a Button component.

    button "Click Me!"
        |> toHtml

-}
button : String -> Button msg
button label =
    Button defaultOptions label


{-| Change the default type of the Button

    button "submit"
        |> withType Dashed
        |> toHtml

-}
withType : ButtonType -> Button msg -> Button msg
withType buttonType (Button options label) =
    let
        newOptions =
            { options | type_ = buttonType }
    in
    Button newOptions label


{-| Add an icon to the button

    button "Search"
        |> withIcon searchOutlined
        |> toHtml

-}
withIcon : Icon msg -> Button msg -> Button msg
withIcon icon (Button options label) =
    let
        newOptions =
            { options | icon = Just icon }
    in
    Button newOptions label


{-| Make your button emit messages. By default, clicking a button does nothing.

    button "submit"
        |> onClick FinalCheckoutFormSubmitted
        |> toHtml

-}
onClick : msg -> Button msg -> Button msg
onClick msg (Button opts label) =
    let
        newOpts =
            { opts | onClick = Just msg }
    in
    Button newOpts label


{-| Make the button disabled. If you have a `onClick` event registered, it will not be fired.

    button "You can't click this"
        |> onClick Logout
        |> disabled True
        |> toHtml

-}
disabled : Bool -> Button msg -> Button msg
disabled disabled_ (Button opts label) =
    let
        newOpts =
            { opts | disabled = disabled_ }
    in
    Button newOpts label


iconToHtml : Icon msg -> H.Html msg
iconToHtml icon =
    icon
        |> Icon.toHtml
        |> fromUnstyled


{-| Turn your Button into Html msg
-}
toHtml : Button msg -> Html msg
toHtml (Button options label) =
    let
        animatedButtonTypes =
            [ Default
            , Primary
            , Dashed
            ]

        animationAttribute =
            if List.member options.type_ animatedButtonTypes then
                [ A.class "elm-antd__animated_btn" ]

            else
                []

        onClickAttribute =
            case options.onClick of
                Just msg ->
                    [ Events.onClick msg ]

                Nothing ->
                    []

        buttonTypeClassName =
            case options.type_ of
                Default ->
                    btnDefaultClass

                Primary ->
                    btnPrimaryClass

                Dashed ->
                    btnDashedClass

                Text ->
                    btnTextClass

                Link ->
                    btnLinkClass

        commonAttributes =
            [ A.class btnClass
            , A.class buttonTypeClassName
            , A.disabled options.disabled
            ]

        attributes =
            commonAttributes ++ onClickAttribute ++ animationAttribute

        iconContent =
            case options.icon of
                Nothing ->
                    H.span [] []

                Just icon ->
                    H.span
                        [ css
                            [ marginRight (px 8)
                            , position relative
                            , top (px 2)
                            ]
                        ]
                        [ iconToHtml icon ]
    in
    toUnstyled
        (H.button
            attributes
            [ iconContent
            , H.span [] [ text label ]
            ]
        )
