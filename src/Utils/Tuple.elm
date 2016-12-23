module Utils.Tuple exposing (..)


flip : ( a, b ) -> ( b, a )
flip ( x, y ) =
    ( y, x )


map : (a -> b) -> ( a, a ) -> ( b, b )
map func ( x, y ) =
    ( func x, func y )


both : (a -> Bool) -> ( a, a ) -> Bool
both func ( x, y ) =
    func x && func y


sort : ( comparable, comparable ) -> ( comparable, comparable )
sort ( x, y ) =
    if x <= y then
        ( x, y )
    else
        ( y, x )


middle : ( ( Float, Float ), ( Float, Float ) ) -> ( Float, Float )
middle ( ( ax, ay ), ( bx, by ) ) =
    ( (ax + bx) / 2, (ay + by) / 2 )


map1 : (a -> b) -> ( List a, List a ) -> ( List b, List b )
map1 func ( xs, ys ) =
    ( List.map func xs, List.map func ys )


map2 : (a -> b) -> (a -> b) -> ( List a, List a ) -> ( List b, List b )
map2 mapFirst mapSecond ( xs, ys ) =
    ( List.map mapFirst xs, List.map mapSecond ys )


concat : ( List a, List a ) -> List a
concat ( xs, ys ) =
    List.append xs ys
