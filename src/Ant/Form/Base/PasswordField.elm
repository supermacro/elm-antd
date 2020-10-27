module Ant.Form.Base.PasswordField exposing
    ( Attributes
    , form
    , PasswordField
    )

{-| This module contains a reusable `TextField` type.


# Definition

@docs TextField, Attributes


# Helpers

@docs form

-}

import Ant.Form.Base as Base
import Ant.Form.Field exposing (Field)


{-| Represents a text field.

**Note:** You should not need to care about this unless you are creating your own
custom fields or writing custom view code.

-}
type alias PasswordField values =
    Field Attributes { value : String, textVisible : Bool } values


{-| The attributes of a TextField.

You need to provide these to:

  - [`Form.textField`][textField]
  - [`Form.emailField`][emailField]
  - [`Form.passwordField`][passwordField]
  - [`Form.textareaField`][textareaField]

[textField]: Form#textField
[emailField]: Form#emailField
[passwordField]: Form#passwordField
[textareaField]: Form#textareaField

-}
type alias Attributes =
    { label : String
    , placeholder : String
    }


{-| Builds a [`Form`](Form-Base#Form) with a single `TextField`.

**Note:** You should not need to care about this unless you are creating your own
custom fields.

-}
form :
    (PasswordField values -> field)
    -> Base.FieldConfig Attributes { value : String, textVisible : Bool } values output
    -> Base.Form values output field
form =
    Base.field
        { isEmpty = \{ value } -> String.isEmpty value }
