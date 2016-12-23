module View.Elements exposing (link, icon, sidebar)

import Html exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (Msg(NavigateTo))
import Styles.Base exposing (colors)
import Styles.Stylesheet as Stylesheet exposing (Class(..))
import Color exposing (Color)
import FontAwesome as FA


{ class, classList } =
    Stylesheet.stylesheet



-- ELEMENTS CONFIG


iconSize : Int
iconSize =
    32



-- REUSABLE UI ELEMENTS


link : String -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
link url attributes nodes =
    a
        (attributes ++ [ onClick (NavigateTo url) ])
        nodes


sidebar : a -> Html msg
sidebar _ =
    aside [ class Sidebar ]
        [ icon FA.pencil colors.grey.medium
        , icon FA.plus_square_o colors.grey.dark
        , icon FA.cog colors.grey.dark
        ]


icon : (Color -> Int -> Html msg) -> Color -> Html msg
icon fa color =
    i [ class Icon ]
        [ fa color iconSize
        ]
