module Spec.Graph exposing (all)

import Test exposing (..)
import Expect
import Fuzz exposing (Fuzzer)
import Utils.Fuzzers
import Random.Pcg as Random exposing (Generator)
import Shrink exposing (Shrinker)
import Dict
import Set
import List.Extra
import Utils.Tuple
import Types exposing (ScreenRect)
import Board.Graph as Graph


all : Test
all =
    describe "Graph"
        [ describe "size" size
        , describe "nodes" nodes
        , describe "edges" edges
        , describe "neighbors" neighbors
        , describe "findPath" findPath
        , describe "isNode" isNode
        , describe "isEdge" isEdge
        ]


size : List Test
size =
    [ test "horizontal" <|
        \() ->
            Expect.atLeast 2 (.x Graph.size)
      ----
    , test "vertical" <|
        \() ->
            Expect.atLeast 2 (.y Graph.size)
    ]


nodes : List Test
nodes =
    [ test "should have at least one node" <|
        \() ->
            Expect.atLeast 1 (List.length Graph.nodes)
      ----
    , test "should have non-negative values" <|
        \() ->
            let
                allNonNegative =
                    Graph.nodes
                        |> List.all (Utils.Tuple.both (\x -> x >= 0))
            in
                Expect.true "Unexpected negative value!" allNonNegative
    ]


edges : List Test
edges =
    [ test "should have at least one edge" <|
        \() ->
            Expect.atLeast 1 (List.length Graph.edges)
      ----
    , test "should only consist of adjacent nodes" <|
        \() ->
            Expect.equalLists
                (Graph.edges |> List.map taxiDistance)
                (Graph.edges |> List.map (always 1))
      ----
    , test "should contain all graph nodes and graph nodes only" <|
        \() ->
            let
                collectNodes ( from, to ) nodes =
                    List.append nodes [ from, to ]
                        |> List.Extra.unique

                edges =
                    Graph.edges
                        |> List.foldl collectNodes []
                        |> List.sort
            in
                Expect.equalLists edges Graph.nodes
    ]


neighbors : List Test
neighbors =
    [ test "should be of same size as node list" <|
        \() ->
            Expect.equal
                (Graph.neighbors |> Dict.size)
                (Graph.nodes |> List.length)
      ----
    , test "should have a set of neighbors for every node" <|
        \() ->
            let
                hasNeighborSet node =
                    Dict.member node Graph.neighbors

                eachNodeHasNeighborSet =
                    List.all hasNeighborSet Graph.nodes
            in
                Expect.true "Expected node to have its set of neighbors!" eachNodeHasNeighborSet
      ----
    , test "should have at least one neighbor for every node" <|
        \() ->
            let
                hasNeighbors node =
                    Dict.get node Graph.neighbors
                        |> Maybe.withDefault Set.empty
                        |> (not << Set.isEmpty)

                eachNodeHasNeighbors =
                    List.all hasNeighbors Graph.nodes
            in
                Expect.true "Expected node to have at least one neighbor!" eachNodeHasNeighbors
      ----
    , fuzz position "should be symmetrical for every position pair" <|
        \origin ->
            let
                potentialNeighbors =
                    adjacent origin

                isNeighbor from to =
                    Dict.get from Graph.neighbors
                        |> Maybe.withDefault Set.empty
                        |> Set.member to
            in
                Expect.equalLists
                    (List.map (\candidate -> isNeighbor origin candidate) potentialNeighbors)
                    (List.map (\candidate -> isNeighbor candidate origin) potentialNeighbors)
    ]


findPath : List Test
findPath =
    [ fuzz edge "should find path between neighbor nodes" <|
        \( from, to ) ->
            Graph.findPath from to
                |> Maybe.withDefault []
                |> Expect.equalLists [ to ]
      ----
    , fuzz2 node node "should find path between distant nodes" <|
        \from to ->
            let
                distance =
                    if taxiDistance ( from, to ) > 1 then
                        Graph.findPath from to
                    else
                        Nothing

                isValid =
                    case distance of
                        Nothing ->
                            True

                        Just path ->
                            List.length path > 1
            in
                Expect.true "Expected at least 2 distance between nodes" isValid
      ----
    , fuzz node "should find empty path between position and itself" <|
        \origin ->
            Graph.findPath origin origin
                |> Expect.equal (Just [])
      ----
    , fuzz node "should find no path to position outside of graph" <|
        \origin ->
            Graph.findPath origin ( -1, 0 )
                |> Expect.equal Nothing
      ----
    , fuzz2 node node "should find paths of equal length in both directions" <|
        \from to ->
            let
                dropLastElement =
                    Maybe.withDefault [] >> List.reverse >> List.drop 1

                forward =
                    Graph.findPath from to
                        |> dropLastElement
                        |> List.reverse

                backward =
                    Graph.findPath to from
                        |> dropLastElement
            in
                Expect.equal (List.length forward) (List.length backward)
      ----
    , test "should find path between any two (different) graph nodes" <|
        \() ->
            let
                isConnectedToEveryOtherNode ( node, others ) =
                    others
                        |> List.all (\other -> Graph.findPath node other /= Nothing)

                isConnectedGraph =
                    Graph.nodes
                        |> List.Extra.select
                        |> List.all isConnectedToEveryOtherNode
            in
                Expect.true "Expected nodes and edges to form connected graph!" isConnectedGraph
    ]


isNode : List Test
isNode =
    [ test "should return true given graph node" <|
        \() ->
            Expect.true "Expected node to return true!" (Graph.nodes |> List.all Graph.isNode)
      ----
    , test "should return false given position outside of graph" <|
        \() ->
            Expect.false "Expected outside position to return false!" (Graph.isNode ( -1, 0 ))
    ]


isEdge : List Test
isEdge =
    [ test "should return true given graph edge" <|
        \() ->
            Expect.true "Expected edge to return true!" (Graph.edges |> List.all Graph.isEdge)
      ----
    , test "should return false given position outside of graph" <|
        \() ->
            Expect.false "Expected outside position to return false!" (Graph.isEdge ( ( -1, 0 ), ( 0, 0 ) ))
      ----
    , fuzz node "should return false given same position twice" <|
        \origin ->
            Expect.false "Expected outside position to return false!" (Graph.isEdge ( origin, origin ))
      ----
    , fuzz edge "should return false given reversed graph edge" <|
        \( from, to ) ->
            Expect.false
                """Expected reversed graph edge to return false (edges are always bidirectional,
                so we only store one copy (a, b); reversed value (b, a) is not counted as an edge)."""
                (Graph.isEdge ( to, from ))
    ]



-- HELPERS


adjacent : ( Int, Int ) -> List ( Int, Int )
adjacent ( i, j ) =
    [ ( i - 1, j ), ( i, j - 1 ), ( i, j + 1 ), ( i + 1, j ) ]


taxiDistance : ( ( Int, Int ), ( Int, Int ) ) -> Int
taxiDistance ( ( ax, ay ), ( bx, by ) ) =
    abs (ax - bx) + abs (ay - by)
