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
    , board : Board
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



-- BOARD


type alias Board =
    { viewport : ScreenRect
    , ratio : Float
    , tileSize : Int
    }



-- GAME


type alias Game =
    { mode : GameMode
    , canvas : Canvas
    }


type GameMode
    = NotStarted
    | Playing
    | Paused
    | GameOver



-- EDITOR


type alias Editor =
    { mode : EditorMode
    , canvas : Canvas
    , selection : EditorSelection
    }


type EditorMode
    = ShowMaze
    | ShowNodes
    | ShowEdges


type EditorSelection
    = NothingToSelect
    | NodeSelection (Selection Position)
    | EdgeSelection (Selection ( Position, Position ))



-- CANVAS


type alias Canvas =
    { layers : List Layer
    }


type Layer
    = GridLayer
    | BackgroundLayer
    | MazeLayer
    | NodeLayer
    | EdgeLayer
    | SelectionLayer


type Selection a
    = Single (Maybe a)



-- DECODERS


screenPoint : Decoder ScreenPoint
screenPoint =
    Json.Decode.map2 ScreenPoint
        (field "layerX" int)
        (field "layerY" int)
