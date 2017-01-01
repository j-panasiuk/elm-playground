module Board.Selection exposing (..)

import Types exposing (..)
import Board.Overlay as Overlay
import Set exposing (Set)


-- INIT


init : EditorMode -> EditorSelection
init mode =
    case mode of
        ShowMaze ->
            NothingToSelect

        ShowNodes ->
            NodeSelection (Single Nothing)

        ShowEdges ->
            EdgeSelection (Multiple Set.empty)

        ShowPath ->
            NodeSelection (Double ( Nothing, Nothing ))



-- UPDATE


{-| Translate selected board point to selectable object and add it to selection.
For now let's assume there is no toggle-select behaviour.
-}
selectPoint : Int -> ScreenPoint -> EditorSelection -> EditorSelection
selectPoint tileSize screenPoint selection =
    case selection of
        NothingToSelect ->
            NothingToSelect

        NodeSelection nodeSelection ->
            NodeSelection (addToSelection nodeSelection (Overlay.toPosition tileSize screenPoint))

        EdgeSelection edgeSelection ->
            EdgeSelection (addToSelection edgeSelection (Overlay.toPositionPair tileSize screenPoint))


addToSelection : Selection comparable -> comparable -> Selection comparable
addToSelection selection value =
    case selection of
        Single _ ->
            Single (Just value)

        Double ( Nothing, Nothing ) ->
            Double ( Just value, Nothing )

        Double ( Just v1, Nothing ) ->
            Double ( Just v1, Just value )

        Double ( Nothing, Just v2 ) ->
            Double ( Just v2, Just value )

        Double ( Just v1, Just v2 ) ->
            Double ( Just v1, Just value )

        Multiple values ->
            Multiple (Set.insert value values)


{-| Check if value is currently selected
-}
isSelected : Set comparable -> comparable -> Bool
isSelected selectedValues v =
    Set.member v selectedValues


{-| Unpack all values from selection into a set
-}
toValues : Selection comparable -> Set comparable
toValues selection =
    case selection of
        Single (Just value) ->
            Set.singleton value

        Single Nothing ->
            Set.empty

        Double ( Just v1, Just v2 ) ->
            Set.fromList [ v1, v2 ]

        Double ( Just v1, Nothing ) ->
            Set.singleton v1

        Double ( Nothing, Just v2 ) ->
            Set.singleton v2

        Double ( Nothing, Nothing ) ->
            Set.empty

        Multiple values ->
            values
