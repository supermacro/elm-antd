module Ant.Input exposing
    ( input, InputSize(..), withSize, onInput, withPlaceholder, toHtml
    , Input, Model(..), Msg, updatePasswordInput, withPasswordType
    )

{-| Input widget for data entry

@docs input, InputSize, withSize, onInput, withPlaceholder, toHtml

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


type Model
    = Stateless
    | PasswordInputState { textVisible : Bool }


{-| Represents a customizeable input.
-}
type Input msg
    = Input (InputOpts msg)


{-| Determines the vertical height of the input
-}
type InputSize
    = Default
    | Large
    | Small


type InputType msg
    = Text
    | Password (Msg -> msg)


type alias InputOpts msg =
    { size : InputSize
    , placeholder : Maybe String
    , onInput : Maybe (String -> msg)
    , type_ : InputType msg
    }


defaultInputOpts : InputOpts msg
defaultInputOpts =
    { size = Default
    , placeholder = Nothing
    , onInput = Nothing
    , type_ = Text
    }


{-| Create a customizeable input component
-}
input : Input msg
input =
    Input defaultInputOpts


{-| Add a placeholder to the input
-}
withPlaceholder : String -> Input msg -> Input msg
withPlaceholder value (Input inputOpts) =
    let
        newOpts =
            { inputOpts | placeholder = Just value }
    in
    Input newOpts


{-| Change the size of the input
-}
withSize : InputSize -> Input msg -> Input msg
withSize size (Input inputOpts) =
    let
        newOpts =
            { inputOpts | size = size }
    in
    Input newOpts


{-| Emit a `msg` event that contains the current value (of type `String`) of the input on every keystroke
-}
onInput : (String -> msg) -> Input msg -> Input msg
onInput tagger (Input inputOpts) =
    let
        newOpts =
            { inputOpts | onInput = Just tagger }
    in
    Input newOpts



--------------------------------------------
----- Password Input Code


type Msg
    = PasswordVisibilityToggled


withPasswordType : (Msg -> msg) -> Input msg -> Input msg
withPasswordType tagger (Input inputOpts) =
    let
        newOpts =
            { inputOpts
                | type_ = Password tagger
            }
    in
    Input newOpts


updatePasswordInput : Msg -> Model -> Model
updatePasswordInput msg inputModel =
    case inputModel of
        Stateless ->
            inputModel

        PasswordInputState { textVisible } ->
            case msg of
                PasswordVisibilityToggled ->
                    PasswordInputState { textVisible = not textVisible }



--------------------------------------------
----- View code


iconToHtml : (Msg -> msg) -> Icon msg -> Html msg
iconToHtml tagger icon =
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
        [ E.onClick (tagger PasswordVisibilityToggled)
        , class passwordInputVisibilityToggleIconClass
        ]
        [ iconHtml ]


passwordInputToHtml : (Msg -> msg) -> Model -> List (Attribute msg) -> Html msg
passwordInputToHtml tagger model baseAttributes =
    let
        ( passwordInputAttribute, optionalIcon ) =
            case model of
                Stateless ->
                    ( Attr.type_ "password"
                    , H.span [] []
                    )

                PasswordInputState { textVisible } ->
                    if textVisible then
                        ( Attr.type_ "text"
                        , iconToHtml tagger Icons.eyeOutlined
                        )

                    else
                        ( Attr.type_ "password"
                        , iconToHtml tagger Icons.eyeInvisibleOutlined
                        )
    in
    H.div
        [ class inputRootClass ]
        [ H.input (passwordInputAttribute :: baseAttributes) []
        , optionalIcon
        ]


{-| Convert the input into a `Html msg`
-}
toHtml : Model -> Input msg -> Html msg
toHtml model (Input inputOpts) =
    let
        placeholderValue =
            Maybe.withDefault "" inputOpts.placeholder

        optionalAttributes =
            case inputOpts.onInput of
                Just tagger ->
                    [ E.onInput tagger ]

                Nothing ->
                    []

        baseAttributes =
            optionalAttributes
                ++ [ class inputClass
                   , placeholder placeholderValue
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

        Password tagger ->
            passwordInputToHtml tagger model baseAttributes
