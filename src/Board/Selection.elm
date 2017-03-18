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
            NodeSelection Toggle (Single Nothing)

        ShowEdges ->
            EdgeSelection Add (Multiple Set.empty)

        ShowPath ->
            NodeSelection Toggle (Double ( Nothing, Nothing ))



-- UPDATE


{-| Translate selected board point to selectable object and add it to selection.
For now let's assume there is no toggle-select behaviour.
-}
selectPoint : Graph -> Int -> ScreenPoint -> EditorSelection -> EditorSelection
selectPoint graph tileSize screenPoint selection =
    case selection of
        NothingToSelect ->
            NothingToSelect

        NodeSelection mode nodeSelection ->
            let
                nodeToSelect =
                    Overlay.toNode graph tileSize screenPoint

                updatedSelection =
                    case nodeToSelect of
                        Just node ->
                            handleSelect mode node nodeSelection

                        Nothing ->
                            nodeSelection
            in
                NodeSelection mode updatedSelection

        EdgeSelection mode edgeSelection ->
            let
                edgeToSelect =
                    Overlay.toEdge graph tileSize screenPoint

                updatedSelection =
                    case edgeToSelect of
                        Just edge ->
                            handleSelect mode edge edgeSelection

                        Nothing ->
                            edgeSelection
            in
                EdgeSelection mode updatedSelection


handleSelect : SelectMode -> (comparable -> Selection comparable -> Selection comparable)
handleSelect mode =
    case mode of
        Add ->
            add

        Toggle ->
            toggle


add : comparable -> Selection comparable -> Selection comparable
add value selection =
    case selection of
        Single _ ->
            Single (Just value)

        Double ( Nothing, Nothing ) ->
            Double ( Just value, Nothing )

        Double ( Just v1, Nothing ) ->
            Double ( Just v1, Just value )

        Double ( Nothing, Just v2 ) ->
            Double ( Just v2, Just value )

        Double ( Just v1, Just _ ) ->
            Double ( Just v1, Just value )

        Multiple values ->
            Multiple (Set.insert value values)


toggle : comparable -> Selection comparable -> Selection comparable
toggle value selection =
    case selection of
        Single Nothing ->
            Single (Just value)

        Single (Just v) ->
            Single
                (if value == v then
                    Nothing
                 else
                    Just value
                )

        Double ( Nothing, Nothing ) ->
            Double ( Just value, Nothing )

        Double ( Just v1, Nothing ) ->
            Double
                (if value == v1 then
                    ( Nothing, Nothing )
                 else
                    ( Just v1, Just value )
                )

        Double ( Nothing, Just v2 ) ->
            Double
                (if value == v2 then
                    ( Nothing, Nothing )
                 else
                    ( Just v2, Just value )
                )

        Double ( Just v1, Just v2 ) ->
            Double
                (if value == v1 then
                    ( Just v2, Nothing )
                 else if value == v2 then
                    ( Just v1, Nothing )
                 else
                    ( Just v1, Just value )
                )

        Multiple values ->
            Multiple
                (if Set.member value values then
                    Set.remove value values
                 else
                    Set.insert value values
                )


{-| Check if value is currently selected
-}
isSelected : Set comparable -> comparable -> Bool
isSelected selectedValues v =
    Set.member v selectedValues


{-| Unpack all values from selection into a set
-}
toSet : Selection comparable -> Set comparable
toSet selection =
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


{-| Unpack all values from selection into a list
-}
toList : Selection comparable -> List comparable
toList =
    toSet >> Set.toList
