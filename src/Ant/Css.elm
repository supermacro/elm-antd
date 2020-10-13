module Ant.Css exposing (createThemedStyles, defaultStyles)

import Ant.Alert.Css as AlertCss
import Ant.Button.Css as ButtonCss
import Ant.Input.Css as InputCss
import Ant.Theme exposing (Theme, defaultTheme)
import Css.Global as CG
import Html exposing (Html)
import Html.Styled exposing (toUnstyled)


createThemedStyles : Theme -> Html msg
createThemedStyles theme =
    let
        allStyles =
            List.map (\styles -> styles theme)
                [ AlertCss.styles
                , ButtonCss.styles
                , InputCss.styles
                ]
    in
    allStyles
        |> List.concat
        |> CG.global
        |> toUnstyled


defaultStyles : Html msg
defaultStyles =
    createThemedStyles defaultTheme
