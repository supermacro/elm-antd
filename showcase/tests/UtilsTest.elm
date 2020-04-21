module UtilsTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "example"
        [ test "does something" <|
            \_ -> Expect.equal 1 1
        ]
