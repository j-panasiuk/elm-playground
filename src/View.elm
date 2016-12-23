module View exposing (view)

import Html exposing (..)
import Routes
import Types exposing (Model)
import Messages exposing (Msg)
import Style
import Styles.Base as Base exposing (colors)
import Styles.Layouts as Layouts
import Styles.Stylesheet as Stylesheet exposing (Class(..))
import View.Elements as Elements
import Game.View
import Editor.View
import FontAwesome as FA


{ class, classList } =
    Stylesheet.stylesheet


view : Model -> Html Msg
view model =
    div
        [ class Main ]
        [ Style.embed Layouts.stylesheet
        , Style.embed Stylesheet.stylesheet
        , viewTopNav model
        , viewPage model
        ]


viewTopNav : Model -> Html Msg
viewTopNav model =
    nav [ class Nav ]
        [ Layouts.centeredNoSpacing
            [ Elements.link "" [] [ Elements.icon FA.home colors.grey.dark ]
            , Elements.link "game" [ class Link ] [ text "Game" ]
            , Elements.link "editor" [ class Link ] [ text "Editor" ]
            ]
        , Layouts.centeredNoSpacing
            [ Elements.link "settings" [ class Link ] [ text "Settings" ]
            , Elements.link "about" [ class Link ] [ text "About" ]
            ]
        ]


viewPage : Model -> Html Msg
viewPage model =
    div [ class Container ]
        (case model.route of
            Just (Routes.Game) ->
                [ Game.View.view model
                ]

            Just (Routes.Editor) ->
                [ Elements.sidebar model
                , Editor.View.view model
                ]

            Nothing ->
                []
        )
