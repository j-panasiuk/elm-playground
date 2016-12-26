module Board.Overlay exposing (..)

import Types exposing (..)
import Utils.Math as Math


size : ScreenRect -> ScreenRect -> Graph -> ScreenRect
size window offset graph =
    let
        ( width, height ) =
            ( window.width - offset.width, window.height - offset.height )

        viewportRatio =
            Math.ratio width height

        boardRatio =
            Math.ratio graph.size.x graph.size.y
    in
        if viewportRatio > boardRatio then
            { width = Math.scale boardRatio height
            , height = height
            }
        else
            { width = width
            , height = Math.scale boardRatio width
            }



-- selectNode : ScreenRect -> Graph -> ScreenPoint -> EditorSelection -> EditorSelection
-- selectNode viewport graph screenPoint nodes =
--     nodes
-- HELPERS


toPosition : ScreenRect -> GridSize -> ScreenPoint -> Position
toPosition viewport size { layerX, layerY } =
    let
        tileSize =
            viewport.width // size.x
    in
        ( layerX // tileSize
        , layerY // tileSize |> reverseY size
        )


reverseY : GridSize -> Int -> Int
reverseY { y } index =
    y - index - 1
