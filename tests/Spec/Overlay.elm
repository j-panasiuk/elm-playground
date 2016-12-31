module Spec.Overlay exposing (all)

import Test exposing (..)
import Expect
import Utils.Fuzzers as Fz
import Types exposing (..)
import Board.Overlay as Overlay


all : Test
all =
    describe "Overlay"
        [ describe "toPosition" toPosition
        , describe "toPositionPair" toPositionPair
        , describe "flipVertical" flipVertical
        , describe "shrinkBy" shrinkBy
        ]


toPosition : List Test
toPosition =
    [ test "should match bottom left corner" <|
        \() ->
            Overlay.toPosition 100 (ScreenPoint 42 42)
                |> Expect.equal ( 0, 0 )
      ----
    , test "should match top left corner" <|
        \() ->
            Overlay.toPosition 100 (ScreenPoint 42 342)
                |> Expect.equal ( 0, 3 )
      ----
    , test "should match bottom right corner" <|
        \() ->
            Overlay.toPosition 100 (ScreenPoint 342 42)
                |> Expect.equal ( 3, 0 )
      ----
    , test "should match top right corner" <|
        \() ->
            Overlay.toPosition 100 (ScreenPoint 342 342)
                |> Expect.equal ( 3, 3 )
    ]



-- TODO


toPositionPair : List Test
toPositionPair =
    []


flipVertical : List Test
flipVertical =
    [ fuzz (Fz.screenPoint ( 999, 1000 )) "should flip point's vertical coordinate" <|
        \point ->
            point
                |> Overlay.flipVertical 1000
                |> .layerY
                |> Expect.equal (1000 - point.layerY)
    ]


shrinkBy : List Test
shrinkBy =
    [ fuzz2 (Fz.screenRect) (Fz.screenRect) "should not shrink below zero" <|
        \offset viewport ->
            Overlay.shrinkBy offset viewport
                |> (\rect -> min (rect.width) (rect.height))
                |> Expect.atLeast 0
    ]
