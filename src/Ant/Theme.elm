module Ant.Theme exposing
    ( Theme
    , defaultTheme, defaultColors, createMonochromaticColors
    )

{-| This module allows you to create custom themes for your components.

@docs Theme

@docs defaultTheme, defaultColors, createMonochromaticColors

-}

import Color exposing (Color)
import Color.Manipulate exposing (darken, fadeOut, lighten)


type alias Colors =
    { primary : Color
    , primaryFaded : Color
    , primaryStrong : Color
    , warning : Color
    , danger : Color
    }


type alias TypographyOptions =
    { primaryTextColor : Color
    , secondaryTextColor : Color
    }


{-| elm-antd theme info used to generate custom themes
-}
type alias Theme =
    { colors : Colors
    , typography : TypographyOptions
    }


{-| Utility function to create a set of [monochromatic](https://www.w3schools.com/colors/colors_monochromatic.asp) colors based off of a given "main" color. This is what is used under the hood in Elm Antd to create the `Colors` record.

This function only updates the `primary`, `primaryFaded` and `primaryStrong` - leaving the `danger` and `warning` colors untouched.

-}
createMonochromaticColors : Color -> Float -> Colors -> Colors
createMonochromaticColors mainColor delta colors =
    { colors
        | primary = mainColor
        , primaryFaded =
            mainColor
                |> lighten delta
        , primaryStrong =
            mainColor
                |> darken delta
    }


defaultColors : Colors
defaultColors =
    let
        antdDefaultPrimaryColor =
            Color.rgb255 24 144 255

        dummyColor =
            Color.black

        blankSlate =
            -- **Minor Hack**
            -- apply dummy colors for primary, primaryFaded
            -- and primaryStrong since the real colors will be applied
            -- with `createMonochromaticColors`
            { primary = dummyColor
            , primaryFaded = dummyColor
            , primaryStrong = dummyColor
            , warning =
                Color.fromRgba
                    { red = 250 / 255
                    , green = 173 / 255
                    , blue = 20 / 255
                    , alpha = 1
                    }
            , danger =
                Color.fromRgba
                    { red = 1
                    , green = 77 / 255
                    , blue = 79 / 255
                    , alpha = 1
                    }
            }
    in
    createMonochromaticColors antdDefaultPrimaryColor 0.1 blankSlate


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
        primaryTextColor =
            Color.rgba 0 0 0 0.85

        typography =
            { primaryTextColor = primaryTextColor
            , secondaryTextColor =
                primaryTextColor
                    |> fadeOut 0.4
            }
    in
    { colors = defaultColors
    , typography = typography
    }
