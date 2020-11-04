module Ant.Form.Base.CheckboxField exposing (CheckboxField, Attributes)

{-| This module contains a reusable `CheckboxField` type.


# Definition

@docs CheckboxField, Attributes

-}

import Ant.Form.Field exposing (Field)


{-| Represents a checkbox field.

**Note:** You should not need to care about this unless you are creating your own
custom fields or writing custom view code.

-}
type alias CheckboxField values =
    Field Attributes Bool values


{-| The attributes of a CheckboxField.

You need to provide these to:

  - [`Form.checkboxField`][checkboxField]

[checkboxField]: Form#checkboxField

-}
type alias Attributes =
    { label : String }
