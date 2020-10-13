module Ant.Theme exposing (Theme, createTheme, defaultTheme)

import Color exposing (Color)
import Color.Convert exposing (colorToHexWithAlpha)
import Color.Manipulate exposing (darken, lighten)


{-| The default antd theme. You shouldn't ever need to import or use the function since all components already use it under the hood.
-}
defaultTheme : Theme
defaultTheme =
    let
        antdDefaultPrimaryColor =
            Color.rgb255 24 144 255
    in
    createTheme antdDefaultPrimaryColor



-- all colors stored as CSS-compatible hexadecimal strings


type alias Colors =
    { primary : String
    , primaryFaded : String
    , primaryStrong : String
    }


type alias Theme =
    { colors : Colors
    }


{-| Create a theme based on a given Primary color. elm-antd takes care of generating the various shades of that color necessary. Note that you need to install `avh4/elm-color` in order to create a `Color` value.

    import Ant.Button as Btn exposing (button)
    import Ant.Css
    import Ant.Theme exposing (createTheme)
    import Color
    import Html exposing (Html, div)

    view : Html msg
    view =
        let
            myThemePrimaryColor =
                Color.rgb255 18 147 216

            theme =
                createTheme myThemePrimaryColor
        in
        div []
            [ Ant.Css.createThemedStyles theme

            -- This button will now be themed according to the primaryColor color you chose!
            , Btn.toHtml <| button "Hello, elm-antd!"
            ]

-}
createTheme : Color -> Theme
createTheme primaryColor =
    let
        colors =
            { primary = colorToHexWithAlpha primaryColor
            , primaryFaded =
                primaryColor
                    |> lighten 0.3
                    |> colorToHexWithAlpha
            , primaryStrong =
                primaryColor
                    |> darken 0.3
                    |> colorToHexWithAlpha
            }
    in
    { colors = colors }
