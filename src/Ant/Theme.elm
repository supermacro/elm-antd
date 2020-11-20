module Ant.Theme exposing
    ( Theme
    , defaultTheme
    , createMonochromaticColors
    )

{-| This module allows you to create custom themes for your components.

@docs Theme

@docs defaultTheme

-}

import Color exposing (Color)
import Color.Manipulate exposing (darken, lighten)


type alias Colors =
    { primary : Color
    , primaryFaded : Color
    , primaryStrong : Color
    }


type alias TypographyOptions =
    { defaultTextColor : Color
    , secondaryTextColor : Color
    }


{-| elm-antd theme info used to generate custom themes
-}
type alias Theme =
    { colors : Colors
    , typography : TypographyOptions
    }


{-| Utility function to create a set of [monochromatic](https://www.w3schools.com/colors/colors_monochromatic.asp) colors based off of a given "main" color. This is what is used under the hood in Elm Antd to create the `Colors` record.
-}
createMonochromaticColors : Color -> Colors
createMonochromaticColors mainColor =
    { primary = mainColor
    , primaryFaded =
        mainColor
            |> lighten 0.1
    , primaryStrong =
        mainColor
            |> darken 0.1
    }


{-| The default antd theme. This record is exposed to allow you to create custom themes without having to create a whole `Theme` record from scratch.

    import Ant.Css exposing (createThemedStyles)
    import Ant.Theme exposing (defaultTheme)


    -- ...
    view : Html msg
    view =
        let
            myCustomTheme =
                { defaultTheme
                    | colors = myCustomColors
                }
        in
        div [ createThemedStyles myCustomTheme ]

-}
defaultTheme : Theme
defaultTheme =
    let
        antdDefaultPrimaryColor =
            Color.rgb255 24 144 255

        colors =
            createMonochromaticColors antdDefaultPrimaryColor

        defaultTextColor =
            Color.rgba 0 0 0 0.85

        typography =
            { defaultTextColor = defaultTextColor
            , secondaryTextColor =
                defaultTextColor
                    |> lighten 0.2
            }
    in
    { colors = colors
    , typography = typography
    }
