module Editor.Types exposing (..)


type alias Editor =
    { mode : Mode
    }


type Mode
    = Grid
    | Nodes
    | Edges
