module Types exposing (..)

import Routes exposing (Route)
import Dict exposing (Dict)
import Set exposing (Set)
import Json.Decode exposing (Decoder, field, int)


-- MODEL


type alias Model =
    { route : Maybe Route
    , window : ScreenRect
    , graph : Graph
    , game : Game
    , editor : Editor
    }



-- SCREEN


{-| This is redefined `Window.Size`
-}
type alias ScreenRect =
    { width : Int
    , height : Int
    }


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


{-| This is redefined `AStar.Position`
-}
type alias Position =
    ( Int, Int )


{-| This is redefined `AStar.Path`
-}
type alias Path =
    List Position


type alias GridSize =
    { cols : Int
    , rows : Int
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


type SelectBehavior
    = Toggle
    | Add



-- DECODERS


screenPoint : Decoder ScreenPoint
screenPoint =
    Json.Decode.map2 ScreenPoint
        (field "layerX" int)
        (field "layerY" int)
