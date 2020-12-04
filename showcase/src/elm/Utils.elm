port module Utils exposing
    ( ComponentCategory(..)
    , DocumentationRoute
    , Flags
    , RawSourceCode
    , SourceCode
    , copySourceToClipboard
    , fetchComponentExamples
    , intoKebabCase
    )

import Html.Styled as Styled
import Http
import Json.Decode as D exposing (Decoder)


type alias CommitHash =
    Maybe String


type alias Flags =
    { commitHash : CommitHash
    , fileServerUrl : String
    , elmAntdVersion : Maybe String
    }


port copySourceToClipboard : String -> Cmd msg


type ComponentCategory
    = General
    | Layout
    | Navigation
    | DataEntry
    | DataDisplay
    | Feedback
    | Other


type alias RouteTitle =
    String



{-
   type alias FileName = String
   type alias Source = String
   type alias ExamplesSourceCode = Dict FileName Source
-}

type alias Versioned a =
    { a | version : Maybe String }

-- oddly enough `DocumentationRoute (Versioned model) msg` gives a type error


type alias DocumentationRoute model msg =
    { title : RouteTitle
    , update : msg -> Versioned model -> ( Versioned model, Cmd msg )
    , category : ComponentCategory
    , view : Versioned model -> Styled.Html msg
    , initialModel : Maybe String -> Versioned model
    , saveExampleSourceCodeToModel : List SourceCode -> msg
    }


intoTracker : ( Int, Char ) -> String -> String
intoTracker ( charIdx, char ) current =
    let
        newCurrentWord =
            if Char.isUpper char then
                let
                    lowercase =
                        String.fromChar <| Char.toLower char
                in
                if charIdx /= 0 then
                    current ++ "-" ++ lowercase

                else
                    current ++ lowercase

            else
                current ++ String.fromChar char
    in
    newCurrentWord


{-| Takes a PascalCase or snakeCase string and turns it into kebab-case-string
-}
intoKebabCase : String -> String
intoKebabCase str =
    let
        charList =
            String.toList str

        indexedList =
            List.indexedMap Tuple.pair charList
    in
    List.foldl intoTracker "" indexedList



{-
   Below is what __seems__ to be a very straightforward and simple mechanism for loading source code.

   Well let me tell ya ... there's some fancy shmance service worker HTTP intercepting going on.
   Check out showcase/src/sw.js for all the gory details.

   tldr; sw.js intercepts all requests for source code and returns a cached value if it exists.

   Locally, you'll need to run file-server (which accesses the filesystem). In https://elm-antd.netlify.app/
   the code is accessed via a github proxy server on GCP.
-}
-- Represents the decoded file


type alias SourceCode =
    { fileName : String
    , fileContents : String
    }


type alias RawSourceCode =
    { fileName : String
    , base64File : String
    }


sourceCodeDecoder : Decoder RawSourceCode
sourceCodeDecoder =
    D.map2 RawSourceCode
        (D.field "fileName" D.string)
        (D.field "base64File" D.string)



-- TODO: Should probably create an actual Route type. I keep having to create this type alias.
-- this is going to lead to subtle bugs in the future


type alias Route =
    String


ignoreRoutes : List Route
ignoreRoutes =
    [ "NotFound", "Home" ]


type alias FetchResult =
    Result Http.Error (List RawSourceCode)


fetchComponentExamples : String -> Maybe String -> String -> (FetchResult -> msg) -> Cmd msg
fetchComponentExamples baseUrl commitHash componentName tagger =
    let
        urlWithPath =
            baseUrl ++ "/example-files/" ++ componentName

        url =
            case commitHash of
                Just hash ->
                    urlWithPath ++ "?commitRef=" ++ hash

                Nothing ->
                    urlWithPath
    in
    Http.get
        { url = url
        , expect = Http.expectJson tagger (D.list sourceCodeDecoder)
        }
