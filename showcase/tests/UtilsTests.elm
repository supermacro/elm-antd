module UtilsTests exposing (suite)

{-| Tests for Utils module
-}

import Expect
import Test exposing (describe, Test, test)
import Utils exposing (intoKebabCase)

suite : Test
suite =
    describe "Utils" <|
        [ describe "intoKebabCase"
            [ test "Converts PascalCase word into kebab-case" <|
                \_ -> 
                    Expect.equal (intoKebabCase "TorontoOntarioCanada") "toronto-ontario-canada"
            , test "Converts camelCase word into kebab-case" <|
                \_ ->
                    Expect.equal (intoKebabCase "torontoOntarioCanada") "toronto-ontario-canada"
            , test "Lower-cases single capitalized words" <|
                \_ ->
                    Expect.equal (intoKebabCase "Canada") "canada"
            ]
        ]

