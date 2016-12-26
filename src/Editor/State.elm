module Editor.State exposing (initialState, setMode)

import Types exposing (Editor, EditorMode(..), Layer(..))


initialState : Editor
initialState =
    { mode = CreateMaze
    , canvas = layers CreateMaze
    }


setMode : EditorMode -> Editor -> Editor
setMode mode editor =
    { editor
        | mode = mode
        , canvas = layers mode
    }


layers : EditorMode -> List Layer
layers mode =
    case mode of
        CreateMaze ->
            [ Background, Maze, Grid ]

        SelectNodes ->
            [ Background, Maze, Nodes ]

        SelectEdges ->
            [ Background, Maze, Edges ]
