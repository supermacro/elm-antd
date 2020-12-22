module Ant.Form.Css exposing (styles)

import Ant.Css.Common as Common
    exposing
        ( formCheckboxFieldClass
        , formClass
        , formFieldErrorMessageClass
        , formFieldErrorMessageShowingClass
        , formGroupClass
        , formLabelClass
        , formLabelInnerClass
        , formRequiredFieldClass
        , formSubmitButtonClass
        , inputRootActiveClass
        , inputRootClass
        , makeSelector
        )
import Ant.Input.Css exposing (createInputBoxShadow)
import Ant.Internals.Typography exposing (commonFontStyles, headingColorRgba)
import Ant.Theme exposing (Theme)
import Color.Convert exposing (colorToHexWithAlpha)
import Css exposing (..)
import Css.Global as CG exposing (Snippet)
import Css.Transitions exposing (transition)


labelColor : Color
labelColor =
    let
        { r, g, b, a } =
            headingColorRgba
    in
    rgba r g b a


styles : Theme -> List Snippet
styles theme =
    let
        errorBoxShadow =
            createInputBoxShadow theme.colors.danger

        dangerColorHex =
            hex <| colorToHexWithAlpha theme.colors.danger
    in
    [ CG.class formClass
        [ width (pct 100)
        , maxWidth (px 700)
        ]
    , CG.class formGroupClass
        [ displayFlex
        , marginBottom (px 25)
        ]
    , makeSelector (formGroupClass ++ " > *:not(:first-child)")
        [ marginLeft (px 18)
        ]
    , CG.class formCheckboxFieldClass
        [ marginLeft (pct 33)
        , height (px 18)
        , paddingTop (px 9)
        ]
    , CG.class formSubmitButtonClass
        [ marginLeft (pct 33)
        , marginTop (px 30)
        ]
    , CG.class formLabelClass
        [ displayFlex
        , width (pct 100)
        , marginBottom (px 10)
        , CG.withClass formRequiredFieldClass
            [ CG.children
                [ CG.class formLabelInnerClass
                    [ before
                        [ Common.content "*"
                        , position relative
                        , bottom (px 3)
                        , color dangerColorHex
                        , marginRight (px 4)
                        ]
                    ]
                ]
            ]
        , CG.children
            [ CG.class formLabelInnerClass
                (commonFontStyles
                    ++ [ color labelColor
                       , fontSize (px 14)
                       , width (pct 33)
                       , textAlign right
                       , marginTop auto
                       , marginBottom auto
                       , after
                            [ Common.content ":"
                            , marginRight (px 8)
                            , marginLeft (px 2)
                            ]
                       ]
                )
            ]
        ]

    -- This wonky selector is used to apply styles to the actual form field
    -- ... assuming that the label text is rendered first
    -- and the form field is rendered second
    , CG.selector ("." ++ formLabelClass ++ " > div:nth-child(2)")
        [ maxWidth (pct 50)
        , width (px 380)
        , height (px 46)
        , position relative
        , top (px 8)
        ]
    , CG.class formFieldErrorMessageClass
        (commonFontStyles
            ++ [ color dangerColorHex
               , fontSize (px 14)
               , marginTop (px -7)
               , opacity (int 0)
               ]
        )
    , CG.class formFieldErrorMessageShowingClass
        [ CG.descendants
            [ CG.class formFieldErrorMessageClass
                [ lineHeight (num 1.5715)
                , marginTop zero
                , textAlign left
                , opacity (int 1)
                , transition
                    [ Css.Transitions.marginTop 400
                    , Css.Transitions.opacity 500
                    ]
                ]
            , CG.class inputRootClass
                [ borderColor dangerColorHex
                , hover
                    [ borderColor dangerColorHex
                    ]
                , focus
                    [ errorBoxShadow
                    , borderColor dangerColorHex
                    ]
                ]
            , CG.class inputRootActiveClass
                [ errorBoxShadow
                ]
            ]
        ]
    ]
