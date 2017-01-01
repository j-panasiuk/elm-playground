module Editor.State exposing (initialState, setMode, select)

import Types exposing (..)
import Board.Canvas as Canvas
import Board.Selection as Selection


-- INIT


initialState : Editor
initialState =
    { mode = ShowMaze
    , canvas = Canvas.init ShowMaze
    , selection = Selection.init ShowMaze
    }



-- UPDATE


setMode : EditorMode -> Editor -> Editor
setMode mode editor =
    { editor
        | mode = mode
        , canvas = Canvas.init mode
        , selection = Selection.init mode
    }


select : Int -> ScreenPoint -> Editor -> Editor
select tileSize screenPoint editor =
    { editor
        | selection = Selection.selectPoint tileSize screenPoint editor.selection
    }
