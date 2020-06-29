module Ant.Grid exposing
    ( ColSpan(..)
    , HorizontalArrangement(..)
    , VerticalAlignment(..)
    , breakPoints
    , col
    , row
    , toHtml
    )

{-| Primitives for buildign a 24-grid system based on rows and columns
-}

import Html exposing (Html, div, text)



-------------------------------------------
-------------------------------------------
------ Row


type alias BreakPoints =
    { xs : String
    , sm : String
    , md : String
    , lg : String
    , xl : String
    , xxl : String
    }


breakPoints : BreakPoints
breakPoints =
    { xs = "480px"
    , sm = "576px"
    , md = "768px"
    , lg = "992px"
    , xl = "1200px"
    , xxl = "1600px"
    }


type VerticalAlignment
    = Top
    | Middle
    | Bottom


type alias GutterSettings =
    { xs : Int
    , sm : Int
    , md : Int
    }


type alias ResponsiveGutter =
    { horizontal : GutterSettings
    , vertical : GutterSettings
    }


type HorizontalArrangement
    = Start
    | End
    | Center
    | SpaceAround
    | SpaceBetween


type alias RowOptions =
    { align : VerticalAlignment
    , gutter : ResponsiveGutter
    , justify : HorizontalArrangement
    }


defaultRowOptions : RowOptions
defaultRowOptions =
    { align = Top
    , gutter =
        { horizontal = { xs = 0, sm = 0, md = 0 }
        , vertical = { xs = 0, sm = 0, md = 0 }
        }
    , justify = Start
    }


type Row msg
    = Row RowOptions (List (Column msg))



-- withHorizontalGutter : GutterSettings -> RowOptions -> RowOptions
-------------------------------------------
-------------------------------------------
------ Column


type ColSpan
    = Zero
    | One
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Eleven
    | Tweleve
    | Thirteen
    | Fourteen
    | Fifteen
    | Sixteen
    | Seventeen
    | Eighteen
    | Nineteen
    | Twenty
    | TwentyOne
    | TwentyTwo
    | TwentyThree
    | TwentyFour



-- idea... allow for fractions???
-- | Fraction ( ColSpan, ColSpan )
{-
   colspanToInt : ColSpan -> Int
   colspanToInt colSpan =
       case colSpan of
           Zero -> 0
           One -> 1
           Two -> 2
           Three -> 3
           Four -> 4
           Five -> 5
           Six -> 6
           Seven -> 7
           Eight -> 8
           Nine -> 9
           Ten -> 10
           Eleven -> 11
           Tweleve -> 12
           Thirteen -> 13
           Fourteen -> 14
           Fifteen -> 15
           Sixteen -> 16
           Seventeen -> 17
           Eighteen -> 18
           Nineteen -> 19
           Twenty -> 20
           TwentyOne -> 21
           TwentyTwo -> 22
           TwentyThree -> 23
           TwentyFour -> 24
-}


type alias ColumnOptions =
    { span : ColSpan
    , offset : ColSpan
    }


defaultColumnOptions : ColumnOptions
defaultColumnOptions =
    { span = TwentyFour
    , offset = Zero
    }


type Column msg
    = Column ColumnOptions (Html msg)


row : List (Column msg) -> Row msg
row childColumns =
    Row defaultRowOptions childColumns


col : Html msg -> Column msg
col children =
    Column defaultColumnOptions children


toHtml : List (Row msg) -> Html msg
toHtml _ =
    div [] [ text "GRID" ]
