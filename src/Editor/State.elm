module Editor.State exposing (initialState, setMode, select)

import Types exposing (..)
import Board.Overlay as Overlay


-- INIT


initialState : Editor
initialState =
    { mode = ShowMaze
    , canvas = initCanvas ShowMaze
    , selection = initSelection ShowMaze
    }


initCanvas : EditorMode -> Canvas
initCanvas mode =
    { layers = layers mode
    }


initSelection : EditorMode -> EditorSelection
initSelection mode =
    case mode of
        ShowMaze ->
            NothingToSelect

        ShowNodes ->
            NodeSelection (Single Nothing)

        ShowEdges ->
            EdgeSelection (Single Nothing)



-- UPDATE


setMode : EditorMode -> Editor -> Editor
setMode mode ({ canvas } as editor) =
    { editor
        | mode = mode
        , canvas = { canvas | layers = layers mode }
        , selection = initSelection mode
    }


select : Int -> ScreenPoint -> Editor -> Editor
select tileSize screenPoint editor =
    { editor
        | selection = selectPoint tileSize screenPoint editor.selection
    }



-- HELPERS


layers : EditorMode -> List Layer
layers mode =
    case mode of
        ShowMaze ->
            [ Background, Maze, Grid ]

        ShowNodes ->
            [ Background, Maze, Nodes ]

        ShowEdges ->
            [ Background, Maze, Edges ]


{-| Translate selected board point to selectable object and add it to selection.
For now let's assume there is no toggle-select behaviour.
-}
selectPoint : Int -> ScreenPoint -> EditorSelection -> EditorSelection
selectPoint tileSize screenPoint selection =
    case selection of
        NothingToSelect ->
            NothingToSelect

        NodeSelection n ->
            NodeSelection (Single (Just (Overlay.toPosition tileSize screenPoint)))

        EdgeSelection e ->
            EdgeSelection (Single (Just (Overlay.toPositionPair tileSize screenPoint)))
