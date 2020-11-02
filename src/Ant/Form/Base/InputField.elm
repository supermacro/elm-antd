module Ant.Form.Base.InputField exposing
    ( InputField, Attributes
    , form
    )

{-| This module contains a reusable `InputField` type.


# Definition

@docs InputField, Attributes


# Helpers

@docs form

-}

import Ant.Form.Base as Base
import Ant.Form.Field exposing (Field)


{-| Represents a text field.

**Note:** You should not need to care about this unless you are creating your own
custom fields or writing custom view code.

-}
type alias InputField values =
    Field Attributes String values


{-| The attributes of a InputField.

You need to provide these to:

  - [`Form.textField`][textField]
  - [`Form.emailField`][emailField]
  - [`Form.textareaField`][textareaField]

[textField]: Form#textField
[emailField]: Form#emailField
[textareaField]: Form#textareaField

-}
type alias Attributes =
    { label : String
    , placeholder : String
    }


{-| Builds a [`Form`](Form-Base#Form) with a single `InputField`.

**Note:** You should not need to care about this unless you are creating your own
custom fields.

-}
form :
    (InputField values -> field)
    -> Base.FieldConfig Attributes String values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = String.isEmpty }
