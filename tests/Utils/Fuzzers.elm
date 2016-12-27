module Utils.Fuzzers exposing (..)

import Fuzz exposing (Fuzzer)
import Random.Pcg as Random exposing (Generator)
import Shrink exposing (Shrinker)
import Types exposing (ScreenRect, ScreenPoint, Position, GridSize)
import Board.Graph as Graph


-- CUSTOM FUZZERS


{-| Random graph node
-}
node : Fuzzer ( Int, Int )
node =
    let
        generator : Generator ( Int, Int )
        generator =
            Random.sample Graph.nodes
                |> Random.map (Maybe.withDefault ( 0, 0 ))

        shrinker : Shrinker ( Int, Int )
        shrinker =
            Shrink.tuple
                ( Shrink.int, Shrink.int )
    in
        Fuzz.custom generator shrinker


{-| Random graph edge
-}
edge : Fuzzer ( ( Int, Int ), ( Int, Int ) )
edge =
    let
        generator : Generator ( ( Int, Int ), ( Int, Int ) )
        generator =
            Random.sample Graph.edges
                |> Random.map (Maybe.withDefault ( ( 0, 0 ), ( 0, 1 ) ))

        shrinker : Shrinker ( ( Int, Int ), ( Int, Int ) )
        shrinker =
            Shrink.tuple
                ( Shrink.tuple ( Shrink.int, Shrink.int )
                , Shrink.tuple ( Shrink.int, Shrink.int )
                )
    in
        Fuzz.custom generator shrinker


{-| Random position within board boundaries (may not be a graph node!)

    ( Int -- (column index)
    , Int -- (row index)
    )
-}
position : Fuzzer Position
position =
    Fuzz.tuple ( xRange, yRange )


xRange : Fuzzer Int
xRange =
    Fuzz.intRange 0 ((.x Graph.size) - 1)


yRange : Fuzzer Int
yRange =
    Fuzz.intRange 0 ((.y Graph.size) - 1)


{-| Random grid size

    { x : Int -- (columns)
    , y : Int -- (rows)
    }
-}
gridSize : Fuzzer GridSize
gridSize =
    let
        generator : Generator GridSize
        generator =
            Random.map2 GridSize (Random.int 2 30) (Random.int 2 30)

        shrinker : Shrinker GridSize
        shrinker { x, y } =
            Shrink.map GridSize (Shrink.int x)
                |> Shrink.andMap (Shrink.int y)
    in
        Fuzz.custom generator shrinker


{-| Random screen viewport containing board overlay (of equal size)

    { width : Int -- (pixels)
    , height : Int -- (pixels)
    }
-}
screenRect : Int -> GridSize -> Fuzzer ScreenRect
screenRect tileSize { x, y } =
    let
        generator : Generator ScreenRect
        generator =
            Random.map2 ScreenRect (Random.int tileSize (x * tileSize)) (Random.int tileSize (y * tileSize))

        shrinker : Shrinker ScreenRect
        shrinker { width, height } =
            Shrink.map ScreenRect (Shrink.int width)
                |> Shrink.andMap (Shrink.int height)
    in
        Fuzz.custom generator shrinker


{-| Random screen point within board overlay
`width` and `height` are viewport dimensions

    { layerX : Int -- (pixels)
    , layerY : Int -- (pixels)
    }
-}
screenPoint : ( Int, Int ) -> Fuzzer ScreenPoint
screenPoint ( width, height ) =
    let
        generator : Generator ScreenPoint
        generator =
            Random.map2 ScreenPoint (Random.int 0 width) (Random.int 0 height)

        shrinker : Shrinker ScreenPoint
        shrinker { layerX, layerY } =
            Shrink.map ScreenPoint (Shrink.int layerX)
                |> Shrink.andMap (Shrink.int layerY)
    in
        Fuzz.custom generator shrinker
