module Board.Canvas exposing (init, render)

import Types exposing (..)
import Element exposing (Element)
import Collage exposing (Form)
import Color exposing (Color)
import Styles.Base exposing (colors)
import Utils.Tuple
import Utils.Math as Math
import Board.Config as Config exposing (lineStyle)
import Board.Selection as Selection


-- INIT


init : EditorMode -> Canvas
init mode =
    { layers = layers mode
    }


layers : EditorMode -> List Layer
layers mode =
    case mode of
        ShowMaze ->
            [ BackgroundLayer
            , MazeLayer
            , GridLayer
            ]

        ShowNodes ->
            [ BackgroundLayer
            , MazeLayer
            , NodeLayer
            , SelectionLayer
            ]

        ShowEdges ->
            [ BackgroundLayer
            , MazeLayer
            , EdgeLayer
            , SelectionLayer
            ]

        ShowPath ->
            [ BackgroundLayer
            , MazeLayer
            , NodeLayer
            , EdgeLayer
            , SelectionLayer
            ]



-- VIEW


render : ScreenRect -> Canvas -> Model -> Element
render viewport { layers } model =
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
drawLayer layer viewport { graph, editor } =
    case layer of
        BackgroundLayer ->
            drawBackground viewport

        MazeLayer ->
            drawMaze viewport graph

        EdgeLayer ->
            drawEdges viewport graph graph.edges

        NodeLayer ->
            drawNodes viewport graph graph.nodes

        GridLayer ->
            drawGridBetweenTiles viewport graph

        SelectionLayer ->
            drawSelection viewport graph editor



-- BACKGROUND


drawBackground : ScreenRect -> Form
drawBackground { width, height } =
    Collage.rect (toFloat width) (toFloat height)
        |> Collage.filled colors.grey.dark



-- GRID


drawGridBetweenTiles : ScreenRect -> Graph -> Form
drawGridBetweenTiles { width, height } { size } =
    [ List.range 1 (size.cols - 1)
        |> List.map (toGridCoordinate width size.cols)
        |> List.map (drawGridVerticalLine height)
    , List.range 1 (size.rows - 1)
        |> List.map (toGridCoordinate height size.rows)
        |> List.map (drawGridHorizontalLine width)
    ]
        |> List.concat
        |> Collage.group


drawGridAcrossTiles : ScreenRect -> Graph -> Form
drawGridAcrossTiles { width, height } { size } =
    [ List.range 0 (size.cols - 1)
        |> List.map (toCoordinate width size.cols)
        |> List.map (drawGridVerticalLine height)
    , List.range 0 (size.rows - 1)
        |> List.map (toCoordinate height size.rows)
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
    [ drawLanes viewport graph graph.edges
    , drawCells viewport graph graph.nodes
    ]
        |> Collage.group


drawCells : ScreenRect -> Graph -> List Position -> Form
drawCells =
    drawAtNodes drawCell


drawCell : Float -> ( Float, Float ) -> Form
drawCell size coordinates =
    Collage.square (Config.cellRatio * size)
        |> Collage.filled colors.grey.darker
        |> Collage.move coordinates


drawLanes : ScreenRect -> Graph -> List ( Position, Position ) -> Form
drawLanes =
    drawAtEdges drawLane


drawLane : Float -> ( ( Float, Float ), ( Float, Float ) ) -> Form
drawLane size coordinates =
    Collage.square (Config.laneRatio * size)
        |> Collage.filled colors.grey.darker
        |> Collage.move (Utils.Tuple.middle coordinates)



-- NODES


drawAtNodes :
    (Float -> ( Float, Float ) -> Form)
    -> ScreenRect
    -> Graph
    -> List Position
    -> Form
drawAtNodes drawShape viewport { size } nodes =
    nodes
        |> List.map (toCoordinates viewport size)
        |> List.map (drawShape (Math.ratio viewport.width size.cols))
        |> Collage.group


drawNodes : ScreenRect -> Graph -> List Position -> Form
drawNodes =
    drawAtNodes drawNode


drawNode : Float -> ( Float, Float ) -> Form
drawNode size coordinates =
    drawMarker circle size coordinates



-- EDGES


drawAtEdges :
    (Float -> ( ( Float, Float ), ( Float, Float ) ) -> Form)
    -> ScreenRect
    -> Graph
    -> List ( Position, Position )
    -> Form
drawAtEdges drawShape viewport { size } edges =
    edges
        |> List.map (Utils.Tuple.map (toCoordinates viewport size))
        |> List.map (drawShape (Math.ratio viewport.width size.cols))
        |> Collage.group


drawEdges : ScreenRect -> Graph -> List ( Position, Position ) -> Form
drawEdges =
    drawAtEdges drawEdge


drawEdge : Float -> ( ( Float, Float ), ( Float, Float ) ) -> Form
drawEdge size segment =
    [ drawConnection line size segment
    , drawMarker diamond size (Utils.Tuple.middle segment)
    ]
        |> Collage.group



-- SELECTION


drawSelection : ScreenRect -> Graph -> Editor -> Form
drawSelection viewport graph { selection, pathEdges } =
    case ( selection, pathEdges ) of
        ( NothingToSelect, _ ) ->
            Element.empty |> Collage.toForm

        ( NodeSelection _ selectedNodes, Just edges ) ->
            [ drawSelectedNodes viewport graph (Selection.toList selectedNodes)
            , drawPath viewport graph edges
            ]
                |> Collage.group

        ( NodeSelection _ selectedNodes, Nothing ) ->
            drawSelectedNodes viewport graph (Selection.toList selectedNodes)

        ( EdgeSelection _ selectedEdges, _ ) ->
            drawSelectedEdges viewport graph (Selection.toList selectedEdges)


drawSelectedNodes : ScreenRect -> Graph -> List Position -> Form
drawSelectedNodes =
    drawAtNodes drawSelectedNode


drawSelectedNode : Float -> ( Float, Float ) -> Form
drawSelectedNode size coordinates =
    circle colors.orange (Config.markerRatio * size) coordinates


drawSelectedEdges : ScreenRect -> Graph -> List ( Position, Position ) -> Form
drawSelectedEdges =
    drawAtEdges drawSelectedEdge


drawSelectedEdge : Float -> ( ( Float, Float ), ( Float, Float ) ) -> Form
drawSelectedEdge size segment =
    [ line colors.orange (Config.lineRatio * size) segment
    , diamond colors.orange (Config.markerRatio * size) (Utils.Tuple.middle segment)
    ]
        |> Collage.group


drawPath : ScreenRect -> Graph -> List ( Position, Position ) -> Form
drawPath viewport graph edges =
    drawSelectedEdges viewport graph edges



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
toCoordinates { width, height } { cols, rows } ( i, j ) =
    ( (width // (2 * cols)) * (2 * i - cols + 1)
    , (height // (2 * rows)) * (2 * j - rows + 1)
    )
        |> Utils.Tuple.map toFloat


toGridCoordinate : Int -> Int -> Int -> Float
toGridCoordinate size x i =
    (-size // 2) + (i * size // x) |> toFloat
