module Spec.Board exposing (all)

import Test exposing (..)
import Expect
import Utils.Fuzzers as Fz
import Types exposing (..)
import Board.Board as Board
import Utils.Math as Math


all : Test
all =
    describe "Board"
        [ describe "resize" resize
        ]


resize : List Test
resize =
    [ test "should exactly fit viewport when both are squares" <|
        \() ->
            Board.resize (ScreenRect 200 200) (GridSize 2 2)
                |> .viewport
                |> Expect.equal (ScreenRect 200 200)
      ----
    , fuzz2 Fz.screenRect Fz.gridSize "should adjust overlay to fit viewport" <|
        \parentBox gridSize ->
            let
                { viewport } =
                    Board.resize parentBox gridSize
            in
                Expect.true
                    "Expected overlay size to fit the viewport!"
                    (viewport.width == parentBox.width || viewport.height == parentBox.height)
      ----
    , fuzz2 Fz.screenRect Fz.gridSize "should preserve board ratio" <|
        \parentBox gridSize ->
            let
                boardRatio =
                    .ratio (Board.resize parentBox gridSize)

                gridRatio =
                    Math.ratio gridSize.cols gridSize.rows
            in
                Expect.atMost 0.025 (abs (1 - boardRatio / gridRatio))
    ]
