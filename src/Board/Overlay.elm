module Board.Overlay exposing (..)

import Types exposing (..)
import Utils.Math as Math


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


size : ScreenRect -> GridSize -> ScreenRect
size { width, height } { cols, rows } =
    let
        viewportRatio =
            Math.ratio width height

        boardRatio =
            Math.ratio cols rows
    in
        if viewportRatio > boardRatio then
            { width = round ((toFloat (height * cols)) / (toFloat rows))
            , height = height
            }
        else
            { width = width
            , height = round ((toFloat (width * rows)) / (toFloat cols))
            }


screenPointToSelectable : Selectable -> ScreenPoint -> Selectable
screenPointToSelectable selectable screenPoint =
    case selectable of
        Node n ->
            Node n

        Edge e ->
            Edge e



-- selectNode : ScreenRect -> Graph -> ScreenPoint -> EditorSelection -> EditorSelection
-- selectNode viewport graph screenPoint nodes =
--     nodes
-- HELPERS


toPosition : ScreenRect -> GridSize -> ScreenPoint -> Position
toPosition { width, height } { cols } { layerX, layerY } =
    let
        tileSize =
            width // cols
    in
        ( layerX // tileSize
        , (height - layerY) // tileSize
        )


toEdge : ScreenRect -> GridSize -> ScreenPoint -> ( Position, Position )
toEdge { width, height } { cols } { layerX, layerY } =
    let
        tileSize =
            width // cols

        -- Position of point in diagonal coordinates
        -- (center points of tile edges form diagonal grid)
        ( i, j ) =
            ( floor (Math.ratio (layerX + layerY) tileSize)
            , floor (Math.ratio (height - (layerX - layerY)) tileSize)
            )

        edge =
            if (i + j) % 2 == 0 then
                -- Edge is along vertical path
                ( ((i + j) // 2) => (floor (toFloat (i - j - 1) / 2))
                , ((i + j) // 2) => (ceiling (toFloat (i - j - 1) / 2))
                )
            else
                -- Edge is along horizontal path
                ( (floor (toFloat (i + j) / 2)) => ((i - j - 1) // 2)
                , (ceiling (toFloat (i + j) / 2)) => ((i - j - 1) // 2)
                )
    in
        edge
