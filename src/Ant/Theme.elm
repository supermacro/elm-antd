module Ant.Theme exposing
    ( Theme
    , createTheme
    , defaultTheme
    )

{-| This module allows you to create custom themes for your components.

@docs Theme

@docs createTheme


### Leaked Internals. Do Not Use :)

@docs defaultTheme

-}

import Color exposing (Color)
import Color.Manipulate exposing (darken, lighten)


{-| The default antd theme. You shouldn't ever use the function since all components already use it under the hood. It is currently exposed as I transition other components over to the themable API. This function **will** be removed / hidden in the future.
-}
defaultTheme : Theme
defaultTheme =
    let
        antdDefaultPrimaryColor =
            Color.rgb255 24 144 255
    in
    createTheme antdDefaultPrimaryColor


type alias Colors =
    { primary : Color
    , primaryFaded : Color
    , primaryStrong : Color
    }


{-| elm-antd theme info used to generate custom themes
-}
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
            { primary = primaryColor
            , primaryFaded =
                primaryColor
                    |> lighten 0.1
            , primaryStrong =
                primaryColor
                    |> darken 0.1
            }
    in
    { colors = colors }
