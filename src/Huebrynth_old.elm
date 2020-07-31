module Huebrynth exposing (..)

import Graph exposing (Graph)


-- MODEL

type alias NodeId = Int
type NodeType = Start | Empty | End
type Node = Node NodeId NodeType
type alias Lock = Int
type Edge = Open | Gated Lock

type Maze = Node Edge Node Edge Node


mazeGraph : Graph Node Edge
mazeGraph =
    Graph.empty
        |> Graph.addEdge (Node (Coordinate 0 0) Start) (Node (Coordinate 0 1) Empty) (Gated 3)
        |> Graph.addEdge (Node (Coordinate 0 0) Empty) (Node (Coordinate 1 0) End) Open
        |> Graph.addEdge (Node (Coordinate 1 0) Empty) (Node (Coordinate 1 1) End) Open
        |> Graph.addEdge (Node (Coordinate 0 1) Empty) (Node (Coordinate 1 1) End) Open
