module Game.View exposing (view)

import Html exposing (..)
import Types exposing (Model)
import Messages exposing (Msg)
import Styles.Stylesheet as Stylesheet exposing (Class(..))


{ class, classList } =
    Stylesheet.stylesheet


view : Model -> Html Msg
view model =
    div [ class Content ]
        [ span [] [ text (toString model.route) ]
        ]
