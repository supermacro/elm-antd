module Ant.Css exposing (createThemedStyles, defaultStyles)

{-| Global styles that are responsible for the visualas / aesthetic of the elm-antd components. You **must** call `defaultStyles` or `createThemedStyles` at the root of your Elm project.

@docs createThemedStyles, defaultStyles
-}

import Ant.Alert.Css as AlertCss
import Ant.Button.Css as ButtonCss
import Ant.Input.Css as InputCss
import Ant.Theme exposing (Theme, defaultTheme)
import Css.Global as CG
import Html exposing (Html)
import Html.Styled exposing (toUnstyled)


{-| Creates a global stylesheet based on a custom Theme. See Ant.Theme documentation for more info on `Theme` and creating themes.

You must call `createThemedStyles` at the root of your Elm project!

    div []
        [ Ant.Css.createThemedStyles theme

        -- This button will now be themed according to the primaryColor color you chose!
        , Btn.toHtml <| button "Hello, elm-antd!"
        ]
-}
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


{-| The default stylesheet that adheres to the Antd specification.

You must call `defaultStyles` at the root of your Elm project!

    div []
        [ Ant.Css.defaultTheme

        -- This button will now be themed according to the primaryColor color you chose!
        , Btn.toHtml <| button "Hello, elm-antd!"
        ]
-}
defaultStyles : Html msg
defaultStyles =
    createThemedStyles defaultTheme
