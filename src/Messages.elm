module Messages exposing (Msg(..))

import Navigation exposing (Location)
import Types exposing (ScreenPoint)
import Editor.Types as Editor
import Window


type Msg
    = NoOp
    | UrlChange Location
    | NavigateTo String
    | Resize Window.Size
    | CaptureClick ScreenPoint
    | SetEditorMode Editor.Mode



-- | Game GameMsg
-- | Editor EditorMsg
