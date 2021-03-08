module Ant.Modal.Css exposing (modalContainerClass, modalContentsClass, modalFooterClass, modalHeaderClass, modalRootClass, styles)

import Ant.Css.Common exposing (elmAntdPrefix)
import Ant.Theme exposing (Theme)
import Css exposing (..)
import Css.Animations as Animations exposing (keyframes)
import Css.Global as CG exposing (Snippet)
import Css.Media as Media exposing (only, screen, withMedia)


modalClass : String
modalClass =
    elmAntdPrefix ++ "__modal"


modalRootClass : String
modalRootClass =
    modalClass ++ "-root"


modalContainerClass : String
modalContainerClass =
    modalClass ++ "-container"


modalHeaderClass : String
modalHeaderClass =
    modalClass ++ "-header"


modalContentsClass : String
modalContentsClass =
    modalClass ++ "-contents"


modalFooterClass : String
modalFooterClass =
    modalClass ++ "-footer"


styles : Theme -> List Snippet
styles theme =
    let
        -- https://github.com/ant-design/ant-design/blob/0e4360038e79c7bd8bc7eb33dc56b7d0ccd481c4/components/style/core/motion/zoom.less#L51
        zoomInAnimation =
            keyframes
                [ ( 0
                  , [ Animations.transform [ scale 0.8 ]
                    , Animations.opacity zero
                    ]
                  )
                , ( 100
                  , [ Animations.transform [ scale 1 ]
                    , Animations.opacity (num 1)
                    ]
                  )
                ]
    in
    [ CG.class modalRootClass
        [ CG.withAttribute "visible=false"
            [ opacity zero
            , pointerEvents none
            , position absolute
            ]
        , CG.withAttribute "visible=true"
            [ zIndex (int 99)
            , position fixed
            , top zero
            , left zero
            , height (vh 100)
            , width (vw 100)

            -- FIXME: this animation isn't working
            -- , animationName zoomInAnimation
            , CG.withAttribute "mask-visible=true"
                [ backgroundColor (rgba 59 59 59 0.2)
                ]
            , CG.children
                [ CG.class modalContainerClass
                    [ position absolute
                    , zIndex (int 100)
                    , left (pct 50)
                    , transform <| translate <| pct -50
                    , backgroundColor (hex "#fff")
                    , minHeight (px 200)
                    , borderRadius (px 2)
                    , property "box-shadow" "0 3px 6px -4px rgba(0,0,0,.12), 0 6px 16px 0 rgba(0,0,0,.08), 0 9px 28px 8px rgba(0,0,0,.05)"
                    , displayFlex
                    , flexDirection column
                    , withMedia [ only screen [ Media.minWidth (px 530) ] ]
                        [ width (px 520) ]
                    , withMedia [ only screen [ Media.maxWidth (px 529) ] ]
                        [ width (pct 95) ]
                    , CG.withAttribute "layout=\"3-row\""
                        [ justifyContent spaceBetween ]
                    , CG.withAttribute "layout=\"2-row\""
                        [ justifyContent flexStart ]
                    , CG.children
                        [ CG.class modalHeaderClass
                            [ padding2 (px 16) (px 24)
                            ]
                        , CG.class modalContentsClass
                            [ padding (px 24)
                            ]
                        , CG.class modalFooterClass
                            [ padding2 (px 10) (px 16)
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
