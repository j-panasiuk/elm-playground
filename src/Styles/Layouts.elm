module Styles.Layouts exposing (..)

{-|
Html Elements that are conveneient for layout.
You can use these directly in your view function.
-}

import Style exposing (..)
import Html exposing (Html)


type Class
    = Centered
    | CenteredNoSpacing
    | CompletelyCentered
    | Split
    | FloatLeft
    | FloatRight
    | FloatTopLeft
    | FloatTopRight



-- STYLES


stylesheet : StyleSheet Class msg
stylesheet =
    Style.render
        [ class Centered
            [ Style.spacing (all 10)
            , Style.flowRight
                { wrap = True
                , horizontal = Style.alignCenter
                , vertical = Style.alignTop
                }
            ]
        , class CenteredNoSpacing
            [ Style.spacing (all 0)
            , Style.flowRight
                { wrap = True
                , horizontal = Style.alignCenter
                , vertical = Style.alignTop
                }
            ]
        , class CompletelyCentered
            [ Style.spacing (all 10)
            , Style.flowRight
                { wrap = True
                , horizontal = Style.alignCenter
                , vertical = Style.verticalCenter
                }
            ]
        , class Split
            [ Style.spacing (all 10)
            , Style.flowRight
                { wrap = False
                , horizontal =
                    Style.justify
                    -- this makes it so the children elements hug the sides.
                    -- Perfect for a nav with a right and left section
                , vertical = Style.verticalCenter
                }
            ]
        , class FloatLeft
            [ Style.floatLeft ]
        , class FloatRight
            [ Style.floatRight ]
        , class FloatTopLeft
            [ Style.floatTopLeft ]
        , class FloatTopRight
            [ Style.floatTopRight ]
        ]


centered : List (Html msg) -> Html msg
centered nodes =
    Html.div
        [ stylesheet.class Centered ]
        nodes


centeredNoSpacing : List (Html msg) -> Html msg
centeredNoSpacing nodes =
    Html.div
        [ stylesheet.class CenteredNoSpacing ]
        nodes


completelyCentered : List (Html msg) -> Html msg
completelyCentered nodes =
    Html.div
        [ stylesheet.class CompletelyCentered ]
        nodes


split : List (Html msg) -> Html msg
split nodes =
    Html.div
        [ stylesheet.class Split ]
        nodes


floatRight : List (Html msg) -> Html msg
floatRight nodes =
    Html.div
        [ stylesheet.class FloatRight ]
        nodes


floatLeft : List (Html msg) -> Html msg
floatLeft nodes =
    Html.div
        [ stylesheet.class FloatLeft ]
        nodes


floatTopLeft : List (Html msg) -> Html msg
floatTopLeft nodes =
    Html.div
        [ stylesheet.class FloatTopLeft ]
        nodes


floatTopRight : List (Html msg) -> Html msg
floatTopRight nodes =
    Html.div
        [ stylesheet.class FloatTopRight ]
        nodes
