module Game.State exposing (initialState, setMode)

import Types exposing (Game, GameMode(NotStarted), Layer(..))


initialState : Game
initialState =
    { mode = NotStarted
    , canvas =
        { layers = [ BackgroundLayer, MazeLayer ]
        }
    }


setMode : GameMode -> Game -> Game
setMode mode editor =
    { editor | mode = mode }
