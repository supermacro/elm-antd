module Button exposing (suite)

import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query

import Ant.Button exposing (button, disabled, onClick, toHtml)

type Msg = Clicked | NotClicked

suite : Test
suite =
    describe "Ant.Button"
        -- https://discourse.elm-lang.org/t/test-that-msg-is-not-emitted-on-disabled-button/5998
        [ Test.skip <| test "Does not emit a Msg for a disabled button" <|
            \_ ->
                button "disabled button"
                    |> onClick Clicked
                    |> disabled True
                    |> toHtml
                    |> Query.fromHtml
                    |> Event.simulate Event.click
                    |> Event.expect NotClicked
        
        , test "Emits a Msg when clicked and not disabled" <|
            \_ ->
                button "simple button"
                    |> onClick Clicked
                    |> toHtml
                    |> Query.fromHtml
                    |> Event.simulate Event.click
                    |> Event.expect Clicked
        ]

