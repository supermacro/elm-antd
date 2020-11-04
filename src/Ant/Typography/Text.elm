module Ant.Typography.Text exposing
    ( Text
    , text
    , TextType(..), LinkTarget(..), withType, code, keyboard, strong, disabled, underlined, lineThrough, highlighted, toHtml, listToHtml
    )

{-| Create decorated text values


## Create a customizeable `Text` component

@docs Text

@docs text


## Customize a `Text` component

@docs TextType, LinkTarget, withType, code, keyboard, strong, disabled, underlined, lineThrough, highlighted, toHtml, listToHtml

-}

import Ant.Internals.Theme exposing (dangerColor, warningColor)
import Ant.Internals.Typography exposing (fontList, textColorRgba, textSelectionStyles)
import Ant.Theme exposing (defaultTheme)
import Color.Convert exposing (colorToHexWithAlpha)
import Css exposing (..)
import Html exposing (Html)
import Html.Styled as Styled exposing (text, toUnstyled)
import Html.Styled.Attributes as A exposing (css)


{-| What kind of text is it?
-}
type TextType
    = Primary
    | Link Url LinkTarget
    | Secondary
    | Warning
    | Danger


type alias Url =
    String


{-| Specifies the 'target' html attribute for anchor elements

More info: <https://www.w3schools.com/tags/att_a_target.asp>

-}
type LinkTarget
    = Blank
    | Self
    | Parent
    | Top


type BorderStyle
    = Code
    | Keyboard
    | None


type alias TextOptions =
    { disabled : Bool
    , highlighted : Bool
    , underlined : Bool
    , lineThrough : Bool
    , strong : Bool
    , type_ : TextType
    , borderStyle : BorderStyle
    }


{-| A text value
-}
type Text
    = Text TextOptions String


defaultTextOptions : TextOptions
defaultTextOptions =
    { disabled = False
    , highlighted = False
    , strong = False
    , type_ = Primary
    , underlined = False
    , lineThrough = False
    , borderStyle = None
    }


linkTargetToString : LinkTarget -> String
linkTargetToString trgt =
    case trgt of
        Blank ->
            "_blank"

        Self ->
            "_self"

        Parent ->
            "_parent"

        Top ->
            "_top"


{-| Create a text value

By default the text looks just like any regular text. To decorate it, you need to apply one or more of the below options.

    text "hello, world!"
        |> withType Warning
        |> underlined True
        |> strong
        |> toHtml

-}
text : String -> Text
text value =
    Text defaultTextOptions value


{-| Change the text's type. This allows you to create anchor links as well, see second example.

    text "Elm"
        |> withType Secondary
        |> toHtml

    text "forgot password?"
        |> withType (Link "https://myapp.com/forgot-password" Blank)
        |> toHtml

The second argument to `Link` is a [`LinkTarget`](Ant-Typography-Text#LinkTarget).

-}
withType : TextType -> Text -> Text
withType textType_ (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | type_ = textType_ }
    in
    Text newTextOptions value


{-| Turn your Text value into a styled in-line code block

    text "<h1>I LOVE CATS</h1>"
        |> code
        |> toHtml

-}
code : Text -> Text
code (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | borderStyle = Code }
    in
    Text newTextOptions value


{-| Turn your Text value into a styled button-looking block (in-line)

    text "CMD"
        |> keyboard
        |> toHtml

-}
keyboard : Text -> Text
keyboard (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | borderStyle = Keyboard }
    in
    Text newTextOptions value


{-| Add an underline to your text

    text "this is important"
        |> underlined True
        |> toHtml

-}
underlined : Bool -> Text -> Text
underlined underlined_ (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | underlined = underlined_ }
    in
    Text newTextOptions value


{-| Set a striked line through your Text element

    text "forget about this"
        |> lineThrough True
        |> toHtml

-}
lineThrough : Bool -> Text -> Text
lineThrough lineThrough_ (Text textOptions value) =
    let
        newTextOptions =
            { textOptions | lineThrough = lineThrough_ }
    in
    Text newTextOptions value


{-| Set your Text element as bold

    text "look at me"
        |> strong
        |> toHtml

-}
strong : Text -> Text
strong (Text textOptions value) =
    let
        strongTextOptions =
            { textOptions | strong = True }
    in
    Text strongTextOptions value


{-| Set your Text element as disabled (the cursor icon changes)

    text "can't touch this'"
        |> disabled True
        |> toHtml

-}
disabled : Bool -> Text -> Text
disabled disabled_ (Text textOptions value) =
    let
        newOptions =
            { textOptions | disabled = disabled_ }
    in
    Text newOptions value


{-| Style the Text as highlighted

    text "super important"
        |> highlighted True
        |> toHtml

-}
highlighted : Bool -> Text -> Text
highlighted highlighted_ (Text textOptions value) =
    let
        newOptions =
            { textOptions | highlighted = highlighted_ }
    in
    Text newOptions value


{-| Render a list of Text elements into a span
-}
listToHtml : List Text -> Html msg
listToHtml =
    Html.span []
        << List.map toHtml


{-| Render your Text node into plain old `Html msg`
-}
toHtml : Text -> Html msg
toHtml (Text opts value) =
    let
        codeFontList : List String
        codeFontList =
            [ qt "SFMono-Regular"
            , "Consolas"
            , qt "Liberation Mono"
            , "Menlo"
            , "Courier"
            , "monospace"
            ]

        fontWeight =
            if opts.strong then
                Css.fontWeight (Css.int 600)

            else
                Css.fontWeight Css.normal

        textColor =
            case ( opts.type_, opts.disabled ) of
                ( _, True ) ->
                    let
                        { r, g, b } =
                            textColorRgba
                    in
                    color (rgba r g b 0.25)

                ( Link _ _, _ ) ->
                    color <| hex <| colorToHexWithAlpha defaultTheme.colors.primary

                ( Primary, _ ) ->
                    let
                        { r, g, b, a } =
                            textColorRgba
                    in
                    color (rgba r g b a)

                ( Secondary, _ ) ->
                    let
                        { r, g, b } =
                            textColorRgba
                    in
                    color (rgba r g b 0.45)

                ( Warning, _ ) ->
                    color (hex warningColor)

                ( Danger, _ ) ->
                    color (hex dangerColor)

        backgroundStyles =
            if opts.highlighted then
                Css.batch
                    [ color (hex "#000")
                    , backgroundColor (hex "#ffe58f")
                    , maxWidth fitContent
                    , property "max-width" "-moz-fit-content"
                    ]

            else
                Css.batch []

        cursorStyles =
            if opts.disabled then
                Css.batch
                    [ property "user-select" "none"
                    , cursor notAllowed
                    ]

            else
                case opts.type_ of
                    Link _ _ ->
                        cursor pointer

                    _ ->
                        cursor inherit

        underlineStyles =
            if opts.underlined then
                textDecorationLine underline

            else if opts.lineThrough then
                textDecorationLine Css.lineThrough

            else
                textDecorationLine inherit

        borderStyles =
            case opts.borderStyle of
                Code ->
                    Css.batch
                        [ Css.fontFamilies codeFontList
                        , Css.backgroundColor (rgba 150 150 150 0.1)
                        , padding3 (px 2.38) (px 4.76) (px 1.19)
                        , marginLeft (px 2.3)
                        , marginRight (px 2.3)
                        , border3 (px 1) solid (rgba 0 0 0 0.06)
                        , borderRadius (px 3)
                        , Css.fontSize (px 11.9)
                        , Css.lineHeight (px 18.7008)
                        ]

                Keyboard ->
                    Css.batch
                        [ Css.fontFamilies codeFontList
                        , Css.backgroundColor (rgba 150 150 150 0.06)
                        , padding3 (px 2.38) (px 4.76) (px 1.19)
                        , marginLeft (px 2.3)
                        , marginRight (px 2.3)
                        , border3 (px 1) solid (rgba 0 0 0 0.06)
                        , borderRadius (px 3)
                        , Css.fontSize (px 12.6)
                        , Css.lineHeight (px 18.7008)
                        ]

                None ->
                    Css.batch
                        [ Css.fontFamilies fontList
                        , Css.lineHeight (px 18)
                        , Css.fontSize (px 14)
                        ]

        ( textContainer, additionalAttributes ) =
            case opts.type_ of
                Link url linkTarget ->
                    ( Styled.a
                    , [ A.href url, A.target <| linkTargetToString linkTarget ]
                    )

                _ ->
                    ( Styled.span, [] )
    in
    toUnstyled
        (textContainer
            (additionalAttributes
                ++ [ css
                        [ textSelectionStyles
                        , borderStyles
                        , fontWeight
                        , cursorStyles
                        , textColor
                        , underlineStyles
                        , backgroundStyles
                        ]
                   , A.disabled opts.disabled
                   ]
            )
            [ Styled.text value ]
        )
