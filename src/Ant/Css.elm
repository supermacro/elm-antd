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
            AlertCss.styles theme
                ++ ButtonCss.styles theme
                ++ InputCss.styles theme
    in
    allStyles
        |> CG.global
        |> toUnstyled


defaultStyles : Html msg
defaultStyles =
    createThemedStyles defaultTheme
