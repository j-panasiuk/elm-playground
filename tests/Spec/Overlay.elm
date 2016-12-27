module Spec.Overlay exposing (all)

import Test exposing (..)
import Expect
import Fuzz exposing (Fuzzer)
import Utils.Fuzzers
import Random.Pcg as Random exposing (Generator)
import Shrink exposing (Shrinker)


all : Test
all =
    describe "Overlay"
        [ describe "toPosition" toPosition
        , describe "toEdge" toEdge
        ]



-- TODO


toPosition : List Test
toPosition =
    [ fuzz (screenPoint ( 200, 200 )) "should be ok (x)" <|
        \point ->
            Expect.all
                [ Expect.atLeast 0
                , Expect.atMost 200
                ]
                point.layerX
      ----
    , fuzz (screenPoint ( 200, 300 )) "should be ok (y)" <|
        \point ->
            Expect.all
                [ Expect.atLeast 0
                , Expect.atMost 300
                ]
                point.layerY
    ]



-- TODO


toEdge : List Test
toEdge =
    []
