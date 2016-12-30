module Spec.Overlay exposing (all)

import Test exposing (..)
import Expect
import Utils.Fuzzers as Fz
import Types exposing (..)
import Utils.Math as Math
import Board.Overlay as Overlay


all : Test
all =
    describe "Overlay"
        [ describe "size" size
        , describe "toPosition" toPosition
        , describe "toEdge" toEdge
        ]


size : List Test
size =
    [ test "should exactly fit viewport when both are squares" <|
        \() ->
            Overlay.size
                (ScreenRect 200 200)
                (GridSize 2 2)
                |> Expect.equal (ScreenRect 200 200)
      ----
    , fuzz2 Fz.screenRect Fz.gridSize "should adjust overlay to fit viewport" <|
        \viewport gridSize ->
            let
                { width, height } =
                    Overlay.size viewport gridSize
            in
                Expect.true
                    "Expected overlay size to fit the viewport!"
                    (width == viewport.width || height == viewport.height)
      ----
    , fuzz2 Fz.screenRect Fz.gridSize "should preserve board ratio" <|
        \viewport gridSize ->
            let
                overlayRatio =
                    Math.rectRatio (Overlay.size viewport gridSize)

                gridRatio =
                    Math.ratio gridSize.cols gridSize.rows
            in
                Expect.atMost 0.025 (abs (1 - overlayRatio / gridRatio))
    ]


toPosition : List Test
toPosition =
    [ fuzz (Fz.screenPoint ( 200, 200 )) "should be ok (x)" <|
        \point ->
            Expect.all
                [ Expect.atLeast 0
                , Expect.atMost 200
                ]
                point.layerX
      ----
    , fuzz (Fz.screenPoint ( 200, 300 )) "should be ok (y)" <|
        \point ->
            Expect.all
                [ Expect.atLeast 0
                , Expect.atMost 300
                ]
                point.layerY
      ----
    , test "should return (0,1) for top left corner [3x2 grid]" <|
        \() ->
            Overlay.toPosition
                (ScreenRect 300 200)
                (GridSize 3 2)
                (ScreenPoint 50 50)
                |> Expect.equal ( 0, 1 )
      ----
    , test "should return (0,0) for bottom left corner [3x2 grid]" <|
        \() ->
            Overlay.toPosition
                (ScreenRect 300 200)
                (GridSize 3 2)
                (ScreenPoint 50 (200 - 50))
                |> Expect.equal ( 0, 0 )
      ----
    , test "should return (2,1) for top right corner [3x2 grid]" <|
        \() ->
            Overlay.toPosition
                (ScreenRect 300 200)
                (GridSize 3 2)
                (ScreenPoint (300 - 50) 50)
                |> Expect.equal ( 2, 1 )
      ----
    , test "should return (2,0) for bottom right corner [3x2 grid]" <|
        \() ->
            Overlay.toPosition
                (ScreenRect 300 200)
                (GridSize 3 2)
                (ScreenPoint (300 - 50) (200 - 50))
                |> Expect.equal ( 2, 0 )
      ----
    , test "should return (12,12) for center point [25x25 grid]" <|
        \() ->
            Overlay.toPosition
                (ScreenRect 1000 1000)
                (GridSize 25 25)
                (ScreenPoint 500 500)
                |> Expect.equal ( 12, 12 )
    ]



-- TODO


toEdge : List Test
toEdge =
    []
