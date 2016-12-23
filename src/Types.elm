module Types exposing (..)

import Routes exposing (Route)
import Dict exposing (Dict)
import Set exposing (Set)
import Json.Decode exposing (Decoder, field, int)
import Window
import AStar


-- MODELS


type alias Model =
    { route : Maybe Route
    , window : ScreenRect
    , graph : Graph
    }


type alias ScreenRect =
    WithRatio Window.Size


type alias ScreenPoint =
    { layerX : Int
    , layerY : Int
    }


type alias GridSize =
    -- WithRatio
    { x : Int
    , y : Int
    }


type alias WithRatio a =
    { a | ratio : Float }


type alias Position =
    AStar.Position


type alias Path =
    AStar.Path


type alias Level =
    { edges : List ( Position, Position )
    }


type alias Graph =
    { nodes : List Position
    , edges : List ( Position, Position )
    , neighbors : Dict Position (Set Position)
    , size : GridSize
    , ratio : Float
    }



-- DECODERS


screenPoint : Decoder ScreenPoint
screenPoint =
    Json.Decode.map2 ScreenPoint
        (field "layerX" int)
        (field "layerY" int)
