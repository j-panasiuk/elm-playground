module Editor.State exposing (initialState, setMode, select)

import Types exposing (..)
import Board.Graph as Graph
import Board.Canvas as Canvas
import Board.Selection as Selection


-- INIT


initialState : Editor
initialState =
    { mode = ShowMaze
    , canvas = Canvas.init ShowMaze
    , selection = Selection.init ShowMaze
    , pathEdges = Nothing
    }



-- UPDATE


setMode : EditorMode -> Editor -> Editor
setMode mode editor =
    { editor
        | mode = mode
        , canvas = Canvas.init mode
        , selection = Selection.init mode
        , pathEdges = Nothing
    }


select : Int -> ScreenPoint -> Editor -> Editor
select tileSize screenPoint editor =
    let
        newSelection =
            Selection.selectPoint tileSize screenPoint editor.selection

        newPathEdges =
            case ( editor.mode, newSelection ) of
                ( ShowPath, NodeSelection _ (Double ( Just node1, Just node2 )) ) ->
                    Graph.findPathEdges node1 node2

                ( _, _ ) ->
                    Nothing
    in
        { editor
            | selection = newSelection
            , pathEdges = newPathEdges
        }
