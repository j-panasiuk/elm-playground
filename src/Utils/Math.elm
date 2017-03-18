module Utils.Math exposing (..)

import Types exposing (ScreenRect)


ratio : Int -> Int -> Float
ratio x y =
    toFloat x / toFloat y


rectRatio : ScreenRect -> Float
rectRatio { width, height } =
    ratio width height


invert : Float -> Float
invert x =
    1 / x


scale : Float -> Int -> Int
scale coefficient size =
    (floor << (*) coefficient << toFloat) size
