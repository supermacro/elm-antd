module Ant.Form.Css exposing (styles)

import Ant.Css.Common as Common exposing (formCheckboxFieldClass, formClass, formLabelClass, formLabelInnerClass, formRequiredFieldClass, formSubmitButtonClass)
import Ant.Internals.Typography exposing (commonFontStyles, headingColorRgba)
import Ant.Theme exposing (Theme)
import Css exposing (..)
import Css.Global as CG exposing (Snippet)


labelColor : Color
labelColor =
    let
        { r, g, b, a } =
            headingColorRgba
    in
    rgba r g b a


styles : Theme -> List Snippet
styles theme =
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
        , marginBottom (px 24)
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
                            , color (hex "#ff4d4f")
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
    , CG.selector ("." ++ formLabelClass ++ " > *:nth-child(2)")
        [ maxWidth (pct 50)
        ]

    -- TODO: figure out how rendering of optional fields is done
    -- , CG.selector "." ++ formLabelClass ++ "." ++ formRequiredFieldClass ++ " > ." ++ formLabelInnerClass
    ]
