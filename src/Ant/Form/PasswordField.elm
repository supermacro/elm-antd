module Ant.Form.PasswordField exposing (PasswordField, PasswordFieldValue, Attributes)

{-| This module contains a reusable `TextField` type.


# Definition

@docs PasswordField, PasswordFieldValue, Attributes

-}

import Ant.Form.Field exposing (Field)


{-| Represents the entire state of the stateful password input field.
-}
type alias PasswordFieldValue =
    { value : String
    , textVisible : Bool
    }


{-| Represents a password input field.

**Note:** You should not need to care about this unless you are creating your own
custom fields or writing custom view code.

-}
type alias PasswordField values =
    Field Attributes PasswordFieldValue values


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
