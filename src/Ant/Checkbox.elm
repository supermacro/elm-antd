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

import Ant.Css.Common exposing (checkboxCustomCheckmarkClass, checkboxLabelClass, checkboxWrapperClass)
import Html as H exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events


type alias CheckboxConfig msg =
    { disabled : Bool
    , tagger : Maybe (Bool -> msg)
    , label : Maybe String
    }


{-| Represents a customizeable and themable checkbox
-}
type Checkbox msg
    = Checkbox (CheckboxConfig msg)


defaultCheckboxConfig : CheckboxConfig msg
defaultCheckboxConfig =
    { disabled = False
    , tagger = Nothing
    , label = Nothing
    }


{-| Create a checkbox

    checkbox model.checked

-}
checkbox : Checkbox msg
checkbox =
    Checkbox defaultCheckboxConfig


{-| Emit messages from your checkbox.

    checkbox model.checked
        |> withOnCheck RememberMeCheckboxToggled

-}
withOnCheck : (Bool -> msg) -> Checkbox msg -> Checkbox msg
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
toHtml : Bool -> Checkbox msg -> Html msg
toHtml checked (Checkbox config) =
    let
        optionalOnCheckEvent =
            case config.tagger of
                Just tagger ->
                    Events.onCheck tagger

                Nothing ->
                    Attr.attribute "no-oncheck" "no-oncheck"

        labelEnabledClass =
            if config.disabled then
                checkboxLabelClass ++ "--disabled"

            else
                checkboxLabelClass ++ "--enabled"

        checkedWrapperClass =
            if checked then
                [ Attr.class (checkboxWrapperClass ++ "--checked") ]

            else
                []
    in
    H.label [ Attr.class checkboxLabelClass, Attr.class labelEnabledClass ]
        [ H.span (List.concat [ checkedWrapperClass, [ Attr.class checkboxWrapperClass ] ])
            [ H.input
                [ Attr.type_ "checkbox"
                , Attr.checked checked
                , optionalOnCheckEvent
                , Attr.disabled config.disabled
                ]
                []
            , H.span [ Attr.class checkboxCustomCheckmarkClass ] []
            ]
        , H.text <| Maybe.withDefault "" config.label
        ]
