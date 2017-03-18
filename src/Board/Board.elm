module Board.Board exposing (resize)

import Types exposing (..)
import Utils.Math as Math


resize : ScreenRect -> GridSize -> Board
resize parentBox gridSize =
    let
        viewport =
            gridSize |> scaleToFit parentBox
    in
        { viewport = viewport
        , ratio = Math.rectRatio viewport
        , tileSize = viewport.width // gridSize.cols
        }


scaleToFit : ScreenRect -> GridSize -> ScreenRect
scaleToFit { width, height } { cols, rows } =
    let
        viewportRatio =
            Math.ratio width height

        boardRatio =
            Math.ratio cols rows
    in
        if viewportRatio > boardRatio then
            { width = round (toFloat (height * cols) / toFloat rows)
            , height = height
            }
        else
            { width = width
            , height = round (toFloat (width * rows) / toFloat cols)
            }
