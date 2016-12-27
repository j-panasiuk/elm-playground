module Tests exposing (..)

import Test exposing (Test, describe)
import Spec.Graph as Graph
import Spec.Overlay as Overlay


all : Test
all =
    describe "All tests"
        [ Graph.all
        , Overlay.all
        ]
