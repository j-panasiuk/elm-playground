module Board.Overlay
    exposing
        ( toPosition
        , toPositionPair
        , flipVertical
        , shrinkBy
        )

import Types exposing (..)
import Utils.Math as Math


(=>) : a -> b -> ( a, b )
(=>) =
    (,)



-- HELPERS


{-| Translate point on overlay to grid tile (position)
Result doesn't have to be a graph node
-}
toPosition : Int -> ScreenPoint -> Position
toPosition tileSize { layerX, layerY } =
    ( layerX // tileSize
    , layerY // tileSize
    )


{-| Translate point on overlay to a pair of neighbor positions
Translation is done using diagonal coordinates
Result doesn't have to be a graph edge
-}
toPositionPair : Int -> ScreenPoint -> ( Position, Position )
toPositionPair tileSize { layerX, layerY } =
    let
        -- Position of point in diagonal coordinates
        -- (center points of tile edges form diagonal grid)
        ( i, j ) =
            ( floor (Math.ratio (layerX + layerY) tileSize)
            , floor (Math.ratio (layerX - layerY) tileSize)
            )
    in
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


{-| Flip vertical point coordinate to align with traditional y axis
(Use for mouse click events, which have reversed `layerY` coordinate)
-}
flipVertical : Int -> ScreenPoint -> ScreenPoint
flipVertical height { layerX, layerY } =
    ScreenPoint layerX (height - layerY)


{-| Shrink viewport size by given offset (pixels)
-}
shrinkBy : { width : Int, height : Int } -> ScreenRect -> ScreenRect
shrinkBy offset viewport =
    ScreenRect (max 0 (viewport.width - offset.width)) (max 0 (viewport.height - offset.height))
