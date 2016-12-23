module State exposing (init, update, subscriptions)

import Navigation exposing (Location)
import Routes
import Types exposing (Model)
import Messages exposing (Msg(..))
import Board.Graph as Graph
import Window
import Task


init : Location -> ( Model, Cmd Msg )
init location =
    ( Model (Routes.fromLocation location) { width = 400, height = 400, ratio = 1.0 } Graph.graph
    , Task.perform Resize Window.size
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        UrlChange location ->
            { model | route = Routes.fromLocation location } ! []

        NavigateTo url ->
            model ! [ Navigation.newUrl url ]

        Resize { width, height } ->
            let
                window =
                    { width = width
                    , height = height
                    , ratio = (toFloat width) / (toFloat height)
                    }
            in
                { model | window = window } ! []

        CaptureClick _ ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes Resize ]
