module Routes exposing (Route(..), fromLocation)

import Navigation exposing (Location)
import UrlParser exposing (Parser, (</>), s)


type Route
    = Game
    | Editor


routePatterns : Parser (Route -> a) a
routePatterns =
    UrlParser.oneOf
        [ UrlParser.map Game (s "src" </> s "game")
        , UrlParser.map Editor (s "src" </> s "editor")
        ]


fromLocation : Location -> Maybe Route
fromLocation location =
    UrlParser.parsePath routePatterns location
