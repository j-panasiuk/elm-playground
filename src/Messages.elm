module Messages exposing (Msg(..))

import Navigation exposing (Location)
import Types exposing (ScreenPoint)
import Window


type Msg
    = NoOp
    | UrlChange Location
    | NavigateTo String
    | Resize Window.Size
    | CaptureClick ScreenPoint



-- | Game GameMsg
-- | Editor EditorMsg
