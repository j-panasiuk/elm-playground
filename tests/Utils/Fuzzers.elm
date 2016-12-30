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
    Fuzz.intRange 0 ((.cols Graph.size) - 1)


yRange : Fuzzer Int
yRange =
    Fuzz.intRange 0 ((.rows Graph.size) - 1)


{-| Random grid size

    { cols : Int
    , rows : Int
    }
-}
gridSize : Fuzzer GridSize
gridSize =
    Fuzz.map2 GridSize (Fuzz.intRange 2 20) (Fuzz.intRange 2 20)


{-| Random screen viewport
    { width : Int -- (pixels)
    , height : Int -- (pixels)
    }
-}
screenRect : Fuzzer ScreenRect
screenRect =
    Fuzz.map2 ScreenRect (Fuzz.intRange 160 1600) (Fuzz.intRange 160 1600)


{-| Random board viewport, with tiles of given size
    { width : Int -- (pixels)
    , height : Int -- (pixels)
    }
-}
boardRect : Int -> GridSize -> Fuzzer ScreenRect
boardRect tileSize { cols, rows } =
    let
        ( minWidth, maxWidth ) =
            ( 2 * tileSize, cols * tileSize )

        ( minHeight, maxHeight ) =
            ( 2 * tileSize, rows * tileSize )
    in
        Fuzz.map2 ScreenRect (Fuzz.intRange minWidth maxWidth) (Fuzz.intRange maxHeight maxHeight)


{-| Random screen point within board overlay
`width` and `height` are viewport dimensions

    { layerX : Int -- (pixels)
    , layerY : Int -- (pixels)
    }
-}
screenPoint : ( Int, Int ) -> Fuzzer ScreenPoint
screenPoint ( maxWidth, maxHeight ) =
    Fuzz.map2 ScreenPoint (Fuzz.intRange 0 maxWidth) (Fuzz.intRange 0 maxHeight)
