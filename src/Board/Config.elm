module Board.Config exposing (..)

import Collage exposing (LineStyle, LineCap(Round), LineJoin(Smooth))
import Color


-- RATIOS


cellRatio : Float
cellRatio =
    0.8


laneRatio : Float
laneRatio =
    0.6


markerRatio : Float
markerRatio =
    0.16


lineRatio : Float
lineRatio =
    0.03



-- LINE STYLES


lineStyle : LineStyle
lineStyle =
    let
        defaultLine =
            Collage.solid Color.black
    in
        { defaultLine
            | cap = Round
            , join = Smooth
        }
