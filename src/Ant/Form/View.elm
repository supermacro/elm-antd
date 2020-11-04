module Ant.Form.View exposing
    ( Model, State(..), idle
    , ViewConfig, Validation(..)
    , toHtml
    , FormConfig
    )

{-| This module provides helpers to render a [`Form`](Form#Form).


# Model

@docs Model, State, idle


# Configuration

@docs ViewConfig, Validation


# Basic HTML

@docs toHtml


# Custom

@docs CustomConfig, FormConfig, InputFieldConfig, NumberFieldConfig, RangeFieldConfig
@docs CheckboxFieldConfig, RadioFieldConfig, SelectFieldConfig
@docs FormListConfig, FormListItemConfig

-}

import Ant.Button as Button exposing (button)
import Ant.Checkbox as Checkbox exposing (checkbox)
import Ant.Css.Common
    exposing
        ( formCheckboxFieldClass
        , formFieldErrorMessageClass
        , formFieldErrorMessageShowingClass
        , formGroupClass
        , formLabelClass
        , formLabelInnerClass
        , formRequiredFieldClass
        , formSubmitButtonClass
        )
import Ant.Form as Form exposing (Form)
import Ant.Form.Base.NumberField as NumberField
import Ant.Form.Base.RadioField as RadioField
import Ant.Form.Base.RangeField as RangeField
import Ant.Form.Base.SelectField as SelectField
import Ant.Form.CheckboxField as CheckboxField
import Ant.Form.Error as Error exposing (Error)
import Ant.Form.InputField as InputField
import Ant.Form.PasswordField as PasswordField
import Ant.Input as Input exposing (input)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode
import Set exposing (Set)


{-| This type gathers the values of the form, with some exposed state and internal view state that
tracks which fields should show validation errors.
-}
type alias Model values =
    { values : values
    , state : State
    , errorTracking : ErrorTracking
    }


{-| Represents the state of the form.

You can change it at will from your `update` function. For example, you can set the state to
`Loading` if submitting the form fires a remote action, or you can set it to `Error` when
such action fails.

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            FormChanged newModel ->
                ( { newModel | state = FormView.Idle }, Cmd.none )

            SignUp email password ->
                ( { model | state = FormView.Loading }
                , User.signUp email password
                    |> Task.attempt SignupTried
                )

            SignupTried (Ok user) ->
                ( { model | state = FormView.Success "You are now registered successfully :)" }, Route.navigate (Route.Profile user.slug) )

            SignupTried (Err error) ->
                ( { model | state = FormView.Error error }, Cmd.none )

-}
type State
    = Idle
    | Loading
    | Error String
    | Success


type ErrorTracking
    = ErrorTracking { showAllErrors : Bool, showFieldError : Set String }


{-| Create a `Model` representing an idle form.

You just need to provide the initial `values` of the form.

-}
idle : values -> Model values
idle values =
    { values = values
    , state = Idle
    , errorTracking =
        ErrorTracking
            { showAllErrors = False
            , showFieldError = Set.empty
            }
    }



-- Configuration


{-| This allows you to configure the view output.

  - `onChange` specifies the message that should be produced when the `Model` changes.
  - `action` is the text of the submit button when the form is not loading.
  - `loading` is the text of the submit button when the form is loading.
  - `validation` lets you choose the validation strategy.

-}
type alias ViewConfig values msg =
    { onChange : Model values -> msg
    , action : String
    , loading : String
    , validation : Validation
    }


{-| The validation strategy.

  - `ValidateOnSubmit` will show field errors only when the user tries to submit an invalid form.
  - `ValidateOnBlur` will show field errors as fields are blurred. It uses field labels to identify fields on the form. This validation strategy will not work as expected if your form has multiple fields with the same label.

-}
type Validation
    = ValidateOnSubmit
    | ValidateOnBlur


type alias CustomConfig msg element =
    { form : FormConfig msg element -> element
    , inputField : InputFieldConfig msg -> element
    , passwordField : PasswordFieldConfig msg -> element
    , textareaField : InputFieldConfig msg -> element
    , numberField : NumberFieldConfig msg -> element
    , rangeField : RangeFieldConfig msg -> element
    , checkboxField : CheckboxFieldConfig msg -> element
    , radioField : RadioFieldConfig msg -> element
    , selectField : SelectFieldConfig msg -> element
    , group : List element -> element
    , section : String -> List element -> element
    , formList : FormListConfig msg element -> element
    , formListItem : FormListItemConfig msg element -> element
    }


{-| Describes how a form should be rendered.

  - `onSubmit` contains the output of the form if there are no validation errors.
  - `state` is the [`State`](#State) of the form.
  - `action` is the main action of the form, you should probably render this in the submit button.
  - `loading` is the loading message that should be shown when the form is loading.
  - `fields` contains the already rendered fields.

-}
type alias FormConfig msg element =
    { onSubmit : Maybe msg
    , state : State
    , action : String
    , loading : String
    , fields : List element
    }


{-| Represents non-interactive HTML that a user _MIGHT_ want to add to form fields
-}
type alias AdjacentHtml =
    Maybe (Html Never)


{-| Describes how a text field should be rendered.

  - `onChange` takes a new value for the field and returns the `msg` that should be produced.
  - `onBlur` might contain a `msg` that should be produced when the field is blurred.
  - `disabled` tells you whether the field should be disabled or not. It is `True` when the form is
    loading.
  - `value` contains the current value of the field.
  - `error` might contain a field [`Error`](Form-Error#Error).
  - `showError` tells you if you should show the `error` for this particular field. Its value
    depends on the [validation strategy](#Validation).
  - `attributes` are [`InputField.Attributes`](Form-Base-InputField#Attributes).

-}
type alias InputFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , attributes : InputField.Attributes
    , isOptional : Bool
    , adjacentHtml : AdjacentHtml

    --, modifiers : List (Input msg -> Input msg)
    }


type alias PasswordFieldConfig msg =
    { onChange : String -> msg
    , onToggleTextVisibility : Bool -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : PasswordField.PasswordFieldValue
    , error : Maybe Error
    , showError : Bool
    , attributes : PasswordField.Attributes
    , adjacentHtml : AdjacentHtml
    , isOptional : Bool
    }


{-| Describes how a number field should be rendered.

  - `onChange` takes a new value for the field and returns the `msg` that should be produced.
  - `value` contains the current value of the field.
  - `attributes` are [`NumberField.Attributes`](Form-Base-NumberField#Attributes).

The other record fields are described in [`InputFieldConfig`](#InputFieldConfig).

-}
type alias NumberFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , adjacentHtml : AdjacentHtml
    , attributes : NumberField.Attributes Float
    , isOptional : Bool
    }


{-| Describes how a range field should be rendered.

  - `onChange` accepts a `Maybe` so the field value can be cleared.
  - `value` will be `Nothing` if the field is blank or `Just` a `Float`.
  - `attributes` are [`RangeField.Attributes`](Form-Base-RangeField#Attributes).

The other record fields are described in [`InputFieldConfig`](#InputFieldConfig).

-}
type alias RangeFieldConfig msg =
    { onChange : Maybe Float -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : Maybe Float
    , error : Maybe Error
    , showError : Bool
    , attributes : RangeField.Attributes Float
    , adjacentHtml : AdjacentHtml
    , isOptional : Bool
    }


{-| Describes how a checkbox field should be rendered.

This is basically a [`InputFieldConfig`](#InputFieldConfig), but its `attributes` are
[`CheckboxField.Attributes`](Form-Base-CheckboxField#Attributes).

-}
type alias CheckboxFieldConfig msg =
    { onChange : Bool -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : Bool
    , adjacentHtml : AdjacentHtml
    , error : Maybe Error
    , showError : Bool
    , attributes : CheckboxField.Attributes
    }


{-| Describes how a radio field should be rendered.

This is basically a [`InputFieldConfig`](#InputFieldConfig), but its `attributes` are
[`RadioField.Attributes`](Form-Base-RadioField#Attributes).

-}
type alias RadioFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , adjacentHtml : AdjacentHtml
    , showError : Bool
    , attributes : RadioField.Attributes
    , isOptional : Bool
    }


{-| Describes how a select field should be rendered.

This is basically a [`InputFieldConfig`](#InputFieldConfig), but its `attributes` are
[`SelectField.Attributes`](Form-Base-SelectField#Attributes).

-}
type alias SelectFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , adjacentHtml : AdjacentHtml
    , showError : Bool
    , attributes : SelectField.Attributes
    , isOptional : Bool
    }


{-| Describes how a form list should be rendered.

  - `forms` is a list containing the elements of the form list.
  - `add` describes an optional "add an element" button. It contains a lazy `action` that can be called in order to add a new element and a `label` for the button.

-}
type alias FormListConfig msg element =
    { forms : List element
    , label : String
    , add : Maybe { action : () -> msg, label : String }
    , disabled : Bool
    }


{-| Describes how an item in a form list should be rendered.

  - `fields` contains the different fields of the item.
  - `delete` describes an optional "delete item" button. It contains a lazy `action` that can be called in order to delete the item and a `label` for the button.

-}
type alias FormListItemConfig msg element =
    { fields : List element
    , delete : Maybe { action : () -> msg, label : String }
    , disabled : Bool
    }


type alias FieldConfig values msg =
    { onChange : values -> msg
    , onBlur : Maybe (String -> msg)
    , disabled : Bool
    , showError : String -> Bool
    }


renderField :
    CustomConfig msg element
    -> FieldConfig values msg
    -> Form.FilledField values
    -> element
renderField customConfig ({ onChange, onBlur, disabled, showError } as fieldConfig) field =
    let
        blur label =
            Maybe.map (\onBlurEvent -> onBlurEvent label) onBlur
    in
    case field.state of
        Form.Password { attributes, value, update, isOptional } ->
            customConfig.passwordField
                { onChange =
                    \inputVal ->
                        update { value = inputVal, textVisible = value.textVisible }
                            |> onChange
                , onToggleTextVisibility =
                    \visibilityVal ->
                        update { value = value.value, textVisible = visibilityVal }
                            |> onChange
                , onBlur = blur attributes.label
                , disabled = disabled
                , value = value
                , error = field.error
                , showError = showError attributes.label
                , attributes = attributes
                , isOptional = isOptional
                , adjacentHtml = field.adjacentHtml
                }

        Form.Text type_ { attributes, value, update, isOptional } ->
            let
                config =
                    { onChange = update >> onChange
                    , onBlur = blur attributes.label
                    , disabled = field.isDisabled || disabled
                    , value = value
                    , error = field.error
                    , showError = showError attributes.label
                    , attributes = attributes
                    , isOptional = isOptional
                    , adjacentHtml = field.adjacentHtml
                    }
            in
            case type_ of
                Form.TextRaw ->
                    customConfig.inputField config

                Form.TextArea ->
                    customConfig.textareaField config

        Form.Number { attributes, value, update } ->
            customConfig.numberField
                { onChange = update >> onChange
                , onBlur = blur attributes.label
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , showError = showError attributes.label
                , attributes = attributes
                , adjacentHtml = field.adjacentHtml

                -- FIXME: hard-coding for now because this field is not in use / exported
                , isOptional = False
                }

        Form.Range { attributes, value, update } ->
            customConfig.rangeField
                { onChange = update >> onChange
                , onBlur = blur attributes.label
                , adjacentHtml = field.adjacentHtml
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , showError = showError attributes.label
                , attributes = attributes

                -- FIXME: hard-coding for now because this field is not in use / exported
                , isOptional = False
                }

        Form.Checkbox { attributes, value, update } ->
            customConfig.checkboxField
                { onChange = update >> onChange
                , onBlur = blur attributes.label
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , adjacentHtml = field.adjacentHtml
                , showError = showError attributes.label
                , attributes = attributes
                }

        Form.Radio { attributes, value, update } ->
            customConfig.radioField
                { onChange = update >> onChange
                , onBlur = blur attributes.label
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , adjacentHtml = field.adjacentHtml
                , showError = showError attributes.label
                , attributes = attributes

                -- FIXME: hard-coding for now because this field is not in use / exported
                , isOptional = False
                }

        Form.Select { attributes, value, update } ->
            customConfig.selectField
                { onChange = update >> onChange
                , onBlur = blur attributes.label
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , adjacentHtml = field.adjacentHtml
                , showError = showError attributes.label
                , attributes = attributes

                -- FIXME: hard-coding for now because this field is not in use / exported
                , isOptional = False
                }

        Form.Group fields ->
            fields
                |> List.map (maybeIgnoreChildError field.error >> renderField customConfig { fieldConfig | disabled = field.isDisabled || disabled })
                |> customConfig.group

        Form.Section title fields ->
            fields
                |> List.map (maybeIgnoreChildError field.error >> renderField customConfig { fieldConfig | disabled = field.isDisabled || disabled })
                |> customConfig.section title

        Form.List { forms, add, attributes } ->
            customConfig.formList
                { forms =
                    List.map
                        (\{ fields, delete } ->
                            customConfig.formListItem
                                { fields = List.map (renderField customConfig fieldConfig) fields
                                , delete =
                                    attributes.delete
                                        |> Maybe.map
                                            (\deleteLabel ->
                                                { action = delete >> onChange
                                                , label = deleteLabel
                                                }
                                            )
                                , disabled = field.isDisabled || disabled
                                }
                        )
                        forms
                , label = attributes.label
                , add =
                    attributes.add
                        |> Maybe.map
                            (\addLabel ->
                                { action = add >> onChange, label = addLabel }
                            )
                , disabled = field.isDisabled || disabled
                }


maybeIgnoreChildError : Maybe Error -> Form.FilledField values -> Form.FilledField values
maybeIgnoreChildError maybeParentError field =
    case maybeParentError of
        Just _ ->
            field

        Nothing ->
            { field | error = Nothing }



-- Basic HTML


{-| Default [`CustomConfig`](#CustomConfig) implementation for HTML output.
-}
htmlViewConfig : CustomConfig msg (Html msg)
htmlViewConfig =
    { form = form
    , inputField = inputField
    , group = group
    , passwordField = passwordInputField

    -- TODO: Un-integrated
    , textareaField = textareaField
    , numberField = numberField
    , rangeField = rangeField
    , checkboxField = checkboxField
    , radioField = radioField
    , selectField = selectField
    , section = section
    , formList = formList
    , formListItem = formListItem
    }


{-| Render a form as HTML!

    FormView.toHtml
        { onChange = FormChanged
        , action = "Log in"
        , loading = "Logging in..."
        , validation = FormView.ValidateOnSubmit
        }
        loginForm
        model

-}
toHtml : ViewConfig values msg -> Form values msg -> Model values -> Html msg
toHtml { onChange, action, loading, validation } form_ model =
    let
        { fields, result } =
            Form.fill form_ model.values

        errorTracking =
            (\(ErrorTracking e) -> e) model.errorTracking

        onSubmit =
            case result of
                Ok msg ->
                    if model.state == Loading then
                        Nothing

                    else
                        Just msg

                Err _ ->
                    if errorTracking.showAllErrors then
                        Nothing

                    else
                        Just
                            (onChange
                                { model
                                    | errorTracking =
                                        ErrorTracking
                                            { errorTracking | showAllErrors = True }
                                }
                            )

        fieldToElement =
            renderField
                htmlViewConfig
                { onChange = \values -> onChange { model | values = values }
                , onBlur = onBlur
                , disabled = model.state == Loading
                , showError = showError
                }

        onBlur =
            case validation of
                ValidateOnSubmit ->
                    Nothing

                ValidateOnBlur ->
                    Just
                        (\label ->
                            onChange
                                { model
                                    | errorTracking =
                                        ErrorTracking
                                            { errorTracking
                                                | showFieldError =
                                                    Set.insert label errorTracking.showFieldError
                                            }
                                }
                        )

        showError label =
            errorTracking.showAllErrors || Set.member label errorTracking.showFieldError
    in
    htmlViewConfig.form
        { onSubmit = onSubmit
        , action = action
        , loading = loading
        , state = model.state
        , fields = List.map fieldToElement fields
        }


formList : FormListConfig msg (Html msg) -> Html msg
formList { forms, label, add, disabled } =
    let
        addButton =
            case ( disabled, add ) of
                ( False, Just add_ ) ->
                    Html.button
                        [ Events.onClick add_.action
                        , Attributes.type_ "button"
                        ]
                        [ Html.i [ Attributes.class "fas fa-plus" ] []
                        , Html.text add_.label
                        ]
                        |> Html.map (\f -> f ())

                _ ->
                    Html.text ""
    in
    Html.div [ Attributes.class "elm-form-list" ]
        (fieldLabel label
            :: (forms ++ [ addButton ])
        )


formListItem : FormListItemConfig msg (Html msg) -> Html msg
formListItem { fields, delete, disabled } =
    let
        deleteButton =
            case ( disabled, delete ) of
                ( False, Just delete_ ) ->
                    Html.button
                        [ Events.onClick delete_.action
                        , Attributes.type_ "button"
                        ]
                        [ Html.text delete_.label
                        , Html.i [ Attributes.class "fas fa-times" ] []
                        ]
                        |> Html.map (\f -> f ())

                _ ->
                    Html.text ""
    in
    Html.div [ Attributes.class "elm-form-list-item" ]
        (deleteButton :: fields)


form : FormConfig msg (Html msg) -> Html msg
form { onSubmit, action, loading, state, fields } =
    let
        onSubmitEvent =
            onSubmit
                |> Maybe.map (Events.onSubmit >> List.singleton)
                |> Maybe.withDefault []

        submitButtonText =
            if state == Loading then
                loading

            else
                action

        submitButton =
            button submitButtonText
                |> Button.disabled (onSubmit == Nothing)
                |> Button.withHtmlType Button.Submit
                |> Button.withType Button.Primary
                |> Button.toHtml
                |> List.singleton
                |> Html.div [ Attributes.class formSubmitButtonClass ]
    in
    Html.form (Attributes.class "elm-form" :: onSubmitEvent)
        (List.concat
            [ fields
            , [ case state of
                    Error error ->
                        errorMessage error

                    _ ->
                        Html.text ""
              , submitButton
              ]
            ]
        )


inputField : InputFieldConfig msg -> Html msg
inputField ({ onChange, value, attributes, adjacentHtml } as fieldInfo) =
    input onChange
        |> Input.withPlaceholder attributes.placeholder
        |> Input.toHtml value
        |> withLabelAndError fieldInfo attributes.label adjacentHtml


passwordInputField : PasswordFieldConfig msg -> Html msg
passwordInputField ({ onChange, onToggleTextVisibility, value, attributes, adjacentHtml } as fieldInfo) =
    input onChange
        |> Input.withPlaceholder attributes.placeholder
        |> Input.withPasswordType onToggleTextVisibility value.textVisible
        |> Input.toHtml value.value
        |> withLabelAndError fieldInfo attributes.label adjacentHtml


textareaField : InputFieldConfig msg -> Html msg
textareaField ({ onChange, onBlur, disabled, value, attributes, adjacentHtml } as fieldInfo) =
    Html.textarea
        ([ Events.onInput onChange
         , Attributes.disabled disabled
         , Attributes.placeholder attributes.placeholder
         , Attributes.value value
         ]
            |> withMaybeAttribute Events.onBlur onBlur
        )
        []
        |> withLabelAndError fieldInfo attributes.label adjacentHtml


numberField : NumberFieldConfig msg -> Html msg
numberField ({ onChange, onBlur, disabled, value, attributes, adjacentHtml } as fieldInfo) =
    let
        stepAttr =
            attributes.step
                |> Maybe.map String.fromFloat
                |> Maybe.withDefault "any"
    in
    Html.input
        ([ Events.onInput onChange
         , Attributes.disabled disabled
         , Attributes.value value
         , Attributes.placeholder attributes.placeholder
         , Attributes.type_ "number"
         , Attributes.step stepAttr
         ]
            |> withMaybeAttribute (String.fromFloat >> Attributes.max) attributes.max
            |> withMaybeAttribute (String.fromFloat >> Attributes.min) attributes.min
            |> withMaybeAttribute Events.onBlur onBlur
        )
        []
        |> withLabelAndError fieldInfo attributes.label adjacentHtml


rangeField : RangeFieldConfig msg -> Html msg
rangeField ({ onChange, onBlur, disabled, value, attributes, adjacentHtml } as fieldInfo) =
    Html.div
        [ Attributes.class "elm-form-range-field" ]
        [ Html.input
            ([ Events.onInput (fromString String.toFloat value >> onChange)
             , Attributes.disabled disabled
             , Attributes.value (value |> Maybe.map String.fromFloat |> Maybe.withDefault "")
             , Attributes.type_ "range"
             , Attributes.step (String.fromFloat attributes.step)
             ]
                |> withMaybeAttribute (String.fromFloat >> Attributes.max) attributes.max
                |> withMaybeAttribute (String.fromFloat >> Attributes.min) attributes.min
                |> withMaybeAttribute Events.onBlur onBlur
            )
            []
        , Html.span [] [ Html.text (value |> Maybe.map String.fromFloat |> Maybe.withDefault "") ]
        ]
        |> withLabelAndError fieldInfo attributes.label adjacentHtml


{-| TODO:
opportunity for refactoring:

  - onBlur

  - error

  - showError

    are unused for CheckboxFieldConfig

-}
checkboxField : CheckboxFieldConfig msg -> Html msg
checkboxField { onChange, value, disabled, attributes, adjacentHtml } =
    let
        checkboxHtml =
            checkbox
                |> Checkbox.withOnCheck onChange
                |> Checkbox.withLabel attributes.label
                |> Checkbox.withDisabled disabled
                |> Checkbox.toHtml value
    in
    Html.div [ Attributes.class formCheckboxFieldClass ] [ checkboxHtml, createAdjacentHtmlNode adjacentHtml ]


radioField : RadioFieldConfig msg -> Html msg
radioField ({ onChange, onBlur, disabled, value, error, showError, attributes } as fieldInfo) =
    let
        radio ( key, label ) =
            Html.label []
                [ Html.input
                    ([ Attributes.name attributes.label
                     , Attributes.value key
                     , Attributes.checked (value == key)
                     , Attributes.disabled disabled
                     , Attributes.type_ "radio"
                     , Events.onClick (onChange key)
                     ]
                        |> withMaybeAttribute Events.onBlur onBlur
                    )
                    []
                , Html.text label
                ]
    in
    Html.div (fieldContainerAttributes fieldInfo)
        ((fieldLabel attributes.label
            :: List.map radio attributes.options
         )
            ++ [ maybeErrorMessage showError error ]
        )


selectField : SelectFieldConfig msg -> Html msg
selectField ({ onChange, onBlur, disabled, value, error, showError, attributes, adjacentHtml } as fieldInfo) =
    let
        toOption ( key, label_ ) =
            Html.option
                [ Attributes.value key
                , Attributes.selected (value == key)
                ]
                [ Html.text label_ ]

        placeholderOption =
            Html.option
                [ Attributes.disabled True
                , Attributes.selected (value == "")
                ]
                [ Html.text ("-- " ++ attributes.placeholder ++ " --") ]
    in
    Html.select
        ([ Events.on "change" (Json.Decode.map onChange Events.targetValue)
         , Attributes.disabled disabled
         ]
            |> withMaybeAttribute Events.onBlur onBlur
        )
        (placeholderOption :: List.map toOption attributes.options)
        |> withLabelAndError fieldInfo attributes.label adjacentHtml


group : List (Html msg) -> Html msg
group =
    Html.div [ Attributes.class formGroupClass ]


section : String -> List (Html msg) -> Html msg
section title fields =
    Html.fieldset []
        (Html.legend [] [ Html.text title ]
            :: fields
        )


type alias FieldInfo a =
    { a
        | showError : Bool
        , error : Maybe Error
        , isOptional : Bool
    }


createAdjacentHtmlNode : Maybe (Html Never) -> Html msg
createAdjacentHtmlNode maybeAdjacentHtml =
    case maybeAdjacentHtml of
        Just node ->
            Html.map never node

        Nothing ->
            Html.text ""


wrapInFieldContainer : FieldInfo a -> List (Html msg) -> Html msg
wrapInFieldContainer fieldInfo =
    Html.label <| fieldContainerAttributes fieldInfo


fieldContainerAttributes : FieldInfo a -> List (Html.Attribute msg)
fieldContainerAttributes { isOptional, showError, error } =
    [ Attributes.classList
        [ ( formLabelClass, True )
        , ( formRequiredFieldClass, not isOptional )
        , ( formFieldErrorMessageShowingClass, showError && error /= Nothing )
        ]
    ]


withLabelAndError : FieldInfo a -> String -> Maybe (Html Never) -> Html msg -> Html msg
withLabelAndError ({ showError, error } as fieldInfo) label maybeAdjacentNode fieldAsHtml =
    [ fieldLabel label
    , Html.div []
        [ fieldAsHtml
        , maybeErrorMessage showError error
        , createAdjacentHtmlNode maybeAdjacentNode
        ]
    ]
        |> wrapInFieldContainer fieldInfo


fieldLabel : String -> Html msg
fieldLabel label =
    Html.div [ Attributes.class formLabelInnerClass ] [ Html.text label ]


maybeErrorMessage : Bool -> Maybe Error -> Html msg
maybeErrorMessage showError maybeError =
    let
        defaultNode =
            Html.div [ Attributes.class formFieldErrorMessageClass ] [ Html.text "" ]
    in
    case maybeError of
        Just (Error.External externalError) ->
            errorMessage externalError

        _ ->
            if showError then
                maybeError
                    |> Maybe.map errorToString
                    |> Maybe.map errorMessage
                    |> Maybe.withDefault defaultNode

            else
                defaultNode


errorMessage : String -> Html msg
errorMessage =
    Html.text >> List.singleton >> Html.div [ Attributes.class formFieldErrorMessageClass ]


errorToString : Error -> String
errorToString error =
    case error of
        Error.RequiredFieldIsEmpty ->
            "This field is required"

        Error.ValidationFailed validationError ->
            validationError

        Error.External externalError ->
            externalError


withMaybeAttribute : (a -> Html.Attribute msg) -> Maybe a -> List (Html.Attribute msg) -> List (Html.Attribute msg)
withMaybeAttribute toAttribute maybeValue attrs =
    Maybe.map (toAttribute >> (\attr -> attr :: attrs)) maybeValue
        |> Maybe.withDefault attrs


fromString : (String -> Maybe a) -> Maybe a -> String -> Maybe a
fromString parse currentValue input =
    if String.isEmpty input then
        Nothing

    else
        parse input
            |> Maybe.map Just
            |> Maybe.withDefault currentValue
