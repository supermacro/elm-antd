module UI.Footer exposing (Model, Msg, footer, initialModel, pushDown, update)

import Ant.Theme exposing (defaultTheme)
import Color
import Color.Convert exposing (colorToHexWithAlpha)
import ColorPicker
import Css exposing (..)
import Css.Global as CG
import Html
import Html.Styled as Styled exposing (div, fromUnstyled, text)
import Html.Styled.Attributes as A exposing (css, href)
import Html.Styled.Events exposing (onClick)
import UI.Typography exposing (commonTextStyles)


type alias Model =
    { colorPickerVisible : Bool
    , colorPicker : ColorPicker.State
    , color : Color.Color
    }


type Msg
    = ColorPickerMsg ColorPicker.Msg
    | ColorPickerToggleClicked


initialModel : Model
initialModel =
    { colorPickerVisible = False
    , colorPicker = ColorPicker.empty
    , color = defaultTheme.colors.primary
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ColorPickerMsg colorPickerMsg ->
            let
                ( newColorPickerState, color ) =
                    ColorPicker.update colorPickerMsg model.color model.colorPicker
            in
            { model
                | colorPicker = newColorPickerState
                , color =
                    color
                        |> Maybe.withDefault model.color
            }

        ColorPickerToggleClicked ->
            { model | colorPickerVisible = not model.colorPickerVisible }


{-| Hack to push down the footer in pages where there isn't enough content
-}
pushDown : Styled.Html msg
pushDown =
    div [ css [ marginBottom (px 600) ] ] [ text "" ]


viewColorPicker : Model -> Styled.Html Msg
viewColorPicker { color, colorPicker, colorPickerVisible } =
    let
        colorPickerUi =
            ColorPicker.view color colorPicker
                |> Html.map ColorPickerMsg
                |> fromUnstyled

        displayProperty =
            if colorPickerVisible then
                display inlineBlock

            else
                display none |> important

        customColorPickerStyles =
            CG.global
                [ CG.class "color-picker-container"
                    [ position absolute
                    , bottom (px 60)
                    , displayProperty
                    ]
                ]

        currentColorBox =
            div
                [ onClick ColorPickerToggleClicked
                , css
                    [ backgroundColor (hex "#fff")
                    , padding (px 4)
                    , borderRadius (px 2)
                    , cursor pointer
                    , display inlineBlock
                    , marginBottom (px 20)
                    ]
                ]
                [ div
                    [ css
                        [ backgroundColor (hex <| colorToHexWithAlpha color)
                        , height (px 17)
                        , width (px 80)
                        , borderRadius (px 2)
                        ]
                    ]
                    []
                ]
    in
    div [ css [ position relative ] ]
        [ customColorPickerStyles
        , colorPickerUi
        , currentColorBox
        ]


madeByMessage : Styled.Html msg
madeByMessage =
    let
        styles =
            [ borderTop3 (px 1) solid (rgba 255 255 255 0.25)
            , paddingTop (em 1.6)
            ]
    in
    div [ css styles ]
        [ text "Made with ❤\u{200C}\u{200C} \u{200C}\u{200C}  by supermacro, "
        , Styled.a
            [ href "https://github.com/supermacro/elm-antd/issues"
            , A.target "_blank"
            , css
                [ color (hex "#fff")
                , visited
                    [ color (hex "#fff") ]
                ]
            ]
            [ text "and you?" ]
        ]


footer : Model -> Styled.Html Msg
footer model =
    let
        footerStyles =
            commonTextStyles
                ++ [ height (px 150)
                   , color (hex "#fff")
                   , backgroundColor (hex "#000")
                   , marginTop (px 100)
                   , paddingTop (px 50)
                   , paddingRight (px 50)
                   , paddingLeft (px 50)
                   , textAlign center
                   ]
    in
    Styled.footer [ css footerStyles ]
        [ viewColorPicker model
        , madeByMessage
        ]
