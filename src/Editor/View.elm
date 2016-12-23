module Editor.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode
import Types exposing (Model, ScreenRect)
import Messages exposing (Msg(CaptureClick))
import Styles.Stylesheet as Stylesheet exposing (Class(..))
import Element
import Board.Graph as Graph
import Board.Canvas as Canvas


{ class, classList } =
    Stylesheet.stylesheet


view : Model -> Html Msg
view model =
    div [ class Content ]
        [ viewBoard model
        ]


viewBoard : Model -> Html Msg
viewBoard ({ window, graph } as model) =
    let
        viewportRatio =
            window.ratio

        boardRatio =
            graph.ratio

        boardSize =
            if viewportRatio > boardRatio then
                { width = 300
                , height = window.height - 150
                , ratio = boardRatio
                }
            else
                { width = window.width - 150
                , height = 300
                , ratio = boardRatio
                }
    in
        div
            [ class BoardContainer
            , style
                [ ( "width", toString boardSize.width ++ "px" )
                , ( "height", toString boardSize.height ++ "px" )
                ]
            ]
            [ viewBoardCanvas boardSize model
            , viewBoardOverlay model
            ]


viewBoardCanvas : ScreenRect -> Model -> Html Msg
viewBoardCanvas boardSize model =
    div [ class BoardCanvas ]
        [ model
            |> Canvas.render boardSize
            |> Element.toHtml
        ]


viewBoardOverlay : Model -> Html Msg
viewBoardOverlay model =
    div
        [ class BoardOverlay
        , on "click" (Json.Decode.map CaptureClick Types.screenPoint)
        ]
        []
