module Ant.Input exposing
    ( Input, input
    , InputSize(..), withSize, InputType(..), withType, withPlaceholder
    , Model, init, getValue, setValue
    , toHtml
    )

{-| Input widget for data entry


## Creating an input

@docs Input, input


## Modifying the input

@docs InputSize, withSize, InputType, withType, withPlaceholder


## Creating, getting and setting input state

@docs Model, init, getValue, setValue


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


{-| Opaque state of input. You can get the value of the input with `getValue` and also set the value with `setvalue`.
-}
type Model
    = Model
        { value : String
        , textVisible : Bool
        }


{-| Represents a customizeable input.
-}
type Input msg
    = Input InputOpts (Model -> msg)


{-| Determines the vertical height of the input
-}
type InputSize
    = Default
    | Large
    | Small


{-| Defines the different kinds of input values you can have.
-}
type InputType
    = Text
    | Password


type alias InputOpts =
    { size : InputSize
    , placeholder : Maybe String
    , type_ : InputType
    }


defaultInputOpts : InputOpts
defaultInputOpts =
    { size = Default
    , placeholder = Nothing
    , type_ = Text
    }


{-| Create a customizeable input component
-}
input : (Model -> msg) -> Input msg
input =
    Input defaultInputOpts


{-| Initialize the state of the input
-}
init : Model
init =
    Model { value = "", textVisible = True }


{-| Get the value of the input
-}
getValue : Model -> String
getValue (Model model) =
    model.value


{-| Set the value for the input
-}
setValue : String -> Model -> Model
setValue newVal (Model model) =
    Model { model | value = newVal }


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


{-| Modify the type of the input.

    input InputMsg
        |> withType Input.Password
        |> toHtml model

-}
withType : InputType -> Input msg -> Input msg
withType type_ (Input inputOpts tagger) =
    let
        newOpts =
            { inputOpts
                | type_ = type_
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


passwordInputToHtml : (Model -> msg) -> Model -> List (Attribute msg) -> Html msg
passwordInputToHtml tagger (Model model) baseAttributes =
    let
        updatedModel =
            { model | textVisible = not model.textVisible }

        msg =
            tagger (Model updatedModel)

        ( passwordInputAttribute, optionalIcon ) =
            if model.textVisible then
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
toHtml : Model -> Input msg -> Html msg
toHtml (Model model) (Input inputOpts tagger) =
    let
        placeholderValue =
            Maybe.withDefault "" inputOpts.placeholder

        baseAttributes =
            [ E.onInput (\newVal -> tagger <| Model { model | value = newVal })
            , class inputClass
            , placeholder placeholderValue
            , Attr.value model.value
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

        Password ->
            passwordInputToHtml tagger (Model model) baseAttributes
