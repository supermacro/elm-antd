module Routes.ButtonComponent exposing (route)

import Ant.Button as Btn exposing (button)
import Ant.Typography.Text as Text
import Html.Styled as Styled exposing (fromUnstyled, div, text, span)
import UI.Typography
    exposing
        ( documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )

import UI.Container as Container exposing (container) 
import Utils exposing (ComponentCategory(..), DocumentationRoute)


route : DocumentationRoute msg
route =
    { title = "Button"
    , category = General
    , view = view
    }


codeText : String -> Styled.Html msg
codeText value =
    Text.text value
        |> Text.code
        |> Text.toHtml
        |> fromUnstyled


view : msg -> Styled.Html msg
view msg =
    div []
        [ documentationHeading "Button"
        , documentationText <| text "To trigger an operation."
        , documentationSubheading "When To Use" True
        , documentationText <| text "A button means an operation (or a series of operations). Clicking a button will trigger corresponding business logic."
        , documentationText <| text "In Ant Design we provide 4 types of button."
        , documentationUnorderedList
            [ text "Primary button: indicate the main action, one primary button at most in one section."
            , text "Default button: indicate a series of actions without priority."
            , text "Dashed button: used for adding action commonly."
            ]
        , documentationText <| text "And 4 other properties additionally."
        , documentationUnorderedList
            [ span []
                [ codeText "danger"
                , text ": used for actions of risk, like deletion or authorization."
                ]
            , span []
                [ codeText "ghost"
                , text ": used in situations with complex background, home pages usually."
                ]
            , span []
                [ codeText "disabled"
                , text ": when actions are not available."
                ]
            , span []
                [ codeText "loading"
                , text ": add loading spinner in button, avoiding multiple submits too."
                ]
            ]
        , documentationSubheading "Examples" False
        , Container.toHtml <|
            container <|
                div []
                    [ text "children"
                    , button "Primary"
                        |> Btn.onClick msg
                        |> Btn.toHtml
                        |> fromUnstyled
                    ]
        ]
