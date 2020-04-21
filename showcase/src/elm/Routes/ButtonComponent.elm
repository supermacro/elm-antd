module Routes.ButtonComponent exposing (category, title, view, Msg)

import Html exposing (Html, div, ul, li, text)

import Utils exposing
  ( ComponentCategory(..)
  , documentationHeading
  , documentationSubheading
  , documentationText
  , documentationUnorderedList
  )

import Ant.Button exposing (button)

type Msg
  = ButtonClicked

type alias Title = String

title : Title
title = "Button"

category : ComponentCategory
category = General

view : (Title, Html Msg)
view =
  ( title
  , div []
      [ documentationHeading "Button"
      , documentationText <| text "To trigger an operation."
      , documentationSubheading "When To Use" True
      , documentationText <| text "A button means an operation (or a series of operations). Clicking a button will trigger corresponding business logic."
      , documentationText <| text "In Ant Design we provide 4 types of button."
      , documentationUnorderedList
          [ "Primary button: indicate the main action, one primary button at most in one section."
          , "Default button: indicate a series of actions without priority."
          , "Dashed button: used for adding action commonly."
          ]
      , documentationText <| text "And 4 other properties additionally."
      , button ButtonClicked
      ]
  )
