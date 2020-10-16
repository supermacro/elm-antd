module Ant.Checkbox exposing (checkbox, toHtml, withLabel)

{-| Themable checkbox component
-}

{- NOTE TO DEVELOPERS:

   This component is themeable. See ./src/Ant/Checkbox/Css.elm
-}

import Ant.Css.Common exposing (checkboxCustomCheckmarkClass, checkboxLabelClass)
import Html as H exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events


type alias CheckboxConfig =
    { disabled : Bool
    , label : Maybe String
    , checked : Bool
    }


type Checkbox msg
    = Checkbox CheckboxConfig msg


defaultCheckboxConfig : Bool -> CheckboxConfig
defaultCheckboxConfig checked =
    { disabled = False
    , label = Nothing
    , checked = checked
    }


checkbox : msg -> Bool -> Checkbox msg
checkbox tagger checked =
    Checkbox (defaultCheckboxConfig checked) tagger


withLabel : String -> Checkbox msg -> Checkbox msg
withLabel labelText (Checkbox config tagger) =
    let
        newConfig =
            { config
                | label = Just labelText
            }
    in
    Checkbox newConfig tagger


toHtml : Checkbox msg -> Html msg
toHtml (Checkbox config tagger) =
    let
        _ =
            Debug.log "1" "1"
    in
    H.label [ Attr.class checkboxLabelClass ]
        [ H.text <| Maybe.withDefault "" config.label
        , H.input
            [ Attr.type_ "checkbox"
            , Attr.checked config.checked
            , Events.onCheck (\_ -> tagger)
            ]
            []
        , H.span [ Attr.class checkboxCustomCheckmarkClass ] []
        ]
