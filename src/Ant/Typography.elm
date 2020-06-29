module Ant.Typography exposing (title, Level(..), level, toHtml)

{-| Typography components for Elm Antd

@docs title, Level, level, toHtml

-}

import Ant.Internals.Typography exposing (commonFontStyles, headingColorRgba)
import Css exposing (..)
import Html exposing (Html)
import Html.Styled as Styled exposing (toUnstyled)
import Html.Styled.Attributes exposing (css)


headingColor : Style
headingColor =
    let
        { r, g, b, a } =
            headingColorRgba
    in
    color (rgba r g b a)


{-| Level of your headings
-}
type Level
    = H1
    | H2
    | H3
    | H4


type alias TitleOptions =
    { level : Level
    }


type Title
    = Title TitleOptions String


{-| Create a `Title` / header component

By default, the `Title` produced is a `H1`

-}
title : String -> Title
title titleText =
    Title { level = H1 } titleText


{-| Change the heading level of your `Title` component

    title "Elm is cool"
        |> level H3
        |> toHtml

-}
level : Level -> Title -> Title
level level_ (Title _ titleText) =
    Title { level = level_ } titleText


h1Css : List Style
h1Css =
    [ fontSize (px 38)
    , marginBottom (em 0.7)
    , lineHeight (px 46)
    ]


h2Css : List Style
h2Css =
    [ fontSize (px 30)
    , marginTop (em 1.2)
    , marginBottom (em 0.7)
    , lineHeight (px 40)
    ]


h3Css : List Style
h3Css =
    [ fontSize (px 24)
    , marginTop (em 1.2)
    , marginBottom (em 0.5)
    , lineHeight (px 32)
    ]


h4Css : List Style
h4Css =
    [ fontSize (px 20)
    , marginTop (em 1)
    , marginBottom (em 0.5)
    , lineHeight (px 28)
    ]


{-| Render your title / header
-}
toHtml : Title -> Html msg
toHtml (Title options value) =
    let
        ( heading, headingStyles ) =
            case options.level of
                H1 ->
                    ( Styled.h1, h1Css )

                H2 ->
                    ( Styled.h2, h2Css )

                H3 ->
                    ( Styled.h3, h3Css )

                H4 ->
                    ( Styled.h4, h4Css )
    in
    toUnstyled
        (heading
            [ css
                ([ headingColor
                 , fontWeight (int 600)
                 ]
                    ++ commonFontStyles
                    ++ headingStyles
                )
            ]
            [ Styled.text value ]
        )
