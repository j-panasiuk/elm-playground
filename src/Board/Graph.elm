module Board.Graph
    exposing
        ( graph
        , size
        , nodes
        , edges
        , neighbors
        , findPath
        , findPathEdges
        , isNode
        , isEdge
        )

import Dict exposing (Dict)
import Set exposing (Set)
import Tuple exposing (first, second)
import List.Extra
import AStar
import Types exposing (Position, Path, GridSize, Level, Graph)
import Board.Levels as Levels
import Utils.Tuple


level : Level
level =
    Levels.loadLevel 3


graph : Graph
graph =
    { nodes = nodes
    , edges = edges
    , neighbors = neighbors
    , size = size
    }


size : GridSize
size =
    { cols = nodes |> measureDimension first
    , rows = nodes |> measureDimension second
    }


measureDimension : (( Int, Int ) -> Int) -> List ( Int, Int ) -> Int
measureDimension pickDimension positions =
    positions
        |> List.map pickDimension
        |> List.maximum
        |> Maybe.withDefault 0
        |> (+) 1


nodes : List Position
nodes =
    level.edges
        |> List.foldl collectNodes []
        |> List.sort


collectNodes : ( Position, Position ) -> List Position -> List Position
collectNodes ( from, to ) nodes =
    List.append nodes [ from, to ]
        |> List.Extra.unique


edges : List ( Position, Position )
edges =
    level.edges
        |> List.Extra.unique
        |> List.sort


neighbors : Dict Position (Set Position)
neighbors =
    edges
        |> List.Extra.interweave (List.map Utils.Tuple.flip edges)
        |> List.sort
        |> List.Extra.groupWhile (\a b -> first a == first b)
        |> List.map collectNeighbors
        |> Dict.fromList


collectNeighbors : List ( Position, Position ) -> ( Position, Set Position )
collectNeighbors connections =
    let
        from =
            connections
                |> List.head
                |> Maybe.map first
                |> Maybe.withDefault ( 0, 0 )

        neighbors =
            connections
                |> List.map second
                |> Set.fromList
    in
        ( from, neighbors )


costFunction : Position -> Position -> Float
costFunction =
    AStar.straightLineCost


moveFunction : Position -> Set Position
moveFunction position =
    case Dict.get position neighbors of
        Just positions ->
            positions

        Nothing ->
            Set.empty


findPath : Position -> Position -> Maybe Path
findPath =
    AStar.findPath costFunction moveFunction


findPathEdges : Position -> Position -> Maybe (List ( Position, Position ))
findPathEdges origin destination =
    findPath origin destination
        |> Maybe.map ((::) origin)
        |> Maybe.map collectEdges


isNode : Position -> Bool
isNode position =
    List.member position nodes


isEdge : ( Position, Position ) -> Bool
isEdge pair =
    List.member pair edges


collectEdges : List Position -> List ( Position, Position )
collectEdges path =
    path
        |> List.Extra.zip (List.drop 1 path)
        |> List.map Utils.Tuple.sort
