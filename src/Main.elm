module Main exposing (..)

import Navigation
import Types exposing (Model)
import Messages exposing (Msg(UrlChange))
import State
import View


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.view
        }
