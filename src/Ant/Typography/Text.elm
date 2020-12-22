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

{-
   A NOTE TO DEVELOPERS.

   This component is themable.

   See styles at src/Ant/Typography/Text/Css.elm
-}

import Ant.Typography.Text.Css as TextCss
import Css exposing (..)
import Html exposing (Attribute, Html)
import Html.Attributes as Attr


boolToString : Bool -> String
boolToString val =
    if val then
        "true"

    else
        "false"


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


linkTargetToString : LinkTarget -> Attribute msg
linkTargetToString trgt =
    case trgt of
        Blank ->
            Attr.target "_blank"

        Self ->
            Attr.attribute "no-op" "no-op"

        Parent ->
            Attr.target "_parent"

        Top ->
            Attr.target "_top"


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
        textTypeClass =
            case opts.type_ of
                Link _ _ ->
                    TextCss.textLinkClass

                Primary ->
                    TextCss.textPrimaryClass

                Secondary ->
                    TextCss.textSecondaryClass

                Warning ->
                    TextCss.textWarningClass

                Danger ->
                    TextCss.textDangerClass

        borderStylesClass =
            case opts.borderStyle of
                Code ->
                    TextCss.textCodeClass

                Keyboard ->
                    TextCss.textKeyboardClass

                None ->
                    "no-border-class"

        boldTextAttribute =
            Attr.attribute "bold" (boolToString opts.strong)

        underlinedAttribute =
            Attr.attribute "underlined" (boolToString opts.underlined)

        lineThroughAttribute =
            Attr.attribute "lineThrough" (boolToString opts.lineThrough)

        highlightedAttribute =
            Attr.attribute "highlighted" (boolToString opts.highlighted)

        disabledAttribute =
            Attr.attribute "disabled" (boolToString opts.disabled)

        ( textContainer, additionalAttributes ) =
            case opts.type_ of
                Link url linkTarget ->
                    ( Html.a
                    , [ Attr.href url
                      , linkTargetToString linkTarget
                      ]
                    )

                _ ->
                    if opts.highlighted then
                        ( Html.mark, [] )

                    else
                        case opts.borderStyle of
                            Keyboard ->
                                ( Html.kbd, [] )

                            _ ->
                                ( Html.span, [] )
    in
    textContainer
        (additionalAttributes
            ++ [ Attr.class TextCss.textClass
               , Attr.class textTypeClass
               , Attr.class borderStylesClass
               , disabledAttribute
               , boldTextAttribute
               , highlightedAttribute
               , lineThroughAttribute
               , underlinedAttribute
               ]
        )
        [ Html.text value ]
