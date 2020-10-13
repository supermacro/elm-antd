module UI.Utils exposing (colorToHexCssString, colorToInt, cssColorValueToColor)

import Color exposing (Color)
import Hex


cssColorValuetoRgb : String -> ( Int, Int, Int )
cssColorValuetoRgb colorValue =
    let
        -- drop the `#` character
        -- presumably now we have a 6 digit hexadecimal string
        rawHex =
            String.dropLeft 1 colorValue

        naiveFromString =
            Result.withDefault 0 << Hex.fromString

        parseHex start end =
            naiveFromString <| String.slice start end rawHex

        r =
            parseHex 0 2

        g =
            parseHex 2 4

        b =
            parseHex 4 6
    in
    ( r, g, b )


cssColorValueToColor : String -> Color
cssColorValueToColor colorValue =
    let
        ( r, g, b ) =
            cssColorValuetoRgb colorValue
    in
    Color.rgb255 r g b


colorToHexCssString : Color -> String
colorToHexCssString color =
    let
        -- toRgba returns an srgba value (0 - 1) representing percentage
        -- intoFLoatValue converts this into a value from 0 - 255
        intoIntValue : Float -> Int
        intoIntValue val =
            round (val * 255)

        { red, green, blue, alpha } =
            Color.toRgba color

        -- ensures each hex RGB component is 2 characters long
        padComponent : String -> String
        padComponent component =
            let
                len =
                    String.length component

                missingZeroes =
                    String.repeat (2 - len) "0"
            in
            missingZeroes ++ component

        createComponent =
            padComponent << Hex.toString << intoIntValue

        hexComponents =
            [ "#"
            , createComponent red
            , createComponent green
            , createComponent blue
            , createComponent alpha
            ]
    in
    String.concat hexComponents


hexCssStringToInt : String -> Int
hexCssStringToInt hexString =
    let
        rawHex =
            String.dropLeft 1 hexString
    in
    Hex.fromString rawHex
        |> Result.withDefault 0


colorToInt : Color -> Int
colorToInt =
    colorToHexCssString >> hexCssStringToInt
