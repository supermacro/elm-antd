module Ant.Input exposing
    ( Input, input
    , InputSize(..), withSize, withPasswordType, withPlaceholder, withTextAreaType
    , toHtml
    )

{-| Input widget for data entry


## Creating an input

@docs Input, input


## Modifying the input

@docs InputSize, withSize, withPasswordType, withPlaceholder, withTextAreaType


## Rendering the input

@docs toHtml

-}

{-
   A NOTE TO DEVELOPERS.

   This component is themable.

   See styles at src/Ant/Input/Css.elm
-}

import Ant.Css.Common exposing (inputClass, inputRootClass, passwordInputVisibilityToggleIconClass)
import Ant.Icons as Icons exposing (Icon)
import Css exposing (..)
import Html as H exposing (Attribute, Html)
import Html.Attributes as Attr exposing (class, placeholder)
import Html.Events as E



-- String -> msg
-- init >> setValue config.value
-- setValue config


{-| Represents a customizeable input.
-}
type Input msg
    = Input (InputOpts msg) (String -> msg)


{-| Determines the vertical height of the input
-}
type InputSize
    = Default
    | Large
    | Small


{-| Defines the different kinds of input values you can have.
-}
type InputType msg
    = Text
    | Password { textVisible : Bool } (Bool -> msg)
    | TextArea { rows : Int }


type alias InputOpts msg =
    { size : InputSize
    , placeholder : Maybe String
    , type_ : InputType msg
    }


defaultInputOpts : InputOpts msg
defaultInputOpts =
    { size = Default
    , placeholder = Nothing
    , type_ = Text
    }


{-| Create a customizeable input component
-}
input : (String -> msg) -> Input msg
input =
    Input defaultInputOpts


{-| Add a placeholder to the input
-}
withPlaceholder : String -> Input msg -> Input msg
withPlaceholder placeholder (Input inputOpts tagger) =
    let
        newOpts =
            { inputOpts | placeholder = Just placeholder }
    in
    Input newOpts tagger


{-| Change the size of the input
-}
withSize : InputSize -> Input msg -> Input msg
withSize size (Input inputOpts tagger) =
    let
        newOpts =
            { inputOpts | size = size }
    in
    Input newOpts tagger


{-| Turn the input into a text area. You must specify the vertical height of the text area in rows as defined by the [`textarea` spec](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea).

If you specify a value less than 1 for rows, then we'll use a default value of 4.

    view : Html msg
    view =
        input TextAreaVAlueChanged
            |> withTextAreaType { rows = 10 }
            |> toHtml

-}
withTextAreaType : { rows : Int } -> Input msg -> Input msg
withTextAreaType { rows } (Input inputOpts tagger) =
    let
        savedRows =
            if rows < 1 then
                4

            else
                rows

        newOpts =
            { inputOpts
                | type_ = TextArea { rows = savedRows }
            }
    in
    Input newOpts tagger


{-| Modify the type of the input.

    input InputMsg
        |> withPasswordType VisibilityToggled model.visibility
        |> toHtml model.inputValue

-}
withPasswordType : (Bool -> msg) -> Bool -> Input msg -> Input msg
withPasswordType visibilityToggledTagger state (Input inputOpts tagger) =
    let
        newOpts =
            { inputOpts
                | type_ = Password { textVisible = state } visibilityToggledTagger
            }
    in
    Input newOpts tagger



--------------------------------------------
----- View code


iconToHtml : msg -> Icon msg -> Html msg
iconToHtml msg icon =
    let
        iconHtml =
            icon
                |> Icons.withStyles
                    [ ( "position", "relative" )
                    , ( "top", "3px" )
                    , ( "float", "right" )
                    ]
                |> Icons.toHtml
    in
    H.span
        [ E.onClick msg
        , class passwordInputVisibilityToggleIconClass
        ]
        [ iconHtml ]


passwordInputToHtml : (Bool -> msg) -> { textVisible : Bool } -> List (Attribute msg) -> Html msg
passwordInputToHtml tagger { textVisible } baseAttributes =
    let
        msg =
            tagger (not textVisible)

        ( passwordInputAttribute, optionalIcon ) =
            if textVisible then
                ( Attr.type_ "text"
                , iconToHtml msg Icons.eyeOutlined
                )

            else
                ( Attr.type_ "password"
                , iconToHtml msg Icons.eyeInvisibleOutlined
                )
    in
    H.div
        [ class inputRootClass ]
        [ H.input (passwordInputAttribute :: baseAttributes) []
        , optionalIcon
        ]


{-| Convert the input into a `Html msg`
-}
toHtml : String -> Input msg -> Html msg
toHtml value (Input inputOpts tagger) =
    let
        placeholderValue =
            Maybe.withDefault "" inputOpts.placeholder

        baseAttributes =
            [ E.onInput tagger
            , class inputClass
            , placeholder placeholderValue
            , Attr.value value
            ]
    in
    case inputOpts.type_ of
        Text ->
            H.input
                (baseAttributes
                    ++ [ Attr.type_ "text"
                       , class inputRootClass
                       ]
                )
                []

        TextArea { rows } ->
            H.textarea
                (baseAttributes
                    ++ [ Attr.rows rows
                       , class inputRootClass
                       ]
                )
                []

        Password visibilityState visibilityToggleTagger ->
            passwordInputToHtml visibilityToggleTagger visibilityState baseAttributes
