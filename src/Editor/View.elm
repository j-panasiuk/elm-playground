module Editor.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode
import Types exposing (Model, ScreenRect)
import Messages exposing (Msg(CaptureClick))
import Styles.Stylesheet as Stylesheet exposing (Class(..))
import Element
import View.Config as Config exposing (offset)
import Board.Canvas as Canvas
import Utils.Math as Math


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
        ( width, height ) =
            ( window.width - offset.width, window.height - offset.height )

        viewportRatio =
            Math.ratio width height

        boardRatio =
            Math.ratio graph.size.x graph.size.y

        boardSize =
            if viewportRatio > boardRatio then
                { width = Math.scale boardRatio height
                , height = height
                }
            else
                { width = width
                , height = Math.scale boardRatio width
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
