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
            model ! []

        UrlChange location ->
            { model | route = Routes.fromLocation location } ! []

        NavigateTo url ->
            model ! [ Navigation.newUrl url ]

        Resize windowSize ->
            ( model
                |> (\m -> { m | window = windowSize })
                |> (\m -> { m | board = Board.resize (Overlay.shrinkBy { width = 140, height = 140 } windowSize) graph.size })
            , Cmd.none
            )

        SetEditorMode mode ->
            { model | editor = Editor.setMode mode editor } ! []

        ClickEditorBoard screenPoint ->
            { model | editor = Editor.select board.tileSize (Overlay.flipVertical board.viewport.height screenPoint) editor } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes Resize ]
