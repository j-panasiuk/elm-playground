module Utils.Math exposing (..)

import Types exposing (ScreenRect)


ratio : Int -> Int -> Float
ratio x y =
    if y /= 0 then
        (toFloat x) / (toFloat y)
    else
        Debug.crash "Dividing by zero, are we?"


rectRatio : ScreenRect -> Float
rectRatio { width, height } =
    ratio width height


invert : Float -> Float
invert x =
    if x /= 0 then
        1 / x
    else
        Debug.crash "Dividing by zero, are we?"


scale : Float -> Int -> Int
scale coefficient size =
    (floor << (*) coefficient << toFloat) size
