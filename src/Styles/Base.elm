module Styles.Base exposing (common, palette, colors, fonts)

import Style exposing (..)
import Color exposing (Color)
import Color.Mixing


-- BASE STYLES


common : List Property
common =
    Style.foundation
        ++ [ palette.standard
           , fonts.normal
           , transition
                { property = "all"
                , duration = 270
                , easing = "ease-out"
                , delay = 0
                }
           ]



-- PALETTE


palette : { standard : Property, nav : Property, sidebar : Property }
palette =
    { standard =
        Style.mix
            [ backgroundColor colors.transparent
            , textColor colors.grey.light
            , borderColor colors.grey.light
            ]
    , nav =
        Style.mix
            [ borderColor colors.grey.light
            , backgroundColor colors.grey.darker
            , textColor colors.grey.light
            ]
    , sidebar =
        Style.mix
            [ borderColor colors.grey.light
            , backgroundColor colors.grey.darkest
            , textColor colors.grey.light
            ]
    }



-- COLORS


type alias Colors3 =
    { dark : Color
    , normal : Color
    , light : Color
    }


type alias Colors7 =
    { darkest : Color
    , darker : Color
    , dark : Color
    , medium : Color
    , light : Color
    , lighter : Color
    , lightest : Color
    }


colors : { white : Color, black : Color, transparent : Color, grey : Colors7, blue : Colors3, red : Colors3, orange : Color }
colors =
    { white = Color.white
    , black = Color.rgb 10 10 10
    , transparent = Color.rgba 255 255 255 0
    , grey =
        { darkest = Color.rgb 18 18 18
        , darker = Color.rgb 36 36 36
        , dark = Color.rgb 72 72 72
        , medium = Color.rgb 108 108 108
        , light = Color.rgb 160 160 160
        , lighter = Color.rgb 208 208 208
        , lightest = Color.rgb 245 245 245
        }
    , blue =
        { dark = Color.Mixing.darken 0.1 (Color.rgb 12 148 200)
        , normal = Color.rgb 12 148 200
        , light = Color.Mixing.lighten 0.1 (Color.rgb 12 148 200)
        }
    , red =
        { dark = Color.Mixing.darken 0.1 Color.red
        , normal = Color.red
        , light = Color.Mixing.lighten 0.1 Color.red
        }
    , orange = Color.orange
    }



-- FONTS


fonts : { normal : Property, large : Property }
fonts =
    { normal =
        Style.mix
            [ font "'Noto Sans', Georgia"
            , fontsize 16
            , lineHeight 1.7
            ]
    , large =
        Style.mix
            [ font "'Noto Sans', Georgia"
            , fontsize 22
            , lineHeight 1.2
            ]
    }
