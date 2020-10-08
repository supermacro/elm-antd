module Ant.Theme exposing (createTheme, defaultTheme, Theme)

import Hex


{-| The default antd theme. You shouldn't ever need to import or use the function since all components already use it under the hood.
-}
defaultTheme : Theme
defaultTheme =
    let
        antdDefaultPrimaryColor = 0x1890ff
    in
    createTheme antdDefaultPrimaryColor


-- These offset values determine what the "faded" and "strong" versions of a primary color are
--
-- They were calculated by comparing the hexadecimal values of the default Ant theme primary colors
fadedOffset : Int
fadedOffset = -2627840

strongOffset : Int
strongOffset = 992038

type alias Theme = 
    { primary : String
    , primaryFaded : String
    , primaryStrong : String
    }

createTheme : Int -> Theme
createTheme primaryColor =
    let
        primary = Hex.toString primaryColor

        faded = Hex.toString <| primaryColor - fadedOffset

        strong = Hex.toString <| primaryColor - strongOffset

    in
    { primary = "#" ++ primary
    , primaryFaded = "#" ++ faded
    , primaryStrong = "#" ++ strong
    }

