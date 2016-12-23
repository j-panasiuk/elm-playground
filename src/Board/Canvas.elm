module Board.Canvas exposing (render)

import Types exposing (Model, ScreenRect, GridSize, Graph)
import Element exposing (Element)
import Collage exposing (Form)
import Styles.Base exposing (colors)
import Utils.Tuple


render : ScreenRect -> Model -> Element
render viewport model =
    model
        |> drawBoard viewport
        |> Collage.collage viewport.width viewport.height


drawBoard : ScreenRect -> Model -> List Form
drawBoard viewport model =
    [ drawBackground viewport
    , drawGraph viewport model
    ]


drawBackground : ScreenRect -> Form
drawBackground { width, height } =
    Collage.rect (toFloat width) (toFloat height)
        |> Collage.filled colors.grey.dark


drawGraph : ScreenRect -> Model -> Form
drawGraph viewport { graph } =
    [ drawTiles viewport graph
    ]
        |> Collage.group


drawTiles : ScreenRect -> Graph -> Form
drawTiles viewport { nodes, size } =
    nodes
        |> List.map (toCoordinate viewport size)
        |> List.map (drawTile 40)
        |> Collage.group


drawTile : Int -> ( Float, Float ) -> Form
drawTile size ( x, y ) =
    Collage.square (0.8 * (toFloat size))
        |> Collage.filled colors.grey.darker
        |> Collage.move ( x, y )



-- HELPERS


toCoordinate : ScreenRect -> GridSize -> ( Int, Int ) -> ( Float, Float )
toCoordinate { width, height } { x, y } ( i, j ) =
    ( (width // (2 * x)) * (2 * i - x + 1)
    , (height // (2 * y)) * (2 * j - y + 1)
    )
        |> Utils.Tuple.map toFloat
