module Ant.Checkbox exposing
    ( Checkbox
    , checkbox
    , withOnCheck, withDisabled, withLabel
    , toHtml
    )

{-| Themable checkbox component


## Types

@docs Checkbox

Note that by default a checkbox does not emit a message. You need to call `withOnCheck` for your checkbox to emit a message.


## Creating a Checkbox

@docs checkbox


## Customizing a Checkbox

@docs withOnCheck, withDisabled, withLabel


## Rendering the Checkbox

@docs toHtml

-}

{- NOTE TO DEVELOPERS:

   This component is themeable. See ./src/Ant/Checkbox/Css.elm
-}

import Ant.Css.Common exposing (checkboxCustomCheckmarkClass, checkboxLabelClass)
import Html as H exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events


type alias CheckboxConfig msg =
    { disabled : Bool
    , label : Maybe String
    , checked : Bool
    , tagger : Maybe msg
    }


{-| Represents a customizeable and themable checkbox
-}
type Checkbox msg
    = Checkbox (CheckboxConfig msg)


defaultCheckboxConfig : Bool -> CheckboxConfig msg
defaultCheckboxConfig checked =
    { disabled = False
    , label = Nothing
    , checked = checked
    , tagger = Nothing
    }


{-| Create a checkbox

    checkbox model.checked

-}
checkbox : Bool -> Checkbox msg
checkbox checked =
    Checkbox (defaultCheckboxConfig checked)


{-| Emit messages from your checkbox.

    checkbox model.checked
        |> withOnCheck RememberMeCheckboxToggled

-}
withOnCheck : msg -> Checkbox msg -> Checkbox msg
withOnCheck tagger (Checkbox config) =
    let
        newConfig =
            { config | tagger = Just tagger }
    in
    Checkbox newConfig


{-| Add a clickable label to your checkbox.

    checkbox model.checked
        |> withLabel "remember me"

-}
withLabel : String -> Checkbox msg -> Checkbox msg
withLabel labelText (Checkbox config) =
    let
        newConfig =
            { config
                | label = Just labelText
            }
    in
    Checkbox newConfig


{-| Disable the checkbox. This prevents emitting messages.

    checkbox model.checked
        |> withDisabled model.disabled

-}
withDisabled : Bool -> Checkbox msg -> Checkbox msg
withDisabled disabled (Checkbox config) =
    let
        newConfig =
            { config
                | disabled = disabled
            }
    in
    Checkbox newConfig


{-| Render your checkbox.

    checkbox model.checked
        |> withOnCheck RememberMeCheckboxToggled
        |> withLabel "remember me"
        |> toHtml

-}
toHtml : Checkbox msg -> Html msg
toHtml (Checkbox config) =
    let
        optionalOnCheckEvent =
            case config.tagger of
                Just tagger ->
                    Events.onCheck (\_ -> tagger)

                Nothing ->
                    Attr.attribute "no-oncheck" "no-oncheck"

        labelEnabledClass =
            if config.disabled then
                checkboxLabelClass ++ "--disabled"

            else
                checkboxLabelClass ++ "--enabled"
    in
    H.label [ Attr.class checkboxLabelClass, Attr.class labelEnabledClass ]
        [ H.text <| Maybe.withDefault "" config.label
        , H.input
            [ Attr.type_ "checkbox"
            , Attr.checked config.checked
            , optionalOnCheckEvent
            , Attr.disabled config.disabled
            ]
            []
        , H.span [ Attr.class checkboxCustomCheckmarkClass ] []
        ]
