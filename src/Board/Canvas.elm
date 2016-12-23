module Board.Canvas exposing (render)

import Html exposing (..)
import Types exposing (Model, ScreenRect)
import Messages exposing (Msg)
import Element exposing (Element)
import Collage exposing (Form)
import Board.Graph as Graph


render : ScreenRect -> Model -> Element
render { width, height } model =
    model
        |> drawBoard width height
        |> Collage.collage width height


{-| TODO implement
-}
drawBoard : Int -> Int -> Model -> List Form
drawBoard _ _ _ =
    []
