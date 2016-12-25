module Game.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (style)
import Types exposing (Model)
import Messages exposing (Msg)
import Styles.Stylesheet as Stylesheet exposing (Class(..))


{ class, classList } =
    Stylesheet.stylesheet


view : Model -> Html Msg
view model =
    div
        [ class Content
        , style [ ( "min-height", "100vh" ) ]
        ]
        [ span [] [ text (toString model.route) ]
        ]
