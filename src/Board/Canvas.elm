module Board.Canvas exposing (render)

import Types exposing (Model, ScreenRect, GridSize, Graph, Layer(..))
import Element exposing (Element)
import Collage exposing (Form)
import Color exposing (Color)
import Styles.Base exposing (colors)
import Utils.Tuple
import Utils.Math as Math
import Board.Config as Config exposing (lineStyle)


render : ScreenRect -> List Layer -> Model -> Element
render viewport layers model =
    model
        |> draw viewport layers
        |> Collage.collage viewport.width viewport.height



-- CANVAS LAYERS


draw : ScreenRect -> List Layer -> Model -> List Form
draw viewport layers model =
    Config.layers
        |> List.filter (\l -> List.member l layers)
        |> List.map (\l -> drawLayer l viewport model)


drawLayer : Layer -> ScreenRect -> Model -> Form
drawLayer layer viewport { graph } =
    case layer of
        Background ->
            drawBackground viewport

        Maze ->
            drawMaze viewport graph

        Edges ->
            drawEdges viewport graph

        Nodes ->
            drawNodes viewport graph

        Grid ->
            drawGridBetweenTiles viewport graph



-- BACKGROUND


drawBackground : ScreenRect -> Form
drawBackground { width, height } =
    Collage.rect (toFloat width) (toFloat height)
        |> Collage.filled colors.grey.dark



-- GRID


drawGridBetweenTiles : ScreenRect -> Graph -> Form
drawGridBetweenTiles { width, height } { size } =
    [ List.range 1 (size.x - 1)
        |> List.map (toGridCoordinate width size.x)
        |> List.map (drawGridVerticalLine height)
    , List.range 1 (size.y - 1)
        |> List.map (toGridCoordinate height size.y)
        |> List.map (drawGridHorizontalLine width)
    ]
        |> List.concat
        |> Collage.group


drawGridAcrossTiles : ScreenRect -> Graph -> Form
drawGridAcrossTiles { width, height } { size } =
    [ List.range 0 (size.x - 1)
        |> List.map (toCoordinate width size.x)
        |> List.map (drawGridVerticalLine height)
    , List.range 0 (size.y - 1)
        |> List.map (toCoordinate height size.y)
        |> List.map (drawGridHorizontalLine width)
    ]
        |> List.concat
        |> Collage.group


drawGridVerticalLine : Int -> Float -> Form
drawGridVerticalLine height x =
    gridLine
        ( ( x, (toFloat -height) / 2 )
        , ( x, (toFloat height) / 2 )
        )


drawGridHorizontalLine : Int -> Float -> Form
drawGridHorizontalLine width y =
    gridLine
        ( ( (toFloat -width) / 2, y )
        , ( (toFloat width) / 2, y )
        )


gridLine : ( ( Float, Float ), ( Float, Float ) ) -> Form
gridLine =
    line colors.grey.light 2



-- MAZE


drawMaze : ScreenRect -> Graph -> Form
drawMaze viewport graph =
    [ drawLanes viewport graph
    , drawCells viewport graph
    ]
        |> Collage.group


drawCells : ScreenRect -> Graph -> Form
drawCells viewport { nodes, size } =
    nodes
        |> List.map (toCoordinates viewport size)
        |> List.map (drawCell (Math.ratio viewport.width size.x))
        |> Collage.group


drawCell : Float -> ( Float, Float ) -> Form
drawCell size coordinates =
    Collage.square (Config.cellRatio * size)
        |> Collage.filled colors.grey.darker
        |> Collage.move coordinates


drawLanes : ScreenRect -> Graph -> Form
drawLanes viewport { edges, size } =
    edges
        |> List.map (Utils.Tuple.map (toCoordinates viewport size))
        |> List.map (drawLane (Math.ratio viewport.width size.x))
        |> Collage.group


drawLane : Float -> ( ( Float, Float ), ( Float, Float ) ) -> Form
drawLane size coordinates =
    Collage.square (Config.laneRatio * size)
        |> Collage.filled colors.grey.darker
        |> Collage.move (Utils.Tuple.middle coordinates)



-- NODES


drawNodes : ScreenRect -> Graph -> Form
drawNodes viewport { nodes, size } =
    nodes
        |> List.map (toCoordinates viewport size)
        |> List.map (drawNode (Math.ratio viewport.width size.x))
        |> Collage.group


drawNode : Float -> ( Float, Float ) -> Form
drawNode size coordinates =
    drawMarker circle size coordinates



-- EDGES


drawEdges : ScreenRect -> Graph -> Form
drawEdges viewport { edges, size } =
    edges
        |> List.map (Utils.Tuple.map (toCoordinates viewport size))
        |> List.map (drawEdge (Math.ratio viewport.width size.x))
        |> Collage.group


drawEdge : Float -> ( ( Float, Float ), ( Float, Float ) ) -> Form
drawEdge size segment =
    [ drawConnection line size segment
    , drawMarker diamond size (Utils.Tuple.middle segment)
    ]
        |> Collage.group



-- SHAPES


{-| Draw marker of given shape (circle, diamond). Marker is hollow inside
-}
drawMarker :
    (Color -> Float -> ( Float, Float ) -> Form)
    -> Float
    -> ( Float, Float )
    -> Form
drawMarker shape size coordinate =
    [ shape colors.grey.dark (Config.markerRatio * size) coordinate
    , shape colors.grey.darker ((Config.markerRatio - Config.lineRatio) * size) coordinate
    ]
        |> Collage.group


circle : Color -> Float -> ( Float, Float ) -> Form
circle color diameter coordinates =
    Collage.circle (diameter / 2)
        |> Collage.filled color
        |> Collage.move coordinates


diamond : Color -> Float -> ( Float, Float ) -> Form
diamond color length coordinates =
    Collage.square length
        |> Collage.filled color
        |> Collage.move coordinates
        |> Collage.rotate (degrees 45)


{-| Draw connection between two points
-}
drawConnection :
    (Color -> Float -> ( ( Float, Float ), ( Float, Float ) ) -> Form)
    -> Float
    -> ( ( Float, Float ), ( Float, Float ) )
    -> Form
drawConnection shape size segment =
    shape colors.grey.dark (Config.lineRatio * size) segment


line : Color -> Float -> ( ( Float, Float ), ( Float, Float ) ) -> Form
line color width segment =
    Collage.segment (Tuple.first segment) (Tuple.second segment)
        |> Collage.traced
            { lineStyle
                | width = width
                , color = color
            }



-- HELPERS


toCoordinate : Int -> Int -> Int -> Float
toCoordinate size x i =
    (size // (2 * x)) * (2 * i - x + 1) |> toFloat


toCoordinates : ScreenRect -> GridSize -> ( Int, Int ) -> ( Float, Float )
toCoordinates { width, height } { x, y } ( i, j ) =
    ( (width // (2 * x)) * (2 * i - x + 1)
    , (height // (2 * y)) * (2 * j - y + 1)
    )
        |> Utils.Tuple.map toFloat


toGridCoordinate : Int -> Int -> Int -> Float
toGridCoordinate size x i =
    (-size // 2) + (i * size // x) |> toFloat
