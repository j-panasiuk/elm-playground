module State exposing (init, update, subscriptions)

import Navigation exposing (Location)
import Window
import Task
import Routes
import Types exposing (..)
import Messages exposing (Msg(..))
import Board.Graph as Graph
import Board.Board as Board
import Board.Overlay as Overlay
import Game.State as Game
import Editor.State as Editor


-- INIT


init : Location -> ( Model, Cmd Msg )
init location =
    ( initialModel location
    , initialCommand
    )


initialModel : Location -> Model
initialModel location =
    { route = Routes.fromLocation location
    , window = initialWindow
    , graph = Graph.graph
    , board = Board.resize initialWindow (.size Graph.graph)
    , game = Game.initialState
    , editor = Editor.initialState
    }


initialCommand : Cmd Msg
initialCommand =
    Task.perform Resize Window.size


initialWindow : ScreenRect
initialWindow =
    { width = 400, height = 400 }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ graph, board, editor } as model) =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        UrlChange location ->
            ( { model | route = Routes.fromLocation location }
            , Cmd.none
            )

        NavigateTo url ->
            ( model
            , Navigation.newUrl url
            )

        Resize windowSize ->
            let
                updatedBoard =
                    graph.size |> Board.resize (Overlay.shrinkBy offset windowSize)

                offset =
                    { width = 140, height = 140 }
            in
                ( { model
                    | window = windowSize
                    , board = updatedBoard
                  }
                , Cmd.none
                )

        SetEditorMode mode ->
            ( { model | editor = Editor.setMode mode editor }
            , Cmd.none
            )

        ClickEditorBoard clickPoint ->
            let
                updatedEditor =
                    editor |> Editor.select model.graph board.tileSize translatedPoint

                translatedPoint =
                    clickPoint |> Overlay.flipVertical board.viewport.height
            in
                ( { model | editor = updatedEditor }
                , Cmd.none
                )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes Resize ]
