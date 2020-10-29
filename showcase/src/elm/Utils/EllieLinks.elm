module Utils.EllieLinks exposing (fromSourceCode)

import Parser exposing ((|.), (|=), DeadEnd, Parser, Problem(..), Step(..))
import Url.Builder
import Utils.FileParser as FileParser


fromSourceCode : String -> String -> String
fromSourceCode version elmCode =
    let
        { title, code } =
            FileParser.elliefy elmCode

        -- Package parsing is interesting because every package has its own '&packages='
        packagesUrl =
            packages version
                |> List.map packageToString
                |> List.map (\p -> ( "packages", p ))

        link =
            Url.Builder.crossOrigin
                "https://ellie-app.com/a/example/v1"
                []
                ([ ( "title", title )
                 , ( "elmcode", code )
                 , ( "htmlcode", htmlCode )
                 ]
                    ++ packagesUrl
                    ++ [ ( "elmversion", "0.19.1" ) ]
                    |> List.map
                        (\( key, value ) -> Url.Builder.string key value)
                )
    in
    link



---- PACKAGES


type alias Package =
    { name : String
    , version : String
    }



-- Elm-antd will have dynamic versioning


packages : String -> List Package
packages version =
    [ Package "elm/browser" "1.0.2"
    , Package "elm/core" "1.0.5"
    , Package "elm/html" "1.0.0"
    , Package "supermacro/elm-antd" version
    ]


packageToString : Package -> String
packageToString p =
    p.name ++ "@" ++ p.version



---- HTML


htmlCode : String
htmlCode =
    """<html>
<head>
  <style>
    /* you can style your program here */
  </style>
</head>
<body>
  <main></main>
  <script>
    var app = Elm.Main.init({ node: document.querySelector('main') })
    // you can use ports and stuff here
  </script>
</body>
</html>
"""
