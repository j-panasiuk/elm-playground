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
            , onClick (SetEditorMode ShowMaze)
            ]
            [ FA.th (activeWhen (editor.mode == ShowMaze)) Config.iconSize ]
        , i
            [ class Icon
            , onClick (SetEditorMode ShowNodes)
            ]
            [ FA.cog (activeWhen (editor.mode == ShowNodes)) Config.iconSize ]
        , i
            [ class Icon
            , onClick (SetEditorMode ShowEdges)
            ]
            [ FA.diamond (activeWhen (editor.mode == ShowEdges)) Config.iconSize ]
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
viewBoard ({ board } as model) =
    div
        [ class BoardContainer
        , style
            [ ( "width", toString board.viewport.width ++ "px" )
            , ( "height", toString board.viewport.height ++ "px" )
            ]
        ]
        [ viewBoardCanvas board.viewport model
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
