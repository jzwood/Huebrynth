module HuebrynthTypes exposing (..)

import List.Extra exposing (find)

type alias NodeId = Int
type NodeType = Start | Empty | End
type alias Occupied = Bool
type Node = Node NodeId NodeType

type alias Lock = Int
type alias EdgeId = Int
type EdgeType = Open | Gated Lock
type Edge = Edge EdgeId EdgeType Node Node
type alias Board = List (List Node)
type alias Edges = List Edge


getEdgeFromNodeIds : NodeId -> NodeId -> Edges -> Maybe Edge
getEdgeFromNodeIds nodeId1 nodeId2 edges = find (\(Edge _ edgeType (Node id1 _) (Node id2 _)) ->
  (id1 == nodeId1 && id2 == nodeId2) ||
  (id1 == nodeId2 && id2 == nodeId1)
  ) edges
