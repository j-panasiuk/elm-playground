module Editor.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (on, onClick)
import Json.Decode
import Types exposing (..)
import Messages exposing (Msg(..))
import Styles.Base exposing (colors)
import Styles.Stylesheet as Stylesheet exposing (Class(..))
import Color exposing (Color)
import Element
import FontAwesome as FA
import View.Config as Config exposing (offset)
import Board.Canvas as Canvas
import Board.Overlay as Overlay


{ class, classList } =
    Stylesheet.stylesheet


view : Model -> List (Html Msg)
view model =
    [ viewSidebar model
    , viewContent model
    ]


viewSidebar : Model -> Html Msg
viewSidebar { editor } =
    aside [ class Sidebar ]
        [ i
            [ class Icon
            , onClick (SetEditorMode CreateMaze)
            ]
            [ FA.th (activeWhen (editor.mode == CreateMaze)) Config.iconSize ]
        , i
            [ class Icon
            , onClick (SetEditorMode SelectNodes)
            ]
            [ FA.cog (activeWhen (editor.mode == SelectNodes)) Config.iconSize ]
        , i
            [ class Icon
            , onClick (SetEditorMode SelectEdges)
            ]
            [ FA.diamond (activeWhen (editor.mode == SelectEdges)) Config.iconSize ]
        ]


viewContent : Model -> Html Msg
viewContent model =
    div
        [ class Content
        , style [ ( "min-height", "100vh" ) ]
        ]
        [ viewBoard model
        ]


viewBoard : Model -> Html Msg
viewBoard ({ window, graph } as model) =
    let
        boardSize =
            Overlay.size window offset graph
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
            |> Canvas.render boardSize model.editor.canvas
            |> Element.toHtml
        ]


viewBoardOverlay : Model -> Html Msg
viewBoardOverlay model =
    div
        [ class BoardOverlay
        , on "click" (Json.Decode.map ClickEditorBoard Types.screenPoint)
        ]
        []



-- HELPERS


activeWhen : Bool -> Color
activeWhen active =
    if active then
        colors.grey.medium
    else
        colors.grey.dark
