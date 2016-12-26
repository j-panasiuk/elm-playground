module Editor.State exposing (initialState, setMode)

import Types exposing (..)


initialState : Editor
initialState =
    { mode = CreateMaze
    , canvas = layers CreateMaze
    , selection = selection CreateMaze
    }


setMode : EditorMode -> Editor -> Editor
setMode mode editor =
    { editor
        | mode = mode
        , canvas = layers mode
        , selection = selection mode
    }



-- HELPERS


layers : EditorMode -> List Layer
layers mode =
    case mode of
        CreateMaze ->
            [ Background, Maze, Grid ]

        SelectNodes ->
            [ Background, Maze, Nodes ]

        SelectEdges ->
            [ Background, Maze, Edges ]


selection : EditorMode -> Selection Selectable
selection mode =
    case mode of
        CreateMaze ->
            None

        SelectNodes ->
            Single (Just (Node ( 0, 0 )))

        SelectEdges ->
            Single (Just (Edge ( ( 0, 0 ), ( 0, 1 ) )))



-- select : ScreenPoint -> Selection Selectable -> Selection Selectable
-- select screenPoint selection =
--     case selection of
--         None -> None
--         Single selectable -> Single (switch to selected one...)
--         Double (selectable1, selectable2) -> Double (update somehow...)
--         Multiple selectables -> Multiple (toggle selected one...)
