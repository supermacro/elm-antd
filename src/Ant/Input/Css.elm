module Ant.Input.Css exposing (createInputBoxShadow, styles)

import Ant.Css.Common exposing (inputRootActiveClass, inputRootClass, passwordInputVisibilityToggleIconClass)
import Ant.Internals.Typography exposing (commonFontStyles, textColorRgba)
import Ant.Theme exposing (Theme)
import Color as Color
import Color.Convert exposing (colorToHexWithAlpha)
import Color.Manipulate exposing (lighten)
import Css exposing (..)
import Css.Global as CG exposing (Snippet)
import Css.Transitions exposing (transition)


textColor : Color
textColor =
    let
        { r, g, b, a } =
            textColorRgba
    in
    rgba r g b a


{-| Ant.Form.Css has some input UI overrides. This function is used there to make box shadow look
different when a form field has errors.
-}
createInputBoxShadow : Color.Color -> Style
createInputBoxShadow =
    Color.Manipulate.lighten 0.26
        >> colorToHexWithAlpha
        >> hex
        >> boxShadow5 zero zero zero (px 2)


styles : Theme -> List Snippet
styles theme =
    let
        transitionDuration =
            350

        rootNodeStyles =
            [ borderWidth (px 1)
            , borderRadius (px 2)
            , width (pct 100)
            , height (px 30)
            , borderStyle solid
            , backgroundColor (hex "#fff")
            , borderColor <| rgb 217 217 217
            , padding2 (px 4) (px 11)
            , hover
                [ borderColor <| hex <| colorToHexWithAlpha theme.colors.primaryFaded
                ]
            ]

        transitionStyles =
            transition
                [ Css.Transitions.borderColor transitionDuration
                , Css.Transitions.boxShadow transitionDuration
                ]

        inputStyles =
            commonFontStyles
                ++ [ color textColor
                   , property "caret-color" "#000"
                   ]

        inputBoxShadow =
            createInputBoxShadow theme.colors.primaryFaded

        inputBorderColor =
            borderColor <| hex <| colorToHexWithAlpha theme.colors.primaryFaded
    in
    -- Styles for simple inputs that are not wrapped by a div or other elements
    [ CG.selector ("input." ++ inputRootClass)
        ((rootNodeStyles ++ inputStyles)
            ++ [ transitionStyles
               , focus
                    [ inputBorderColor
                    , inputBoxShadow
                    , outline none
                    ]
               ]
        )

    -- Styles for wrapped inputs (i.e. password input) whose root node is a div
    , CG.selector ("div." ++ inputRootClass)
        (rootNodeStyles
            ++ [ whiteSpace noWrap
               , paddingRight (px 10)
               , transitionStyles
               ]
        )

    -- add styles for when the input is active / focused
    , CG.selector ("div." ++ inputRootActiveClass)
        [ inputBoxShadow
        , inputBorderColor
        , transitionStyles
        ]

    -- styles for the icon in password inputs
    , CG.selector ("div." ++ inputRootClass ++ "> ." ++ passwordInputVisibilityToggleIconClass)
        [ cursor pointer
        , color (hex "#9a9a9a")
        , position absolute
        , hover
            [ color (rgba 0 0 0 0.85) ]
        , transition
            [ Css.Transitions.color transitionDuration
            ]
        ]
    , CG.selector ("div." ++ inputRootClass ++ "> input")
        (inputStyles
            ++ [ border zero
               , width (pct 95)
               , marginTop (px 1)
               , height (px 19)
               , active
                    [ outline none
                    ]
               , focus
                    [ outline none
                    ]
               ]
        )
    ]
