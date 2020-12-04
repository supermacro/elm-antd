module Utils.FileParser exposing (elliefy)


{- | File-related Logic
-}

import Parser exposing ((|.), (|=), DeadEnd, Parser, Problem(..), Step(..))
import Url.Builder



-------------------
-- PARSING STUFF
-- Elliefy makes the code renderable in Ellie. WIP
-------------------


elliefy : String -> Result String { title : String, code : String }
elliefy srcCode =
    let
        ast =
            Parser.run fileParser srcCode

        title =
            Result.map getTitle ast

        code =
            ast
                |> Result.map (changeModuleNameTo "Main") 
                |> Result.map elliefyExports
                |> Result.map toString
    in
    Result.map2 
        (\t c -> { title = t, code = c })
        title 
        code
        |> Result.mapError deadEndsToString



-------------------
-- DATA
-------------------


type alias File =
    { moduleDeclaration : ModuleDeclaration
    , imports : String
    , codeBlocks : List CodeBlock
    }


type alias ModuleDeclaration =
    { name : String
    , exposes : List String
    }


type CodeBlock
    = TypeDef String
    | FunDef FunInfo


type alias FunInfo =
    { funName : String
    , typeAnnotation : String

    -- everything after the equals sign
    , val : String
    }



-------------------
-- PARSERS
-------------------


fileParser : Parser File
fileParser =
    Parser.succeed File
        |= moduleDeclarationParser
        |. spacesAndComments
        |= imports
        |. spacesAndComments
        |= codeBlocks


moduleDeclarationParser : Parser ModuleDeclaration
moduleDeclarationParser =
    let
        moduleName : Parser String
        moduleName =
            Parser.chompUntil " "
                |> Parser.getChompedString
    in
    Parser.succeed ModuleDeclaration
        |. Parser.keyword "module"
        |. Parser.spaces
        |= moduleName
        |. Parser.spaces
        |. Parser.keyword "exposing"
        |. Parser.spaces
        |= exposes



-- literally parses the big chonk of code
-- we don't need to manipulate imports so there's no need


imports : Parser String
imports =
    Parser.chompUntil "\n\n\n"
        |> Parser.getChompedString


codeBlocks : Parser (List CodeBlock)
codeBlocks =
    let
        importsHelper : List CodeBlock -> Parser (Step (List CodeBlock) (List CodeBlock))
        importsHelper revImports =
            Parser.oneOf
                [ Parser.succeed (\imp -> Loop (imp :: revImports))
                    |= Parser.oneOf [ parseType, parseFunction ]
                    |. Parser.spaces
                , Parser.succeed ()
                    |> Parser.map (\_ -> Done (List.reverse revImports))
                ]

        parseType : Parser CodeBlock
        parseType =
            Parser.keyword "type"
                |. Parser.chompUntilEndOr "\n\n\n"
                |> Parser.getChompedString
                |> Parser.map TypeDef

        parseFunction : Parser CodeBlock
        parseFunction =
            (Parser.getChompedString <| Parser.chompUntil " ")
                |> Parser.andThen
                    (\name ->
                        Parser.succeed (FunInfo name)
                            |= (Parser.getChompedString <| Parser.chompUntil "\n")
                            |. Parser.spaces
                            |. Parser.token name
                            |= (Parser.getChompedString <| Parser.chompUntilEndOr "\n\n\n")
                            |> Parser.map FunDef
                    )
    in
    Parser.loop [] importsHelper



-----------------------
-- HELPERS
-----------------------


{- parses stuff between (..) -}
exposes : Parser (List String)
exposes =
    let
        innerExposing : Parser (List String)
        innerExposing =
            Parser.chompUntil ")"
                |> Parser.getChompedString
                |> Parser.map (String.split "," >> List.map String.trim)
    in
    Parser.succeed identity
        |. Parser.token "("
        |= innerExposing
        |. Parser.token ")"


spacesAndComments : Parser ()
spacesAndComments =
    Parser.loop 0 <|
        ifProgress <|
            Parser.oneOf
                [ Parser.lineComment "--"
                , Parser.multiComment "{-" "-}" Parser.Nestable
                , Parser.spaces
                ]


ifProgress : Parser a -> Int -> Parser (Step Int ())
ifProgress parser offset =
    Parser.succeed identity
        |. parser
        |= Parser.getOffset
        |> Parser.map
            (\newOffset ->
                if offset == newOffset then
                    Done ()

                else
                    Loop newOffset
            )



-- copy and pasting YuichiMorita's PR since the elm/parser library hasn't implemented this yet :((


deadEndsToString : List DeadEnd -> String
deadEndsToString deadEnds =
    let
        deadEndToString : DeadEnd -> String
        deadEndToString deadEnd =
            let
                position : String
                position =
                    "row:" ++ String.fromInt deadEnd.row ++ " col:" ++ String.fromInt deadEnd.col ++ "\n"
            in
            case deadEnd.problem of
                Expecting str ->
                    "Expecting " ++ str ++ " at " ++ position

                ExpectingInt ->
                    "ExpectingInt at " ++ position

                ExpectingHex ->
                    "ExpectingHex at " ++ position

                ExpectingOctal ->
                    "ExpectingOctal at " ++ position

                ExpectingBinary ->
                    "ExpectingBinary at " ++ position

                ExpectingFloat ->
                    "ExpectingFloat at " ++ position

                ExpectingNumber ->
                    "ExpectingNumber at " ++ position

                ExpectingVariable ->
                    "ExpectingVariable at " ++ position

                ExpectingSymbol str ->
                    "ExpectingSymbol " ++ str ++ " at " ++ position

                ExpectingKeyword str ->
                    "ExpectingKeyword " ++ str ++ "at " ++ position

                ExpectingEnd ->
                    "ExpectingEnd at " ++ position

                UnexpectedChar ->
                    "UnexpectedChar at " ++ position

                Problem str ->
                    "ProblemString " ++ str ++ " at " ++ position

                BadRepeat ->
                    "BadRepeat at " ++ position
    in
    List.foldl (++) "" (List.map deadEndToString deadEnds)



-- for example, "Routes.AlertComponent.BasicExample" -> "BasicExample AlertComponent"
-- if parsing fails, it just return "bruh moment"


getTitle : File -> String
getTitle f =
    let
        splitName =
            String.split "." f.moduleDeclaration.name
                |> List.drop 1

        -- remove "Routes"
    in
    case splitName of
        [ component, name ] ->
            name ++ " - " ++ component

        _ ->
            "bruh moment"



-------------------
-- MANIPULATORS
-------------------


changeModuleNameTo : String -> File -> File
changeModuleNameTo newName file =
    let
        oldModuleDeclaration =
            file.moduleDeclaration

        newModuleDeclaration =
            { oldModuleDeclaration | name = newName }
    in
    { file | moduleDeclaration = newModuleDeclaration }



-- this only does one task so far
-- if the name is 'example', then change it to 'main


elliefyExports : File -> File
elliefyExports ({ moduleDeclaration } as file) =
    case moduleDeclaration.exposes of
        [ "example" ] ->
            let
                newExposes =
                    [ "main" ]

                -- rename instances of "example" to "main"
                newCodeBlocks =
                    file.codeBlocks
                        |> List.map
                            (\block ->
                                case block of
                                    FunDef funData ->
                                        if funData.funName == "example" then
                                            FunDef
                                                { funData | funName = "main" }

                                        else
                                            FunDef funData

                                    TypeDef _ ->
                                        -- do not change type definitions
                                        block
                            )
            in
            { file
                | moduleDeclaration = { moduleDeclaration | exposes = newExposes }
                , codeBlocks = newCodeBlocks
            }

        _ ->
            -- do nothing - yet!!
            file



-------------------
-- STRINGIFY
-------------------


toString : File -> String
toString file =
    let
        moduleDeclarationStr =
            "module "
                ++ file.moduleDeclaration.name
                ++ " exposing ("
                ++ String.join ", " file.moduleDeclaration.exposes
                ++ ")"

        importsStr =
            file.imports

        codeBlocksStr =
            List.map codeBlocksToString file.codeBlocks
                |> String.join "\n\n\n"
    in
    [ moduleDeclarationStr, importsStr, codeBlocksStr ]
        |> String.join "\n\n\n"


codeBlocksToString : CodeBlock -> String
codeBlocksToString block =
    case block of
        TypeDef val ->
            val

        FunDef { funName, typeAnnotation, val } ->
            funName ++ typeAnnotation ++ "\n" ++ funName ++ val
