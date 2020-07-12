module Ant.Button exposing
    ( Button
    , button, onClick, ButtonType(..), withType, ButtonSize(..), disabled
    , toHtml
    )

{-| Button component

@docs Button


# Customizing the Button

@docs button, onClick, ButtonType, withType, ButtonSize, disabled

@docs toHtml

-}

import Ant.Internals.Palette exposing (primaryColor, primaryColorFaded, primaryColorStrong)
import Ant.Internals.Typography exposing (textColorRgba)
import Css exposing (..)
import Css.Animations as CA exposing (keyframes)
import Css.Transitions exposing (cubicBezier, transition)
import Html exposing (Html)
import Html.Styled as H exposing (text, toUnstyled)
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

    -- icon : Icon
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


textColor : Color
textColor =
    let
        { r, g, b, a } =
            textColorRgba
    in
    rgba r g b a


{-| Turn your Button into Html msg
-}
toHtml : Button msg -> Html msg
toHtml (Button options label) =
    let
        transitionDuration =
            350

        animation =
            keyframes
                [ ( 50, [ CA.property "transform" "scale(1.1, 1.3)", CA.property "opacity" "0" ] )
                , ( 99, [ CA.property "transform" "scale(0.001, 0.001)", CA.property "opacity" "0" ] )
                , ( 100, [ CA.property "transform" "scale(0.001, 0.001)", CA.property "opacity" "1" ] )
                ]

        animatedBefore : ColorValue compatible -> Style
        animatedBefore color =
            before
                [ property "content" "\" \""
                , display block
                , position absolute
                , width (pct 100)
                , height (pct 100)
                , right (px 0)
                , left (px 0)
                , top (px 0)
                , bottom (px 0)
                , borderRadius (px 5)
                , backgroundColor color
                , transition [ clickTransition ]
                , animationName animation
                , animationDuration (sec 1)
                , zIndex (int -1)
                ]

        clickTransition =
            Css.Transitions.transform3 2000 2000 <| cubicBezier 0.08 0.82 0.17 1

        baseAttributes =
            [ borderRadius (px 2)
            , padding2 (px 4) (px 15)
            , borderWidth (px 1)
            , fontSize (px 14)
            , height (px 34)
            , outline none
            , Css.boxShadow5 (px 0) (px 2) (px 0) (px 0) (Css.rgba 0 0 0 0.016)
            ]

        defaultButtonAttributes =
            [ position relative
            , color textColor
            , borderStyle solid
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
                , animatedBefore (hex primaryColorFaded)
                ]
            , transition
                [ Css.Transitions.borderColor transitionDuration
                , Css.Transitions.color transitionDuration
                ]
            ]

        primaryButtonAttributes =
            [ position relative
            , color (hex "#fff")
            , borderStyle solid
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
                , animatedBefore (hex primaryColor)
                ]
            , transition
                [ Css.Transitions.backgroundColor transitionDuration
                , Css.Transitions.borderColor transitionDuration
                ]
            ]

        dashedButtonAttributes =
            defaultButtonAttributes ++ [ borderStyle dashed ]

        textButtonAttributes =
            [ color textColor
            , border zero
            , backgroundColor (hex "#fff")
            , hover
                [ backgroundColor (rgba 0 0 0 0.018) ]
            , transition
                [ Css.Transitions.backgroundColor transitionDuration ]
            ]

        linkButtonAttributes =
            [ color (hex primaryColor)
            , border zero
            , backgroundColor (hex "#fff")
            , hover
                [ color (hex primaryColorFaded) ]
            , transition
                [ Css.Transitions.color transitionDuration ]
            ]

        buttonTypeAttributes =
            case options.type_ of
                Default ->
                    defaultButtonAttributes

                Primary ->
                    primaryButtonAttributes

                Dashed ->
                    dashedButtonAttributes

                Text ->
                    textButtonAttributes

                Link ->
                    linkButtonAttributes

        combinedButtonStyles =
            if options.disabled then
                baseAttributes

            else
                baseAttributes ++ buttonTypeAttributes

        cursorPointerOnHover =
            hover [ cursor pointer ]

        attributes =
            case options.onClick of
                Just msg ->
                    [ A.disabled options.disabled, Events.onClick msg, css <| cursorPointerOnHover :: combinedButtonStyles ]

                Nothing ->
                    [ A.disabled options.disabled, css <| cursorPointerOnHover :: combinedButtonStyles ]
    in
    toUnstyled
        (H.button
            attributes
            [ H.span [] [ text label ] ]
        )
