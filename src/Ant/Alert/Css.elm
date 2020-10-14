module Ant.Alert.Css exposing (styles)

import Ant.Css.Common exposing (..)
import Ant.Internals.Typography exposing (commonFontStyles)
import Ant.Theme exposing (Theme)
import Css exposing (..)
import Css.Global as CG exposing (Snippet)
import Css.Transitions exposing (transition)


close_transition_duration_ms : Float
close_transition_duration_ms =
    1000


type alias TypeColors =
    { background : Color
    , border : Color
    }


successAlertColors : TypeColors
successAlertColors =
    { background = rgb 246 255 237
    , border = rgb 183 235 143
    }


warningAlertColors : TypeColors
warningAlertColors =
    { background = rgb 255 251 230
    , border = rgb 255 229 143
    }


errorAlertColors : TypeColors
errorAlertColors =
    { background = rgb 255 242 240
    , border = rgb 255 204 199
    }


getInfoAlertColors : Theme -> TypeColors
getInfoAlertColors theme =
    -- there's an 8 digit hexadecimal color notation
    -- that allows you to change the Alpha value of a color
    -- just like the rgba function
    -- https://developer.mozilla.org/en-US/docs/Web/CSS/color_value
    { background = hex (theme.colors.primaryFaded ++ "20")
    , border = hex (theme.colors.primaryFaded ++ "80")
    }


styles : Theme -> List Snippet
styles theme =
    let
        baseStyles =
            commonFontStyles
                ++ [ fontSize (px 14)
                   , lineHeight (px 22)
                   , borderRadius (px 2)
                   , paddingTop (px 8)
                   , paddingBottom (px 8)
                   , paddingLeft (px 15)
                   , paddingRight (px 15)
                   , width (pct 100)
                   , transition
                        [ Css.Transitions.opacity close_transition_duration_ms
                        , Css.Transitions.height close_transition_duration_ms
                        , Css.Transitions.padding close_transition_duration_ms
                        , Css.Transitions.border close_transition_duration_ms
                        , Css.Transitions.margin close_transition_duration_ms
                        ]
                   ]

        infoAlertColors =
            getInfoAlertColors theme

        infoStyles =
            [ backgroundColor infoAlertColors.background
            , border3 (px 1) solid infoAlertColors.border
            ]

        successStyles =
            [ backgroundColor successAlertColors.background
            , border3 (px 1) solid successAlertColors.border
            ]

        warningStyles =
            [ backgroundColor warningAlertColors.background
            , border3 (px 1) solid warningAlertColors.border
            ]

        errorStyles =
            [ backgroundColor errorAlertColors.background
            , border3 (px 1) solid errorAlertColors.border
            ]
    in
    [ CG.class alertClass baseStyles

    -- styles for closeable alert
    , makeSelector (alertClass ++ "[" ++ alertStateAttributeName ++ "]")
        [ paddingRight (px 15) ]
    , makeSelector (alertClass ++ "[" ++ alertStateAttributeName ++ "=true]")
        [ opacity (int 0)
        , overflow hidden
        , height zero
        , padding zero
        , border zero
        , marginBottom zero
        ]

    -- success alert styles
    , makeSelector alertSuccessClass
        successStyles

    -- info alert styles
    , makeSelector alertInfoClass
        infoStyles

    -- warning alert styles
    , makeSelector alertWarningClass
        warningStyles

    -- error alert styles
    , makeSelector alertErrorClass
        errorStyles
    ]
