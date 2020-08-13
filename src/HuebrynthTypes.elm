module HuebrynthTypes exposing (..)

import List.Extra exposing (find)
import List exposing (concat, indexedMap)
import Maybe

type alias NodeId = Int
type NodeType = Start | Empty | End
type alias Occupied = Bool
type Node = Node NodeId NodeType
type IndexedNode = IndexedNode (Int, Int) Node

type alias Lock = Int
type alias EdgeId = Int
type EdgeType = Open | Gated Lock
type Edge = Edge EdgeId EdgeType Node Node
type alias Board = List (List Node)
type alias Edges = List Edge

boardToIndexedNodes : Board -> List IndexedNode
boardToIndexedNodes board = indexedMap (\i row -> indexedMap (\j node -> IndexedNode (i, j) node) row) board |> concat

getEdgeFromNodeIds : NodeId -> NodeId -> Edges -> Maybe Edge
getEdgeFromNodeIds nodeId1 nodeId2 edges = find (\(Edge _ edgeType (Node id1 _) (Node id2 _)) ->
  (id1 == nodeId1 && id2 == nodeId2) ||
  (id1 == nodeId2 && id2 == nodeId1)
  ) edges

getStartNode : Board -> Int -> NodeId
getStartNode board defaultId =
  let
      maybeNode = find (\(Node id nodeType) -> nodeType == Start) (concat board)
  in
    case maybeNode of
      Nothing -> defaultId
      Just (Node id nodeType) -> id

getNodeXY : Board -> Node -> Maybe (Int, Int)
getNodeXY board (Node id1 _)=
  let
      indexedNodes = indexedMap (\i row -> indexedMap (\j node -> (i, j, node)) row) board |> concat
      maybeIndexedNode = find (\(i, j, (Node id2 nodeType)) -> id1 == id2) indexedNodes
  in
    Maybe.map (\(x, y, _) -> (x, y)) maybeIndexedNode

edgeToPosition : Board -> Edge -> (Float, Float, Bool)
edgeToPosition board (Edge _ edgeType node1 node2)  =
  let
    maybeNodePosition1 = getNodeXY board node1
    maybeNodePosition2 = getNodeXY board node2
  in
    case (maybeNodePosition1, maybeNodePosition2) of
      (Just (x1, y1), Just (x2, y2)) -> (toFloat (x1 + x2) / 2, toFloat (y1 + y2) / 2, x1 == x2)
      _ -> (0, 0, False)
