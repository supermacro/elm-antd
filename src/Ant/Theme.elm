module Ant.Theme exposing (Theme, createTheme, defaultTheme)

import Hex


{-| The default antd theme. You shouldn't ever need to import or use the function since all components already use it under the hood.
-}
defaultTheme : Theme
defaultTheme =
    let
        antdDefaultPrimaryColor =
            0x001890FF
    in
    createTheme antdDefaultPrimaryColor



-- These offset values determine what the "faded" and "strong" versions of a primary color are
--
-- They were calculated by comparing the hexadecimal values of the default Ant theme primary colors


fadedOffset : Int
fadedOffset =
    -2627840


strongOffset : Int
strongOffset =
    992038


type alias Theme =
    { primary : String
    , primaryFaded : String
    , primaryStrong : String
    }



-- produces 6-digit CSS hex values
-- to ensure that CSS engines can properly interpret the
-- hexadecimal as a RGB color


toCssColorValue : Int -> String
toCssColorValue val =
    let
        -- this value is going to be between 6 and 1 digits
        rawString =
            Hex.toString val

        length =
            String.length rawString

        missingZeroes =
            String.repeat (6 - length) "0"
    in
    "#" ++ missingZeroes ++ rawString


createTheme : Int -> Theme
createTheme primaryColor =
    let
        primary =
            toCssColorValue primaryColor

        faded =
            toCssColorValue <| primaryColor - fadedOffset

        strong =
            toCssColorValue <| primaryColor - strongOffset
    in
    { primary = primary
    , primaryFaded = faded
    , primaryStrong = strong
    }
