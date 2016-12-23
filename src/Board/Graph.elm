module Board.Graph
    exposing
        ( graph
        , size
        , ratio
        , nodes
        , edges
        , neighbors
        , findPath
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
    Levels.level1


graph : Graph
graph =
    { nodes = nodes
    , edges = edges
    , neighbors = neighbors
    , size = size
    , ratio = ratio
    }


size : GridSize
size =
    { x = nodes |> measureDimension first
    , y = nodes |> measureDimension second
    }


ratio : Float
ratio =
    (toFloat size.x) / (toFloat size.y)


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


isNode : Position -> Bool
isNode position =
    List.member position nodes


isEdge : ( Position, Position ) -> Bool
isEdge pair =
    List.member pair edges
