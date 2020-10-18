module Ant.Alert.Css exposing (styles)

import Ant.Css.Common exposing (..)
import Ant.Internals.Typography exposing (commonFontStyles)
import Ant.Theme exposing (Theme)
import Color.Convert exposing (colorToHexWithAlpha)
import Color.Manipulate
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
    let
        backgroundColor =
            theme.colors.primaryFaded
                |> Color.Manipulate.lighten 0.313
                |> colorToHexWithAlpha
                |> hex

        borderColor =
            theme.colors.primaryFaded
                |> Color.Manipulate.lighten 0.15
                |> colorToHexWithAlpha
                |> hex
    in
    { background = backgroundColor
    , border = borderColor
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
    , CG.class alertSuccessClass
        successStyles

    -- info alert styles
    , CG.class alertInfoClass
        infoStyles

    -- warning alert styles
    , CG.class alertWarningClass
        warningStyles

    -- error alert styles
    , CG.class alertErrorClass
        errorStyles
    ]
