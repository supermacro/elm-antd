module Ant.Css.Common exposing
    ( alertClass
    , alertErrorClass
    , alertInfoClass
    , alertStateAttributeName
    , alertSuccessClass
    , alertWarningClass
    , btnClass
    , btnDashedClass
    , btnDefaultClass
    , btnLinkClass
    , btnPrimaryClass
    , btnTextClass
    , inputClass
    , makeSelector
    )

import Css exposing (Style)
import Css.Global as CG exposing (Snippet)


makeSelector : String -> List Style -> Snippet
makeSelector =
    CG.selector << String.append "."


elmAntdPrefix : String
elmAntdPrefix =
    "elm-antd"



-------------------------
-------------------------
-- Alert Class Names


alertClass : String
alertClass =
    elmAntdPrefix ++ "__alert"



-- property name for tracking the state of a closeable alert


alertStateAttributeName : String
alertStateAttributeName =
    "is_closing"


alertSuccessClass : String
alertSuccessClass =
    alertClass ++ "-success"


alertInfoClass : String
alertInfoClass =
    alertClass ++ "-info"


alertWarningClass : String
alertWarningClass =
    alertClass ++ "-warning"


alertErrorClass : String
alertErrorClass =
    alertClass ++ "-error"



-------------------------
-------------------------
-- Button Class Names


btnClass : String
btnClass =
    elmAntdPrefix ++ "__btn"


btnDefaultClass : String
btnDefaultClass =
    btnClass ++ "-default"


btnPrimaryClass : String
btnPrimaryClass =
    btnClass ++ "-primary"


btnDashedClass : String
btnDashedClass =
    btnClass ++ "-dashed"


btnTextClass : String
btnTextClass =
    btnClass ++ "-text"


btnLinkClass : String
btnLinkClass =
    btnClass ++ "-link"



-------------------------
-------------------------
-- Input Class Names


inputClass : String
inputClass =
    elmAntdPrefix ++ "__input"
