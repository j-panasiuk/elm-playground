module Styles.Stylesheet exposing (Class(..), stylesheet)

import Style exposing (..)
import Styles.Base exposing (common, colors, palette)


type Class
    = Main
    | Container
    | Nav
    | Sidebar
    | Content
    | BoardContainer
    | BoardCanvas
    | BoardOverlay
    | Link
    | Icon


stylesheet : StyleSheet Class msg
stylesheet =
    Style.renderWith
        [ Style.debug
        , Style.base common
        ]
        [ class Main
            [ height (percent 100)
            , backgroundColor colors.black
            ]
        , class Nav
            [ palette.nav
            , width (percent 100)
            , height (px 60)
            , positionBy screen
            , topLeft 0 0
            , zIndex 11
            , minWidth (px 1000)
            , flowRight
                { wrap = False
                , horizontal =
                    justify
                    -- this makes it so the children elements hug the sides.
                    -- Perfect for a nav with a right and left section
                , vertical = verticalCenter
                }
            ]
        , class Container
            [ height (percent 100)
            ]
        , class Sidebar
            [ palette.sidebar
            , positionBy screen
            , height (percent 100)
            , topLeft 0 0
            , width (px 60)
            , padding (top 70)
            , zIndex 10
            , flowDown
                { wrap = True
                , horizontal = alignCenter
                , vertical = alignTop
                }
            ]
        , class Content
            [ height (percent 100)
            , flowDown
                { wrap = False
                , horizontal = alignCenter
                , vertical = verticalCenter
                }
            ]
        , class BoardContainer
            [ flowDown
                { wrap = False
                , horizontal = alignCenter
                , vertical = verticalCenter
                }
            ]
        , class BoardCanvas
            [ positionBy parent
            , backgroundColor colors.blue.dark
            ]
        , class BoardOverlay
            [ width (percent 100)
            , height (percent 100)
            , positionBy parent
            , zIndex 1
            ]
        , class Link
            [ height (px 60)
            , padding (leftRight 25)
            , border
                { width = left 1
                , style = solid
                , color = colors.grey.darkest
                }
            , flowRight
                { wrap = False
                , horizontal = alignCenter
                , vertical = verticalCenter
                }
            , bold
            , textColor colors.grey.light
            , cursor "pointer"
            , hover
                [ textColor colors.blue.light
                , backgroundColor colors.grey.dark
                ]
            ]
        , class Icon
            [ width (px 60)
            , height (px 60)
            , flowDown
                { wrap = False
                , horizontal = alignCenter
                , vertical = verticalCenter
                }
            , cursor "pointer"
            , hover
                [ textColor colors.blue.light
                , backgroundColor colors.grey.darker
                ]
            ]
        ]
