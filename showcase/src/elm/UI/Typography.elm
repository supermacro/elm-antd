module UI.Typography exposing
    ( SubHeadingOptions(..)
    , codeText
    , commonTextStyles
    , documentationHeading
    , documentationSubheading
    , documentationText
    , documentationUnorderedList
    , internalLink
    , link
    , logoText
    )

import Ant.Internals.Typography exposing (fontList, headingColorRgba)
import Ant.Theme exposing (defaultTheme)
import Ant.Typography.Text as Text
import Color.Convert exposing (colorToHexWithAlpha)
import Css exposing (..)
import Css.Global exposing (global, selector)
import Css.Transitions exposing (transition)
import Html.Styled as Styled exposing (fromUnstyled, text)
import Html.Styled.Attributes as A exposing (class, css, href)


primaryColor : Css.Color
primaryColor =
    hex <| colorToHexWithAlpha defaultTheme.colors.primary


link : String -> String -> Styled.Html msg
link url label =
    let
        styles =
            commonTextStyles
                ++ [ hover [ color primaryColor ]
                   ]
    in
    Styled.a
        [ href url, A.target "_blank", css styles ]
        [ text label ]


internalLink : String -> String -> Styled.Html msg
internalLink url label =
    let
        styles =
            commonTextStyles
                ++ [ hover [ color primaryColor ]
                   ]
    in
    Styled.a
        [ href url, css styles ]
        [ text label ]


codeText : String -> Styled.Html msg
codeText value =
    Text.text value
        |> Text.code
        |> Text.toHtml
        |> fromUnstyled


commonStyles : List Style
commonStyles =
    [ color (rgba headingColorRgba.r headingColorRgba.g headingColorRgba.b headingColorRgba.a)
    , selection
        [ backgroundColor primaryColor
        , color (hex "#fff")
        ]
    ]


commonTextStyles : List Style
commonTextStyles =
    commonStyles
        ++ [ fontFamilies fontList
           , fontSize (px 14)
           ]


commonHeadingStyles : List Style
commonHeadingStyles =
    commonStyles
        ++ [ fontFamilies ("Avenir" :: fontList)
           , fontWeight (int 500)
           ]


logoText : Styled.Html msg
logoText =
    let
        styles =
            fontSize (px 18) :: commonHeadingStyles
    in
    Styled.span [ css styles ] [ Styled.text "Elm Ant Design" ]


documentationHeading : String -> Styled.Html msg
documentationHeading value =
    let
        styles =
            commonHeadingStyles
                ++ [ fontSize (px 30)
                   , marginTop (px 8)
                   , marginBottom (px 20)
                   , lineHeight (px 38)
                   ]
    in
    Styled.h1
        [ css styles
        ]
        [ Styled.text value ]


type SubHeadingOptions
    = WithAnchorLink
    | WithoutAnchorLink


documentationSubheading : SubHeadingOptions -> String -> Styled.Html msg
documentationSubheading opts value =
    let
        subheadingLink =
            String.replace " " "-" value

        styledAnchorLink =
            Styled.a
                [ href ("#" ++ subheadingLink)
                , css
                    [ textDecoration none
                    , color primaryColor
                    , marginLeft (px 8)
                    , hover
                        [ color <| hex <| colorToHexWithAlpha defaultTheme.colors.primaryFaded
                        ]
                    ]
                ]
                [ Styled.text "#" ]

        docSubheadingClass =
            "doc-subheading"

        animationTransitionDuration =
            transition [ Css.Transitions.opacity 250 ]

        hoverAnimationCss =
            [ selector ("." ++ docSubheadingClass ++ " > a")
                [ opacity (num 0)
                , animationTransitionDuration
                ]
            , selector ("." ++ docSubheadingClass ++ ":hover > a")
                [ opacity (num 1)
                , animationTransitionDuration
                ]
            ]

        optionalAnchorLink =
            case opts of
                WithAnchorLink ->
                    [ styledAnchorLink, global hoverAnimationCss ]

                _ ->
                    []

        styles =
            css
                (commonHeadingStyles
                    ++ [ fontSize (px 24)
                       , marginTop (px 38.4)
                       , marginBottom (px 10.8)
                       , lineHeight (px 32)
                       ]
                )
    in
    Styled.h2
        [ styles, class docSubheadingClass ]
        (Styled.span [] [ Styled.text value ] :: optionalAnchorLink)


documentationText : Styled.Html msg -> Styled.Html msg
documentationText content =
    let
        styles =
            commonTextStyles
                ++ [ margin2 (px 14) (px 0)
                   , lineHeight (px 28)
                   ]
    in
    Styled.p
        [ css styles
        ]
        [ content ]


documentationUnorderedList : List (Styled.Html msg) -> Styled.Html msg
documentationUnorderedList =
    let
        styles =
            css
                (commonTextStyles
                    ++ [ listStyle circle
                       , listStylePosition outside
                       ]
                )
    in
    Styled.ul [ styles ]
        << List.map
            (\textItem ->
                Styled.li
                    [ css
                        (commonTextStyles
                            ++ [ lineHeight (px 28)
                               , marginTop (px 2.8)
                               , marginBottom (px 2.8)
                               , marginLeft (px 20)
                               ]
                        )
                    ]
                    [ textItem ]
            )
