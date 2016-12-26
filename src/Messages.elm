module Messages exposing (Msg(..))

import Navigation exposing (Location)
import Types exposing (ScreenPoint, EditorMode)
import Window


type Msg
    = NoOp
    | UrlChange Location
    | NavigateTo String
    | Resize Window.Size
    | SetEditorMode EditorMode
    | ClickEditorBoard ScreenPoint



-- | Game GameMsg
-- | Editor EditorMsg
