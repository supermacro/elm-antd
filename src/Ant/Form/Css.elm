module Ant.Form.Css exposing (styles)

import Ant.Css.Common as Common
    exposing
        ( formCheckboxFieldClass
        , formClass
        , formFieldErrorMessageClass
        , formFieldErrorMessageShowingClass
        , formLabelClass
        , formLabelInnerClass
        , formRequiredFieldClass
        , formSubmitButtonClass
        , inputRootActiveClass
        , inputRootClass
        )
import Ant.Input.Css exposing (createInputBoxShadow)
import Ant.Internals.Theme exposing (dangerColor)
import Ant.Internals.Typography exposing (commonFontStyles, headingColorRgba)
import Ant.Theme exposing (Theme)
import Color.Convert exposing (hexToColor)
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
        -- TODO: this is a hack that works for now
        -- but realistically, the dangerColor should be part of a theme
        -- See https://github.com/supermacro/elm-antd/blob/master/src/Ant/Theme.elm#L35
        errorBoxShadow =
            hexToColor dangerColor
                |> Result.withDefault theme.colors.primary
                |> createInputBoxShadow
    in
    [ CG.class formClass
        [ width (pct 100)
        , maxWidth (px 700)
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
        , CG.children
            [ CG.class formLabelInnerClass
                (commonFontStyles
                    ++ [ color labelColor
                       , fontSize (px 14)
                       , width (pct 33)
                       , textAlign right
                       , marginTop auto
                       , marginBottom auto
                       , before
                            [ Common.content "*"
                            , position relative
                            , bottom (px 3)
                            , color (hex dangerColor)
                            , marginRight (px 4)
                            ]
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

    -- TODO: figure out how rendering of optional fields is done
    -- , CG.selector "." ++ formLabelClass ++ "." ++ formRequiredFieldClass ++ " > ." ++ formLabelInnerClass
    , CG.class formFieldErrorMessageClass
        (commonFontStyles
            ++ [ color (hex dangerColor)
               , fontSize (px 14)
               , marginTop (px -1)
               , opacity (int 0)
               ]
        )
    , CG.class formFieldErrorMessageShowingClass
        [ CG.descendants
            [ CG.class formFieldErrorMessageClass
                [ marginTop (px 5)
                , opacity (int 1)
                , transition
                    [ Css.Transitions.marginTop 400
                    , Css.Transitions.opacity 500
                    ]
                ]
            , CG.class inputRootClass
                [ borderColor (hex dangerColor)
                , hover
                    [ borderColor (hex dangerColor)
                    ]
                , focus
                    [ errorBoxShadow
                    , borderColor (hex dangerColor)
                    ]
                ]
            , CG.class inputRootActiveClass
                [ errorBoxShadow
                ]
            ]
        ]
    ]
