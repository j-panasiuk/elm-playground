module Types exposing (..)

import Routes exposing (Route)
import Dict exposing (Dict)
import Set exposing (Set)
import Json.Decode exposing (Decoder, field, int)
import Window
import AStar


-- MODEL


type alias Model =
    { route : Maybe Route
    , window : ScreenRect
    , graph : Graph
    , game : Game
    , editor : Editor
    }



-- SCREEN


type alias ScreenRect =
    Window.Size


type alias ScreenPoint =
    { layerX : Int
    , layerY : Int
    }



-- LEVEL


type alias Level =
    { edges : List ( Position, Position )
    }



-- GRAPH


type alias Graph =
    { nodes : List Position
    , edges : List ( Position, Position )
    , neighbors : Dict Position (Set Position)
    , size : GridSize
    }


type alias Position =
    AStar.Position


type alias Path =
    AStar.Path


type alias GridSize =
    { x : Int
    , y : Int
    }



-- GAME


type alias Game =
    { mode : GameMode
    , canvas : List Layer
    }


type GameMode
    = NotStarted
    | Playing
    | Paused
    | GameOver



-- EDITOR


type alias Editor =
    { mode : EditorMode
    , canvas : List Layer
    , selection : Selection Selectable
    }


type EditorMode
    = CreateMaze
    | SelectNodes
    | SelectEdges


type Selectable
    = Node Position
    | Edge ( Position, Position )



-- CANVAS


type Layer
    = Grid
    | Background
    | Maze
    | Nodes
    | Edges


type Selection a
    = None
    | Single (Maybe a)
    | Double ( Maybe a, Maybe a )
    | Multiple (Set a)



-- DECODERS


screenPoint : Decoder ScreenPoint
screenPoint =
    Json.Decode.map2 ScreenPoint
        (field "layerX" int)
        (field "layerY" int)
