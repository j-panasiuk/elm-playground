module Board.Levels exposing (levels, loadLevel)

import Types exposing (Level, Position)
import List.Extra


loadLevel : Int -> Level
loadLevel id =
    levels
        |> List.Extra.find (.id >> (==) id)
        |> Maybe.withDefault (Level 0 [])


levels : List Level
levels =
    [ level1, level2, level3 ]



-- LEVELS


level1 : Level
level1 =
    { id = 1
    , edges = parseEdges level1Shape
    }


level1Shape : String
level1Shape =
    """
│ │
├┬┼┐
└┤└┤
─┴─┘
"""


level2 : Level
level2 =
    { id = 2
    , edges = parseEdges level2Shape
    }


level2Shape : String
level2Shape =
    """
┌──┬───┐
│  │   │
├─┬┴─┼─┤
│    │ │
│  └─┼ │
└────┴─┘
"""


level3 : Level
level3 =
    { id = 3
    , edges = parseEdges level3Shape
    }


level3Shape : String
level3Shape =
    """
    ┌───┬──┐
┌──┴┤   │  │
├┬─ ┼┼  ┼─┘│
│└┐  ┤    ┌┘
│ └──┼┴─┬─┴┤
├─┴┬    ┤  │
├──┬┌───┤┌─┤
│──┼┘ ┼─┬┘ │
│  ───┘ ├┬─┘
└───────┴┘
"""



-- HELPERS


{-| Graph connections are bi-directional, so when building the graph from
string representation we only need to check connections in one direction.

So starting from bottom left corner (0, 0) we look for connections going
up and/or right
-}
type Direction
    = Up
    | Right


{-| Get list of edges based on level map
-}
parseEdges : String -> List ( Position, Position )
parseEdges shape =
    let
        lines =
            levelLines shape

        chars =
            levelLineChars lines

        edges line cs =
            cs
                |> List.indexedMap (newEdgesFromNode line)
                |> List.concat
                |> List.filter
                    (\( ( x1, y1 ), ( x2, y2 ) ) ->
                        ( x1, y1 ) /= ( x2, y2 ) && x2 < levelWidth && y2 < levelHeight
                    )

        ( levelWidth, levelHeight ) =
            levelSize lines
    in
        chars
            |> List.indexedMap edges
            |> List.concat


{-| Calculate level dimensions to trim outer edges
-}
levelSize : List String -> ( Int, Int )
levelSize lines =
    ( lines |> List.map String.length |> List.maximum |> Maybe.withDefault 0
    , lines |> List.length
    )


{-| Split level map into lines
-}
levelLines : String -> List String
levelLines shape =
    shape
        |> String.lines
        |> List.filter (not << String.isEmpty)
        |> List.reverse


{-| Split level map lines into single characters
-}
levelLineChars : List String -> List (List Char)
levelLineChars lines =
    lines
        |> List.map String.toList


{-| Get new edges coming out of given point
Outgoing edges are encoded in shape of the character
We only care about edges going up or right
-}
newEdgesFromNode : Int -> Int -> Char -> List ( Position, Position )
newEdgesFromNode line index char =
    let
        newEdgeTowards direction =
            (,) ( index, line ) <|
                case direction of
                    Up ->
                        ( index, line + 1 )

                    Right ->
                        ( index + 1, line )
    in
        List.map newEdgeTowards <|
            case char of
                ' ' ->
                    []

                '│' ->
                    [ Up ]

                '─' ->
                    [ Right ]

                '┐' ->
                    []

                '┌' ->
                    [ Right ]

                '┘' ->
                    [ Up ]

                '└' ->
                    [ Up, Right ]

                '┬' ->
                    [ Right ]

                '┤' ->
                    [ Up ]

                '├' ->
                    [ Up, Right ]

                '┴' ->
                    [ Up, Right ]

                '┼' ->
                    [ Up, Right ]

                _ ->
                    []
