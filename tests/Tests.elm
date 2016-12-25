module Tests exposing (..)

import Test exposing (Test, describe)
import Spec.Graph as Graph


all : Test
all =
    describe "All tests"
        [ Graph.all
        ]
