module Editor.State exposing (initialState, setMode)

import Editor.Types exposing (Editor, Mode(Grid))


initialState : Editor
initialState =
    { mode = Grid
    }


setMode : Mode -> Editor -> Editor
setMode mode editor =
    { editor | mode = mode }
