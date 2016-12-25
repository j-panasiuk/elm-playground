module State exposing (init, update, subscriptions)

import Navigation exposing (Location)
import Window
import Task
import Routes
import Types exposing (Model)
import Messages exposing (Msg(..))
import Board.Graph as Graph
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
    , window = { width = 400, height = 400 }
    , graph = Graph.graph
    , editor = Editor.initialState
    }


initialCommand : Cmd Msg
initialCommand =
    Task.perform Resize Window.size



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        UrlChange location ->
            { model | route = Routes.fromLocation location } ! []

        NavigateTo url ->
            model ! [ Navigation.newUrl url ]

        Resize windowSize ->
            { model | window = windowSize } ! []

        CaptureClick _ ->
            model ! []

        SetEditorMode mode ->
            { model | editor = Editor.setMode mode model.editor } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes Resize ]
